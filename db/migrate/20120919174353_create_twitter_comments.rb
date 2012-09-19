class CreateTwitterComments < ActiveRecord::Migration
  def change
    create_table :twitter_comments do |t|
      t.integer :social_network_id
      t.text :table
      t.text :comunity
      t.text :interaction
      t.text :investment
      t.text :cost

      t.timestamps
    end
  end
end
