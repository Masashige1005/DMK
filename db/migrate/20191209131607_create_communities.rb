# frozen_string_literal: true

class CreateCommunities < ActiveRecord::Migration[5.2]
  def change
    create_table :communities do |t|
      t.string :name, null: false, unique: true

      t.timestamps
    end
  end
end
