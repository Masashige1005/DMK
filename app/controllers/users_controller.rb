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

	def following
		@user = User.find(params[:id])
		# このユーザーがフォローしているユーザーを取得
		@follows = @user.all_following
	end

	def followed
		@user = User.find(params[:id])
		# このユーザーがフォローされているユーザーを取得
		@follows = @user.followers
	end
end
