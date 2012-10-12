class CreateBenchmarkData < ActiveRecord::Migration
  def change
    create_table :benchmark_data do |t|
      t.date :start_date
      t.date :end_date
      t.string :title
      t.integer :blogs
      t.integer :forums
      t.integer :videos
      t.integer :twitter
      t.integer :facebook
      t.integer :others
      t.string :benchmark_competitor_id

      t.timestamps
    end
  end
end
