# frozen_string_literal: true

class CommunitiesController < ApplicationController
  before_action :find_community, only: %i[show join unjoin]

  def index
    @communities = Community.all
  end

  def show
      @user = CommunityUser.find_by(params[user_id: current_user.id, community_id: @community.id])
      @members = @community.users
  end

  def new
    @community = Community.new
  end

  def create
    @community = Community.new(community_params)
    @community.community_users.build
    if @community.save
      redirect_to community_path(@community.id)
    else
      render :new
    end
  end

  def destroy; end

  def join
    community_users.create(user_id: current_user.id, community_id: @community.id)
  end

  def unjoin
    community_users.find_by(user_id: current_user.id, community_id: @community.id).destroy
  end

  def join?
    CommunityUser.where(user_id: current_user.id).ids.present?
  end

  def find_community
    @community = Community.find(params[:id])
  end

  private

  def community_params
    params.require(:community).permit(:name, :description, :community_image, community_attributes: [:user_id, :community_id])
  end

  def join_params
    params.require(:community).permit(:name)
  end
end
