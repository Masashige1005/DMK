class Favorite < ApplicationRecord
	belongs_to :user
	belongs_to :song
	counter_culture :song
end
