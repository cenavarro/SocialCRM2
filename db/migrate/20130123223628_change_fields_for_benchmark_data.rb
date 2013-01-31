class ChangeFieldsForBenchmarkData < ActiveRecord::Migration
  def up
    change_column :benchmark_data, :others, :string
  end

  def down
    change_column :benchmark_data, :others, :integer
  end
end
