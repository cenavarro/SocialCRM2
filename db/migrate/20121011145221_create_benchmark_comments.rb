class CreateBenchmarkComments < ActiveRecord::Migration
  def change
    create_table :benchmark_comments do |t|
      t.integer :social_network_id
      t.text :table
      t.text :distribution

      t.timestamps
    end
  end
end
