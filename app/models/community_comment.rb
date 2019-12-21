class CommunityComment < ApplicationRecord
  # optional: true (外部キーを許可)
  belongs_to :user, optional: true
  belongs_to :community, optional: true

  validates :body, presence: true,length: {maximum: 200}
end
