class AddSharesToLinkedIn < ActiveRecord::Migration
  def up
    add_column :linkedin_data, :shared, :integer, default: 0
  end

  def down
    remove_column :linkedin_data, :shared
  end
end
