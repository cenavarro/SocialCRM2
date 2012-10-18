class CreateMonitoringData < ActiveRecord::Migration
  def change
    create_table :monitoring_data do |t|
      t.integer :monitoring_id
      t.integer :value
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
