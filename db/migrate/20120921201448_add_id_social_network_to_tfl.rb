class AddIdSocialNetworkToTfl < ActiveRecord::Migration
  def self.up
    add_column :twitter_data, :id_social_network, :integer
    add_column :facebook_data, :id_social_network, :integer
    add_column :linkedin_data, :id_social_network, :integer
  end

  def self.down
    remove_column :twitter_data, :id_social_network
    remove_column :facebook_data, :id_social_network
    remove_column :linkedin_data, :id_social_network
  end
end
