class AddNewFieldsToYoutube < ActiveRecord::Migration
  def up
    remove_column :youtube_data, :new_subscriber
    add_column :youtube_data, :likes, :integer
    add_column :youtube_data, :no_likes, :integer
    add_column :youtube_data, :favorite, :integer
    add_column :youtube_data, :comments, :integer
    add_column :youtube_data, :shared, :integer
    add_column :youtube_comments, :interaction_2, :text
  end

  def down 
    add_column :youtube_data, :new_subscriber, :integer
    remove_column :youtube_data, :likes
    remove_column :youtube_data, :no_likes
    remove_column :youtube_data, :favorite
    remove_column :youtube_data, :comments
    remove_column :youtube_data, :shared
    remove_column :youtube_comments, :interaction_2
  end
end
