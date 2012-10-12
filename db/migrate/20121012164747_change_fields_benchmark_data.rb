class ChangeFieldsBenchmarkData < ActiveRecord::Migration
  def up
    remove_column :benchmark_data, :title
    change_column :benchmark_data, :benchmark_competitor_id, :integer
  end

  def down
    add_column :benchmark_data, :title, :string
    change_column :benchmark_data, :benchmark_competitor_id, :string
  end
end
