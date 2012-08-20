class ChangeColumnNotNullClients < ActiveRecord::Migration
  def up
  	change_column :clients, :name, :string, :null => false
  end

  def down
  	change_column :clients, :name, :string
  end
end
