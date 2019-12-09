# frozen_string_literal: true

class Community < ApplicationRecord
  has_many :users, through: :community_users
  has_many :community_users
  # communityが更新された際に同時にcommunity_usersも更新
  accepts_nested_attributes_for :community_users
end
