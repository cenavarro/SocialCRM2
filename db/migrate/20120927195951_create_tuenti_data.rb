class CreateTuentiData < ActiveRecord::Migration
  def change
    create_table :tuenti_data do |t|
      t.integer :client_id
      t.integer :social_network_id
      t.date :start_date
      t.date :end_date
      t.integer :new_fans
      t.integer :real_fans
      t.integer :goal_fans
      t.float :investment_agency
      t.float :investment_actions
      t.float :investment_ads
      t.float :cost_fan
      t.integer :page_prints
      t.integer :unique_total_users
      t.integer :external_clics
      t.integer :clics
      t.integer :downloads
      t.integer :comments
      t.float :ctr_external_clics
      t.integer :upload_photos

      t.timestamps
    end
  end
end
