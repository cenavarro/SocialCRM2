class ChangeColumnNameTuenti < ActiveRecord::Migration
  def up
    rename_column :tuenti_data, :actions_text, :actions
  end

  def down
    rename_column :tuenti_data, :actions, :actions_text
  end
end
