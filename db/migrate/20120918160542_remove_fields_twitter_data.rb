class RemoveFieldsTwitterData < ActiveRecord::Migration
  def up
    remove_column :twitter_data, :amount_tweets
    remove_column :twitter_data, :cost_follower
  end

  def down
    add_column :twitter_data, :amount_tweets, :integer
    add_column :twitter_data, :cost_follower, :float
  end
end
