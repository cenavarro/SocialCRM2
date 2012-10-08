class CreateRowsCampaigns < ActiveRecord::Migration
  def change
    create_table :rows_campaigns do |t|
      t.string :name
      t.integer :social_network_id

      t.timestamps
    end
  end
end
