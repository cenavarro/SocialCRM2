class CreatePinterestData < ActiveRecord::Migration
  def change
    create_table :pinterest_data do |t|
      t.integer :new_followers
      t.integer :total_followers
      t.integer :boards
      t.integer :pins
      t.integer :liked
      t.integer :repin
      t.integer :comments
      t.integer :community_boards
      t.float :investment_agency
      t.float :investment_actions
      t.float :investment_ads
      t.integer :client_id
      t.date :start_date
      t.date :end_date
      t.integer :social_network_id

      t.timestamps
    end
  end
end
