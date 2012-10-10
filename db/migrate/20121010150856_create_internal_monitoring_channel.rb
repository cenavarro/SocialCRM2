class CreateInternalMonitoringChannel < ActiveRecord::Migration
  def change
    create_table :internal_monitoring_channels do |t|
      t.integer :social_network_id
      t.integer :channel_number
      t.string :title

      t.timestamps
    end
  end
end
