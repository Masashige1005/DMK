require 'google/apis/youtube_v3'

class SongsController < ApplicationController

	def index
		@songs = Song.all
	end

	def show
		@song = Song.find(params[:id])
		@comment = Comment.new
    	@comments = @song.comments
	end

	def new
		@song = Song.new
		if (query = params[:search]).present?
			@data = find_videos(query)
		end
	end

	private

	def find_videos(keyword, after: 1.months.ago, before: Time.now)
	    service = Google::Apis::YoutubeV3::YouTubeService.new
	    service.key = ENV['GOOGLE_API_KEY']

	    next_page_token = nil
	    opt = {
	      q: keyword,
	      type: 'video',
	      max_results: 1,
	      order: :viewCount,
	      page_token: next_page_token,
	      published_after: after.iso8601,
	      published_before: before.iso8601
	    }
	    service.list_searches(:snippet, opt)
	end



	private
	def song_params
		params.require(:song).permit(:name, :artist, :description)
	end
end
