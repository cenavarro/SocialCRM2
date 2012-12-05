class AddNewFieldsToFoursquare < ActiveRecord::Migration
  def self.up
    add_column :foursquare_data, :clients, :integer
    add_column :foursquare_data, :likes, :integer
    add_column :foursquare_data, :checkins, :integer
    add_column :foursquare_comments, :interactivity, :string
  end

  def self.down
    remove_column :foursquare_data, :clients
    remove_column :foursquare_data, :likes
    remove_column :foursquare_data, :checkins
    remove_column :foursquare_comments, :interactivity
  end
end
