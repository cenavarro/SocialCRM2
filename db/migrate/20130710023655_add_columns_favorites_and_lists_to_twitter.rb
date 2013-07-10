class AddColumnsFavoritesAndListsToTwitter < ActiveRecord::Migration
  def up
    add_column :twitter_data, :favorites, :integer, default: 0
    add_column :twitter_data, :lists, :integer, default: 0
  end

  def down
    remove_column :twitter_data, :favorites
    remove_column :twitter_data, :lists
  end
end
