class AddDatesToImagesSocialNetwork < ActiveRecord::Migration
  def up
    add_column :images_social_networks, :start_date, :date
    add_column :images_social_networks, :end_date, :date
  end

  def down
    remove_column :images_social_networks, :start_date
    remove_column :images_social_networks, :end_date
  end
end
