class AddClientIdToUsers < ActiveRecord::Migration
  def up
    add_column :users, :client_id, :int
  end

  def down
  	remove_column :users, :client_id
  end
end
