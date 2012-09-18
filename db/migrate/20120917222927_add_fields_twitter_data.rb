class AddFieldsTwitterData < ActiveRecord::Migration
  def up
    add_column :twitter_data, :interactions_ads, :integer
    add_column :twitter_data, :prints, :integer
    add_column :twitter_data, :prints_ads, :integer
    add_column :twitter_data, :investment_actions, :float
    add_column :twitter_data, :cost_twitter_ads, :float
    add_column :twitter_data, :investment_ads, :float
  end

  def down
    remove_column :twitter_data, :interactions_ads
    remove_column :twitter_data, :prints
    remove_column :twitter_data, :prints_ads
    remove_column :twitter_data, :investment_actions
    remove_column :twitter_data, :investment_ads
    remove_column :twitter_data, :cost_twitter_ads
  end
end
