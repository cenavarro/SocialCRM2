class AddTitleImagesFacebook < ActiveRecord::Migration
  def up
    add_column :images_social_networks, :title, :string
  end

  def down
    remove_column :images_social_networks, :title
  end
end
