class CreateFoursquareData < ActiveRecord::Migration
  def change
    create_table :foursquare_data do |t|
      t.integer :client_id
      t.integer :social_network_id
      t.date :start_date
      t.date :end_date
      t.integer :new_followers
      t.integer :total_followers
      t.integer :total_unlocks
      t.integer :total_visits

      t.timestamps
    end
  end
end
