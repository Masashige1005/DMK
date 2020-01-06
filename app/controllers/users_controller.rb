# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :find_user, only: %i[show update follow unfollow following followed]
  before_action :ensure_correct_user, only: %i[update following followed]
  def show
    @favorites = @user.favorites.includes(:song).order(id: "DESC")
    @songs = @user.songs.order(id: "DESC")
  end

  def update
    if @user.update(user_params)
      flash[:success] = "User infomation has been updated"
      redirect_to user_path(@user.id)
    else
      flash.now[:danger] = "User infomation hasn't been updated"
      @favorites = @user.favorites.includes(:song).order(id: "DESC")
      @songs = @user.songs.order(id: "DESC")
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
    @follows = @user.all_following(order: "follows.id DESC")
  end

  def followed
    # このユーザーがフォローされているユーザーを取得
    @follows = @user.followers
  end

  def find_user
    @user = User.find(params[:id])
  end

  def ensure_correct_user
    #ユーザーIDのチェックするよ！
    unless @user.id == current_user.id
      redirect_to user_path(current_user)
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image, :email)
  end
end
