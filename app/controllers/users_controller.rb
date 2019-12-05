class UsersController < ApplicationController

	def show
		@user = User.find(customer_user.id)
	end
end
