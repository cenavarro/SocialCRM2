class CreateMonitorings < ActiveRecord::Migration
  def change
    create_table :monitorings do |t|
      t.string :name
      t.integer :social_network_id
      t.boolean :isTheme

      t.timestamps
    end
  end
end
