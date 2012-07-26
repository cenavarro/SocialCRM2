class AddDescriptionToClients < ActiveRecord::Migration
  def change
  	add_column :clients, :description, :string
  end
end
