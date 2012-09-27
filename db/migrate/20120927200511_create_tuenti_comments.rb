class CreateTuentiComments < ActiveRecord::Migration
  def change
    create_table :tuenti_comments do |t|
      t.integer :social_network_id
      t.text :table
      t.text :fans
      t.text :interaction
      t.text :reach
      t.text :investment
      t.text :cost

      t.timestamps
    end
  end
end
