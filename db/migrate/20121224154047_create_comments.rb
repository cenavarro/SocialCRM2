class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :client_id
      t.integer :social_network_id
      t.text :social_network_name
      t.date :start_date
      t.date :end_date
      t.integer :comment_type

      t.timestamps
    end
  end
end
