# frozen_string_literal: true
class CreateCommunityComments < ActiveRecord::Migration[5.2]
  def change
    create_table :community_comments do |t|
      t.text :body
      t.integer :user_id
      t.integer :community_id

      t.timestamps
    end
  end
end
