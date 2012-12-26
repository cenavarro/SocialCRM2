class CreateListComments < ActiveRecord::Migration
  def change
    create_table :list_comments do |t|
      t.references :comment
      t.text :content
      t.text :link

      t.timestamps
    end
    add_index :list_comments, :comment_id
  end
end
