# frozen_string_literal: true

class CreateSongs < ActiveRecord::Migration[5.2]
  def change
    create_table :songs do |t|
      t.string :name, null: false
      t.string :artist, null: false
      t.string :vid, null: false
      t.text :description, null: false
      t.integer :user_id, null: false
      t.text :image, null: false
      t.integer :impressions_count, default: 0
      t.text :lylics_url
      t.text :track_url
      t.text :artist_url

      t.timestamps
    end
  end
end
