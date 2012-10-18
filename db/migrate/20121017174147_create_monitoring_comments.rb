class CreateMonitoringComments < ActiveRecord::Migration
  def change
    create_table :monitoring_comments do |t|
      t.integer :social_network_id
      t.text :table
      t.text :distributions
      t.text :typology

      t.timestamps
    end
  end
end
