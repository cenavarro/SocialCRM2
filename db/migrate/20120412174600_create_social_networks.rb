class CreateSocialNetworks < ActiveRecord::Migration
  def change
    create_table :social_networks do |t|
      t.string :name
      t.integer :client_id
      t.integer :info_social_network_id
      t.integer :social_network_id

      t.timestamps
    end
  end
end
