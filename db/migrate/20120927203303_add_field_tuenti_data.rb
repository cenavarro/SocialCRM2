class AddFieldTuentiData < ActiveRecord::Migration
  def up
    add_column :tuenti_data, :actions_text, :string
  end

  def down
    remove_column :tuenti_data, :actions_text
  end
end
