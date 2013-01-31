class CreateBenchmarkColumns < ActiveRecord::Migration
  def change
    create_table :benchmark_columns do |t|
      t.string :name
      t.references :social_network

      t.timestamps
    end
    add_index :benchmark_columns, :social_network_id
  end
end
