class AddPostFieldToTumblr < ActiveRecord::Migration
  def up
    remove_column :tumblr_data, :new_followers
    add_column :tumblr_data, :posts, :integer
  end

  def down 
    add_column :tumblr_data, :new_followers, :integer
    remove_column :tumblr_data, :posts
  end
end
