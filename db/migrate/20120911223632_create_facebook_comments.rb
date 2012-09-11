class CreateFacebookComments < ActiveRecord::Migration
  def change
    create_table :facebook_comments do |t|
      t.integer :social_network_id
      t.string :table
      t.string :fans
      t.string :interaction
      t.string :investment
      t.string :cost

      t.timestamps
    end

    add_index "facebook_comments", ["social_network_id"], :name => "index_facebook_comments_on_social_network", :unique => true

  end
end
