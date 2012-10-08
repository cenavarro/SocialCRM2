class CreateRowData < ActiveRecord::Migration
  def change
    create_table :row_data do |t|
      t.date :start_date
      t.date :end_date
      t.integer :value
      t.integer :rows_campaign_id

      t.timestamps
    end
  end
end
