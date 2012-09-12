class CreateImagesSocialNetworks < ActiveRecord::Migration
  def change
    create_table :images_social_networks do |t|
      t.integer :social_network_id
      t.string :attachment_file_name
      t.string :attachment_content_type
      t.integer :attachment_file_size
      t.datetime :attachment_updated_at
      t.string :comment

      t.timestamps
    end
  end
end
