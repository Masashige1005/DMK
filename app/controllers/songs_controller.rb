# frozen_string_literal: true

class SongsController < ApplicationController
  # 曲詳細の閲覧数をカウント
  impressionist actions: [:show]

  def index
    @songs = Song.all
    # ランキング(いいね)
    @all_ranks = Song.find(Favorite.group(:song_id).order('count(song_id) desc').limit(3).pluck(:song_id))
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
