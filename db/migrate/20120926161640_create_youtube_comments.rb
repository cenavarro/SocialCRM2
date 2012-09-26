class CreateYoutubeComments < ActiveRecord::Migration
  def change
    create_table :youtube_comments do |t|
      t.integer :social_network_id
      t.text :table
      t.text :community
      t.text :interaction

      t.timestamps
    end
  end
end
