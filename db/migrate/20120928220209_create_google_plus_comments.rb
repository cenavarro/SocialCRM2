class CreateGooglePlusComments < ActiveRecord::Migration
  def change
    create_table :google_plus_comments do |t|
      t.integer :social_network_id
      t.text :table
      t.text :community
      t.text :interaction
      t.text :investment

      t.timestamps
    end
  end
end
