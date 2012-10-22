class DeleteInternalMonitoringTables < ActiveRecord::Migration
  def up
    drop_table :internal_monitoring_channels
    drop_table :internal_monitoring_comments
    drop_table :internal_monitoring_data
    drop_table :revisions
  end

  def down
  end
end
