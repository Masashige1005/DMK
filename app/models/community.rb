# frozen_string_literal: true

class Community < ApplicationRecord
  has_many :community_users
  has_many :users, through: :community_users
  # communityが更新された際に同時にcommunity_usersも更新
  accepts_nested_attributes_for :community_users

  acts_as_follower   # フォロー機能
  acts_as_followable # フォロワー機能

  attachment :community_image

  # コミュ二ティ参加
  def join(user)
  	community_users.create(user_id: user.id, community_id: self.id)
  end

  def unjoin(user)
  	community_users.find_by(user_id: user.id, community_id: self.id).destroy
  end

  def join?(user)
    community_users.where(user_id: user.id).ids.present?
  end
end
