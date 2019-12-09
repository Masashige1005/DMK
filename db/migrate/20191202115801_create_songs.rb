# frozen_string_literal: true

class CreateSongs < ActiveRecord::Migration[5.2]
  def change
    create_table :songs do |t|
      t.string :name
      t.string :artist, null: false
      t.string :vid
      t.text :description, null: false
      t.integer :user_id, null: false
      t.text :image
      t.integer :impressions_count, default: 0

      t.timestamps
    end
  end
end
