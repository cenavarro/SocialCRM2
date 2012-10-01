class RemoveTotalInteracionFieldGooglePlus < ActiveRecord::Migration
  def up
    remove_column :google_plus_data, :total_interactions
  end

  def down
    add_column :google_plus_data, :total_interactions, :integer
  end
end
