class CreateTumblrComments < ActiveRecord::Migration
  def change
    create_table :tumblr_comments do |t|
      t.integer :social_network_id
      t.text :table
      t.text :followers
      t.text :interactivity
      t.text :investment

      t.timestamps
    end
  end
end
