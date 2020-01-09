# frozen_string_literal: true
class CommunityUsersController < ApplicationController
  before_action :find_community, only: %i[create destroy]
  def create
    unless @community.join?(current_user)
      @community.join(current_user)
      @community.reload
      respond_to do |format|
        format.html { redirect_to request.referrer || root_url }
        format.js
      end
    end
  end

  def destroy
    if @community.join?(current_user)
      @community.unjoin(current_user)
      @community.reload
      respond_to do |format|
        format.html { redirectr_to request_referrer || root_url }
        format.js
      end
    end
  end

  def find_community
    @community = Community.find(params[:community_id])
  end
end
