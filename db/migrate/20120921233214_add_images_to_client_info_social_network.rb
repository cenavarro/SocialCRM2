class AddImagesToClientInfoSocialNetwork < ActiveRecord::Migration
  def self.up
    add_column :clients, :attachment_file_name, :string
    add_column :clients, :attachment_content_type, :string
    add_column :clients, :attachment_file_size, :interger
    add_column :clients, :attachment_updated_at, :datetime
    add_column :info_social_networks, :attachment_file_name, :string
    add_column :info_social_networks, :attachment_content_type, :string
    add_column :info_social_networks, :attachment_file_size, :interger
    add_column :info_social_networks, :attachment_updated_at, :datetime
    remove_column :clients, :image
    remove_column :info_social_networks, :image
  end

  def self.down
    remove_column :clients, :attachment_file_name
    remove_column :clients, :attachment_content_type
    remove_column :clients, :attachment_file_size
    remove_column :clients, :attachment_updated_at
    remove_column :info_social_networks, :attachment_file_name
    remove_column :info_social_networks, :attachment_content_type
    remove_column :info_social_networks, :attachment_file_size
    remove_column :info_social_networks, :attachment_updated_at
    add_column :clients, :image, :string
    add_column :info_social_networks, :image, :string
  end
end
