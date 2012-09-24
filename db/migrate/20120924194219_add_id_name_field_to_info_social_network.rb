class AddIdNameFieldToInfoSocialNetwork < ActiveRecord::Migration
  def self.up
    add_column :info_social_networks, :id_name, :string
  end

  def self.down
    remove_column :info_social_networks, :id_name
  end
end
