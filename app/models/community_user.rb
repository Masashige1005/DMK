# frozen_string_literal: true

class CommunityUser < ApplicationRecord
  belongs_to :user
  belongs_to :community
end
