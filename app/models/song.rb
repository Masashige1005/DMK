# frozen_string_literal: true

class Song < ApplicationRecord
  require 'google/apis/youtube_v3'

  has_many :comments
  has_many :favorites, dependent: :destroy
  belongs_to :user

  is_impressionable

  # 商品にいいね
  def good(user)
    favorites.create(user_id: user.id)
  end

  def ungood(user)
    favorites.find_by(user_id: user.id).destroy
  end

  def good?(user)
    user_ids = favorites.pluck(:user_id)
    user_ids.include?(user.id)
  end

  validates :name, presence: true, uniqueness: true
  validates :artist, presence: true
  validates :description, presence: true, length: { maximum: 300 }
  validates :image, presence: true
  validates :lylics_url, presence: true
  validates :track_url, presence: true
  validates :artist_url, presence: true
end
