class AddRolFieldToUsers < ActiveRecord::Migration
  def up
  	add_column :users, :rol_id, :int
  end

  def down
  	remove_column :users, :rol_id
  end
end
