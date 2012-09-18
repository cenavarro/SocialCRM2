class RemoveFieldsTwitterData < ActiveRecord::Migration
  def up
    remove_column :twitter_data, :amount_tweets
  end

  def down
    add_column :twitter_data, :amount_tweets, :integer
  end
end
