class SongsController < ApplicationController
	# 曲詳細の閲覧数をカウント
	impressionist :actions=> [:show]

	def index
		@songs = Song.all
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

	def song_params
		params.require(:song).permit(:name, :artist, :description, :vid, :user_id, :image)
	end

	def search_params
      params.require(:q).permit(:sorts, :name_or_artist_cont )
    end
end
