# frozen_string_literal: true

class AddFavoritesCountToSongs < ActiveRecord::Migration[5.2]
  class MigrationUser < ApplicationRecord
    self.table_name = :microposts
  end

  def up
    _up
  rescue StandardError => e
    _down
    raise e
  end

  def down
    _down
  end

  private

  def _up
    MigrationUser.reset_column_information

    unless column_exists? :songs, :favorites_count
      add_column :songs, :favorites_count, :integer, null: false, default: 0
    end
  end

  def _down
    MigrationUser.reset_column_information

    if column_exists? :songs, :favorites_count
      remove_column :songs, :favorites_count
    end
  end
end
