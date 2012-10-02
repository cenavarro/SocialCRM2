class CreateBlogComments < ActiveRecord::Migration
  def change
    create_table :blog_comments do |t|
      t.integer :social_network_id
      t.text :table
      t.text :visits
      t.text :percentages

      t.timestamps
    end
  end
end
