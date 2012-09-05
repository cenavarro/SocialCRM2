class AddAppFacebookIdToUsers < ActiveRecord::Migration
  def up
    add_column :users, :fbapp_id, :string 
  end

  def down
    remove_column :users, :fbapp_id
  end
end
