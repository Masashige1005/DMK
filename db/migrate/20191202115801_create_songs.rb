class CreateSongs < ActiveRecord::Migration[5.2]
  def change
    create_table :songs do |t|
      t.string :name, null: false
      t.string :artist, null: false
      t.string :video_id, null: false
      t.text :description, null: false

      t.timestamps
    end
  end
end
