class CreateInfoSocialNetworks < ActiveRecord::Migration
  def change
    create_table :info_social_networks do |t|
      t.string :name
      t.text :description
      t.string :image

      t.timestamps
    end
  end
end
