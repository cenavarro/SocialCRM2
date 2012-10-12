class CreateBenchmarkCompetitors < ActiveRecord::Migration
  def change
    create_table :benchmark_competitors do |t|
      t.integer :social_network_id
      t.string :name

      t.timestamps
    end
  end
end
