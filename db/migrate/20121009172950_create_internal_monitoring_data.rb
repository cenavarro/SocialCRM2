class CreateInternalMonitoringData < ActiveRecord::Migration
  def change
    create_table :internal_monitoring_data do |t|
      t.integer :client_id
      t.date :start_date
      t.date :end_date
      t.integer :social_network_id
      t.integer :complaints
      t.integer :client_att
      t.integer :lead
      t.integer :engaged
      t.integer :curiosities
      t.integer :mentions
      t.integer :feedback
      t.integer :channel_1
      t.integer :channel_2
      t.integer :channel_3
      t.integer :channel_4
      t.integer :channel_5
      t.integer :channel_6
      t.integer :channel_7
      t.integer :channel_8
      t.integer :channel_9
      t.integer :channel_10
      t.integer :channel_11
      t.integer :channel_12
      t.integer :channel_13
      t.integer :channel_14
      t.integer :channel_15
      t.integer :channel_16
      t.integer :channel_17
      t.integer :channel_18
      t.integer :channel_19
      t.integer :channel_20

      t.timestamps
    end
  end
end
