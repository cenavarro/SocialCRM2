class AddFieldIdPageToSocialNetwork < ActiveRecord::Migration
  def up
    add_column :social_networks, :id_object, :string
  end

  def down
    remove_column :social_networks, :id_object
  end
end
