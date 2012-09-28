class CreateFlickrData < ActiveRecord::Migration
  def change
    create_table :flickr_data do |t|
      t.integer :client_id
      t.integer :social_network_id
      t.date :start_date
      t.date :end_date
      t.integer :new_contacts
      t.integer :total_contacts
      t.integer :visits
      t.integer :comments
      t.integer :favorites
      t.float :investment_agency
      t.float :investment_actions
      t.float :investment_ads

      t.timestamps
    end
  end
end
