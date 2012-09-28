class CreateFlickrComments < ActiveRecord::Migration
  def change
    create_table :flickr_comments do |t|
      t.integer :social_network_id
      t.text :table
      t.text :community
      t.text :interaction
      t.text :investment

      t.timestamps
    end
  end
end
