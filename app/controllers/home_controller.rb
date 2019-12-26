class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[about]

  def about
  end
end
