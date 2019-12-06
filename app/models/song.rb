class Song < ApplicationRecord
require 'google/apis/youtube_v3'
has_many :comments
has_many :favorites, dependent: :destroy

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
end
