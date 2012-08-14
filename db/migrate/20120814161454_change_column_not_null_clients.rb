class ChangeColumnNotNullClients < ActiveRecord::Migration
  def up
  	change_column :clients, :name, :string, :null => false
  	change_column :clients, :description, :string, :null => false
  	change_column :clients, :image, :string, :null => false
  end

  def down
  	change_column :clients, :name, :string
  	change_column :clients, :description
  	change_column :clients, :image, :string
  end
end
