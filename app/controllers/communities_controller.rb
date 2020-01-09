# frozen_string_literal: true

class CommunitiesController < ApplicationController
  before_action :find_community, only: %i[show join unjoin destroy edit update]

  def index
    @communities = Community.all
  end

  def show
    @user = CommunityUser.find_by(params[user_id: current_user.id, community_id: @community.id])
    @members = @community.users.order(id: 'DESC')
    @comment = CommunityComment.new
    @comments = @community.community_comments.includes(:user).order(id: 'DESC')
  end

  def new
    @community = Community.new
  end

  def edit; end

  def update
    if @community.update(community_update)
      flash[:success] = 'Community has been updated'
      redirect_to community_path(@community.id)
    else
      flash.now[:alert] = "Community hasn't been updated"
      render :edit
    end
  end

  def create
    @community = Community.new(community_params)
    @com_user = CommunityUser.new(user_id: current_user.id)
    @community.community_users << @com_user
    if @community.save
      flash[:success] = 'Community is created'
      @members = @community.users
      @comments = @community.community_comments
      redirect_to community_path(@community.id)
    else
      flash.now[:alert] = "Community can't be created"
      render :new
    end
  end

  def destroy
    @user = CommunityUser.find_by(params[user_id: current_user.id, community_id: @community.id])
    if current_user.id == @user.id
      @community.destroy
    else
      render :show
    end
  end

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
    params.require(:community).permit(:name, :description, :community_image, community_attributes: %i[user_id community_id])
  end

  def community_update
    params.require(:community).permit(:name, :description, :community_image)
  end
end
