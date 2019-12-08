class UsersController < ApplicationController

	def show
		@user = User.find(params[:id])
		@favorites = @user.favorites.page(params[:page]).per(5)
		@songs = @user.songs.page(params[:page]).per(5)
	end

	def follow
    	@user = User.find(params[:id])
    	#ログイン中のユーザーで対象のユーザー(@user)をフォローする
    	current_user.follow(@user)
	end

	def unfollow
    	@user = User.find(params[:id])
    	#ログイン中のユーザーで対象のユーザー(@user)をフォロー解除する
    	current_user.stop_following(@user)
	end
end
