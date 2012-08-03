class AddRolFieldToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :rol_id, :int
  end
end
