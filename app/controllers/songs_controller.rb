# frozen_string_literal: true

class SongsController < ApplicationController
  # 曲詳細の閲覧数をカウント
  impressionist actions: [:show]
  require 'itunes_search_api'
  skip_before_action :authenticate_user!, only: %i[index search_results]
  before_action :find_song, only: %i[show update edit destroy]

  def index
    @songs = Song.all.order(id: 'DESC')
    @favorite_ranks = Song.find(Favorite.group(:song_id).order('count(song_id) desc').limit(3).pluck(:song_id))
    @view_ranks = Song.order('impressions_count DESC').limit(3)
  end

  def show
    @history = @song.browsing_histories.new
    @history.user_id = current_user.id
    @history.song_id = @song.id
    # 同一ユーザーの閲覧履歴に同じ楽曲の履歴をいくつも残さないようにする。
    if current_user.browsing_histories.exists?(song_id: "#{params[:id]}")
      @old_history = current_user.browsing_histories.find_by(song_id: "#{params[:id]}")
      @old_history.destroy
    end
    @history.save
    # 閲覧履歴の保存数を50に設定し、一番古い履歴を削除していく。
    @histories_stock_limit = 50
    @histories = current_user.browsing_histories.all
    if @histories.count > @histories_stock_limit
      histories[0].destroy
    end
    @comment = Comment.new
    @comments = @song.comments.includes(:user).order(id: 'DESC')
    @artists = Song.where(artist: @song.artist)
  end

  def new
    @song = Song.new
    if params[:track].present? && params[:artist].present?
      query = "#{params[:track]} #{params[:artist]}"
      @data = find_videos(query)
      @lylics = find_lylics(query)
      @ituens = ituens_search(query)
    end
  end

  def edit; end

  def update
    if @song.update(song_update)
      flash[:success] = 'Song has been updated'
      redirect_to song_path(@song.id)
    else
      flash[:danger] = "Song hasn't been updated"
      render :edit
    end
  end

  def destroy
    if current_user.id == @song.user_id
      @song.destroy
      flash[:success] = 'Song is deleted'
      redirect_to songs_path
    else
      flash[:danger] = "Song can't be deleted"
      render :show
    end
  end

  def create
    @song = Song.new(song_params)
    @song.user_id = current_user.id
    @song.vid = song_params[:vid]
    @song.name = song_params[:name]
    @song.image = song_params[:image]
    if @song.save
      flash[:success] = 'Song has been uploaded'
      redirect_to song_path(@song.id)
    else
      flash.now[:danger] = "Sonh hasn't been uploaded"
      @song = Song.new(song_params)
      render :new
    end
  end

  # Youtube data v3の動画検索は以下の処理でやってます。
  def find_videos(keyword)
    service = Google::Apis::YoutubeV3::YouTubeService.new
    service.key = ENV['GOOGLE_API_KEY']

    next_page_token = nil
    opt = {
      q: keyword,
      type: 'video',
      max_results: 1,
      order: :relevance, # キーワードと関連性の高い順で絞り込み
      page_token: next_page_token,
      published_after: 10.years.ago.iso8601,
      published_before: Time.now.iso8601
    }
    service.list_searches(:snippet, opt)
  end

  def ituens_search(keyword)
    ITunesSearchAPI.search(
      term: keyword,
      media: 'music',
      lang: 'ja_jp',
      limit: '1'
    ).each do |item|
      @track = item['trackViewUrl']
      @artist = item['artistViewUrl']
    end
  end

  def find_lylics(keyword)
    Genius.access_token = ENV['GENIUS_API_KEY']
    songs = Genius::Song.search(keyword)
    lylics = songs.first
    lylics.title
    lylics.primary_artist.name
    pp lylics
  end

  def search_results
    @q = Song.search(search_params)
    @songs = @q.result(distinct: true)
  end

  def find_song
    @song = Song.find(params[:id])
  end

  def browsing_histories_action()

  end

  private

  def song_params
    params.require(:song).permit(:name, :artist, :description, :vid, :user_id, :image, :lylics_url, :track_url, :artist_url)
  end

  def search_params
    params.require(:q).permit(:sorts, :name_or_artist_cont)
  end

  def song_update
    params.require(:song).permit(:description)
  end
end
