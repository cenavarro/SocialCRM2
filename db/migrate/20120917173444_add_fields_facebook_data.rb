class AddFieldsFacebookData < ActiveRecord::Migration
  def up
    add_column :facebook_data, :ranking_espana, :integer
    add_column :facebook_data, :ranking_world, :integer
  end

  def down
    remove_column :facebook_data, :ranking_espana
    remove_column :facebook_data, :ranking_world
  end
end
