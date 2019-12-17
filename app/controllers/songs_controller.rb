# frozen_string_literal: true

class SongsController < ApplicationController
  # 曲詳細の閲覧数をカウント
  impressionist actions: [:show]

  def index
    @songs = Song.all
    # ランキング(いいね)
    @favorite_ranks = Song.find(Favorite.group(:song_id).order('count(song_id) desc').limit(3).pluck(:song_id))
    # ランキング(閲覧数)
    @view_ranks = Song.order('impressions_count DESC').limit(3)
  end

  def show
    @song = Song.find(params[:id])
    @comment = Comment.new
    @comments = @song.comments.page(params[:page]).per(12)
    @artists = Song.where(artist: @song.artist)
  end

  def new
    @song = Song.new
    # searchに値が入ってたらAPIを叩く
    if (query = params[:search]).present?
      @data = find_videos(query)
      @lyrics = search_track(query)
    end
  end

  def create
    @song = Song.new(song_params)
    @song.user_id = current_user.id
    @song.vid = song_params[:vid]
    @song.name = song_params[:name]
    @song.image = song_params[:image]
    if @song.save
      redirect_to song_path(@song.id)
    else
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

  def search_track(keyword)
    MusixMatch::API::Base.api_key = ENV['MISIX_API_KEY']
    result = MusixMatch.search_track(:q => keyword, :f_has_lyrics => 1)
    if result.status_code == 200 && lyrics = result.track_list.first
      lyrics.track_id
      find_lyrics(lyrics.track_id)
    end
  end

  def find_lyrics(track_id)
    result = MusixMatch.get_lyrics(track_id)
    if result.status_code == 200 && lyrics = result.lyrics
      lyrics
    end
  end

  # 検索機能
  def search_results
    @q = Song.search(search_params)
    @songs = @q.result(distinct: true)
  end

  private

  def song_params
    params.require(:song).permit(:name, :artist, :description, :vid, :user_id, :image)
  end

  def search_params
    params.require(:q).permit(:sorts, :name_or_artist_cont)
  end
end
