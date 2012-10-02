class CreateTumblrData < ActiveRecord::Migration
  def change
    create_table :tumblr_data do |t|
      t.integer :client_id
      t.integer :social_network_id
      t.date :start_date
      t.date :end_date
      t.integer :new_followers
      t.integer :total_followers
      t.integer :likes
      t.integer :reblogged
      t.float :investment_agency
      t.float :investment_actions
      t.float :investment_ads

      t.timestamps
    end
  end
end
