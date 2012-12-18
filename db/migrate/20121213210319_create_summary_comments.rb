class CreateSummaryComments < ActiveRecord::Migration
  def change
    create_table :summary_comments do |t|
      t.text :title
      t.text :content
      t.references :summary

      t.timestamps
    end
  end
end
