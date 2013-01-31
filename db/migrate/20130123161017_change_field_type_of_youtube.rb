class ChangeFieldTypeOfYoutube < ActiveRecord::Migration
  def up
    change_column :youtube_data, :inserted_player, :float
  end

  def down
    change_column :youtube_data, :inserted_player, :integer
  end
end
