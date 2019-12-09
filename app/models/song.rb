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

  # Youtube data v3の動画検索は以下の処理でやってます。
  def find_videos(keyword, after: 10.years.ago, before: Time.now)
    service = Google::Apis::YoutubeV3::YouTubeService.new
    service.key = ENV['GOOGLE_API_KEY']

    next_page_token = nil
    opt = {
      q: keyword,
      type: 'video',
      # 検索結果はキーワードの関連性の高い上位1件のみ取得します。
      max_results: 1,
      # キーワードと関連性の高い順で絞り込み
      order: :relevance,
      page_token: next_page_token,
      published_after: after.iso8601,
      published_before: before.iso8601
    }
    service.list_searches(:snippet, opt)
  end
end
