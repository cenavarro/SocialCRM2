class CreateHistoryComments < ActiveRecord::Migration
  def up
    drop_table :list_of_comment if self.table_exists?("list_of_comment")
    create_table :history_comments do |t|
      t.references :social_network
      t.integer :comment_id
      t.date :start_date
      t.date :end_date
      t.text :content

      t.timestamps
    end
    add_index :history_comments, :social_network_id
  end

  def down
    drop_table :history_comments
    remove_index :history_comments, :social_network_id
  end
end
