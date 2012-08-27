class AddRequireFields < ActiveRecord::Migration
  def up
  	change_column :info_social_networks, :name, :string, :null => false
  	change_column :social_networks, :name, :string, :null => false
  	change_column :social_networks, :client_id, :integer, :null => false
  	change_column :social_networks, :info_social_network_id, :integer, :null => false
  	remove_column :social_networks, :social_network_id
  end

  def down
  	change_column :info_social_networks, :name, :string
  	change_column :social_networks, :name, :string
  	change_column :social_networks, :client_id, :integer
  	change_column :social_networks, :info_social_network_id, :integer
  	add_column :social_networks, :social_network_id, :integer, :null => false
  end
end
