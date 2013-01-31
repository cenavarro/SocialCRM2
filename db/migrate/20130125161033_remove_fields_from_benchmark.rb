class RemoveFieldsFromBenchmark < ActiveRecord::Migration
  def up
    SocialNetwork.where('info_social_network_id = ?', InfoSocialNetwork.find_by_id_name('benchmark').id).delete_all
    remove_column :benchmark_data, :blogs
    remove_column :benchmark_data, :forums
    remove_column :benchmark_data, :videos
    remove_column :benchmark_data, :twitter
    remove_column :benchmark_data, :facebook
    remove_column :benchmark_data, :others
    add_column :benchmark_data, :values, :string
  end

  def down
    add_column :benchmark_data, :blogs, :integer if !column_exists?(:benchmark_data, :blogs)
    add_column :benchmark_data, :forums, :integer if !column_exists?(:benchmark_data, :forums)
    add_column :benchmark_data, :videos, :integer if !column_exists?(:benchmark_data, :videos)
    add_column :benchmark_data, :twitter, :integer if !column_exists?(:benchmark_data, :twitter)
    add_column :benchmark_data, :facebook, :integer if !column_exists?(:benchmark_data, :facebook)
    add_column :benchmark_data, :others, :integer if !column_exists?(:benchmark_data, :others)
    remove_column :benchmark_data, :values if column_exists?(:benchmark_data, :values)
  end
end
