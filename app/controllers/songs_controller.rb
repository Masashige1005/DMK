# frozen_string_literal: true

class SongsController < ApplicationController
  # 曲詳細の閲覧数をカウント
  impressionist actions: [:show]
  require 'itunes-search-api'
  skip_before_action :authenticate_user!, only: [:index, :show, :search_results]

  def index
    @songs = Song.all.order(id: "DESC")
    # ランキング(いいね)
    @favorite_ranks = Song.find(Favorite.group(:song_id).order('count(song_id) desc').limit(3).pluck(:song_id))
    # ランキング(閲覧数)
    @view_ranks = Song.order('impressions_count DESC').limit(3)
  end

  def show
    @song = Song.find(params[:id])
    @comment = Comment.new
    @comments = @song.comments.page(params[:page]).per(10).order(id: "DESC")
    @artists = Song.where(artist: @song.artist)
  end

  def new
    @song = Song.new
    # searchに値が入ってたらAPIを叩く
    if params[:search].present?
      query = params[:search]
      @data = find_videos(query)
      @lylics = find_lylics(query)
      @ituens = ituens_search(query)
    end
  end

  def create
    @song = Song.new(song_params)
    @song.user_id = current_user.id
    @song.vid = song_params[:vid]
    @song.name = song_params[:name]
    @song.image = song_params[:image]
    if @song.save
      flash[:success] = '楽曲が投稿されました'
      redirect_to song_path(@song.id)
    else
      flash.now[:alert] = '楽曲が投稿できませんでした'
      @song = Song.new(song_params)
      render :new
    end
  end

  # Youtube data v3の動画検索は以下の処理でやってます。
  def find_videos(keyword, after: 10.years.ago, before: Time.now)
    service = Google::Apis::YoutubeV3::YouTubeService.new
    service.key = ENV['GOOGLE_API_KEY']

    next_page_token = nil
    opt = {
      q: keyword,
      type: 'video',
      # 検索結果はキーワードの関連性の高い上位1件のみ取得します。
      max_results: 1,
      # キーワードと関連性の高い順で絞り込み
      order: :relevance,
      page_token: next_page_token,
      published_after: after.iso8601,
      published_before: before.iso8601
    }
    service.list_searches(:snippet, opt)
  end

  def ituens_search(keyword)
    ITunesSearchAPI.search(
     :term => keyword,
     :media => 'music',
     :lang => 'ja_jp',
     :limit => '1'
     ).each do |item|
       p item
      @track = item['trackViewUrl']
      @artist = item['artistViewUrl']
     end
   end

  def find_lylics(keyword)
    Genius.access_token = ENV['GENIUS_API_KEY']
    Genius.text_format = "html"
    songs = Genius::Song.search(keyword)
    lylics = songs.first
    lylics.title
    lylics.primary_artist.name
    pp lylics
  end

  # 検索機能
  def search_results
    @q = Song.search(search_params)
    @songs = @q.result(distinct: true)
  end

  private

  def song_params
    params.require(:song).permit(:name, :artist, :description, :vid, :user_id, :image, :lylics_url, :track_url, :artist_url)
  end

  def search_params
    params.require(:q).permit(:sorts, :name_or_artist_cont)
  end
end
