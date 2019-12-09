# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :favorites, dependent: :destroy
  has_many :comments
  has_many :songs

  has_many :communities, through: :community_users
  has_many :community_users

  acts_as_followable # フォロワー機能
  acts_as_follower   # フォロー機能
end
