class CreateSummaries < ActiveRecord::Migration
  def change
    create_table :summaries do |t|
      t.references :social_network
      t.references :client
      t.timestamps
    end
  end
end
