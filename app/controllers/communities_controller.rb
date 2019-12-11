# frozen_string_literal: true

class CommunitiesController < ApplicationController
  before_action :find_community, only: %i[show follow unfollow]

  def index
    @communities = Community.all
  end

  def show
  end

  def new
    @community = Community.new
  end

  def create
    @community = Community.new(community_params)
    if @community.save
      redirect_to community_path(@community.id)
    else
      render :new
    end
  end

  def destroy; end

  def follow
    #ログイン中のユーザーで対象のコミュニティを参加する
    current_user.follow(@community)
end

def unfollow
    #ログイン中のユーザーで対象のコミュニティを参加解除する
    current_user.stop_following(@community)
end

  def find_community
    @community = Community.find(params[:id])
  end

  private

  def community_params
    params.require(:community).permit(:name, :description)
  end
end
