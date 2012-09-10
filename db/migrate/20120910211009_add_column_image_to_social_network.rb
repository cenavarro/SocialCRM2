class AddColumnImageToSocialNetwork < ActiveRecord::Migration
  def up
    add_column :social_networks, :image, :string 
  end

  def down
    remove_column :social_networks, :image
  end
end
