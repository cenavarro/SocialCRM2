class CreateGooglePlusData < ActiveRecord::Migration
  def change
    create_table :google_plus_data do |t|
      t.integer :client_id
      t.integer :social_network_id
      t.date :start_date
      t.date :end_date
      t.integer :new_followers
      t.integer :total_followers
      t.integer :plus
      t.integer :content_shared
      t.integer :total_interactions
      t.float :investment_agency
      t.float :investment_actions
      t.float :investment_ads

      t.timestamps
    end
  end
end
