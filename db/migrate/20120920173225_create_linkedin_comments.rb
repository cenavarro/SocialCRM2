class CreateLinkedinComments < ActiveRecord::Migration
  def change
    create_table :linkedin_comments do |t|
      t.integer :social_network_id
      t.text :table
      t.text :comunity
      t.text :interaction

      t.timestamps
    end
  end
end
