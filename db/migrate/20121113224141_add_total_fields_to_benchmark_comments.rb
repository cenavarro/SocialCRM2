class AddTotalFieldsToBenchmarkComments < ActiveRecord::Migration
  def up
    add_column :benchmark_comments, :totals, :text
  end

  def down
    remove_column :benchmark_comments, :totals
  end
end
