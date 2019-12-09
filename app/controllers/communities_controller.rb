# frozen_string_literal: true

class CommunitiesController < ApplicationController
  def index
    @communities = Community.all
  end

  def show
    @community = Community.find(params[:id])
  end

  def create
    @community = Community.new
  end

  def destroy; end
end
