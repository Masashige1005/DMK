# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :song

  validates :content, presence: true, length: { maximum: 200 }
end
