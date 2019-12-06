class FavoritesController < ApplicationController
	def create
		@song = Song.find(params[:song_id])
		unless @song.good?(current_user)
			# いいねを追加
			@song.good(current_user)
			#アイコンの切り替え時に必要
			@song.reload
			# 以下は非同期通信
			respond_to do |format|
				format.html {redirect_to request.referrer || root_url}
				format.js
			end
		end
	end

	def destroy
		@song = Song.find(params[:song_id])
		if @song.good?(current_user)
			#いいねを削除
			@song.ungood(current_user)
			#アイコンの切り替え時に必要
			@song.reload
			# 以下は非同期通信
			respond_to do |format|
				format.html {redirect_to request.referrer || root_url}
				format.js
			end
		end
	end
end
