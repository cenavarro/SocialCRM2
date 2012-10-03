class RenameIdSocialNetworkFromFacebookTwitterLinkedin < ActiveRecord::Migration
  def up
    rename_column :facebook_data, :id_social_network, :social_network_id
    rename_column :twitter_data, :id_social_network, :social_network_id
    rename_column :linkedin_data, :id_social_network, :social_network_id
  end

  def down
  end
end
