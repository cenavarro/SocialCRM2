class CreatePinterestComments < ActiveRecord::Migration
  def change
    create_table :pinterest_comments do |t|
      t.integer :social_network_id
      t.text :table
      t.text :comunity
      t.text :interaction
      t.text :investment

      t.timestamps
    end
  end
end
