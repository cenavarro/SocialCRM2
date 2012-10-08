class CreateCampaignComments < ActiveRecord::Migration
  def change
    create_table :campaign_comments do |t|
      t.integer :social_network_id
      t.text :table

      t.timestamps
    end
  end
end
