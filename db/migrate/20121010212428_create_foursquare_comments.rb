class CreateFoursquareComments < ActiveRecord::Migration
  def change
    create_table :foursquare_comments do |t|
      t.integer :social_network_id
      t.text :table
      t.text :followers
      t.text :deals

      t.timestamps
    end
  end
end
