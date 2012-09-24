class AddFieldsImageToSocialNetwork < ActiveRecord::Migration
  def self.up
    add_column :social_networks, :image_file_name, :string
    add_column :social_networks, :image_content_type, :string
    add_column :social_networks, :image_file_size, :interger
    add_column :social_networks, :image_updated_at, :datetime
    remove_column :social_networks, :image
  end


  def self.down
    remove_column :social_networks, :image_file_name
    remove_column :social_networks, :image_content_type
    remove_column :social_networks, :image_file_size
    remove_column :social_networks, :image_updated_at
    add_column :social_networks, :image, :string
  end
end
