# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :find_user, only: %i[show update follow unfollow following followed]
  def show
    @favorites = @user.favorites
    @songs = @user.songs
  end

  def update
  	if @user.update(user_params)
  		redirect_to user_path(@user.id)
  	else
  		render :show
  	end
  end

  def follow
    # ログイン中のユーザーで対象のユーザー(@user)をフォローする
    current_user.follow(@user)
  end

  def unfollow
    # ログイン中のユーザーで対象のユーザー(@user)をフォロー解除する
    current_user.stop_following(@user)
  end

  def following
    # このユーザーがフォローしているユーザーを取得
    @follows = @user.all_following
  end

  def followed
    # このユーザーがフォローされているユーザーを取得
    @follows = @user.followers
  end

  def find_user
    @user = User.find(params[:id])
  end

  private

  def user_params
  	params.require(:user).permit(:name, :introduction, :profile_image, :email)
  end
end
