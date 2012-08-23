class CreateTwitterData < ActiveRecord::Migration
  def change
    create_table :twitter_data do |t|
      t.integer :client_id
      t.date :start_date
      t.date :end_date
      t.string :global_goal
      t.integer :new_followers
      t.integer :total_followers
      t.integer :goal_followers
      t.integer :amount_tweets
      t.integer :total_tweets
      t.integer :total_mentions
      t.integer :ret_tweets
      t.integer :total_clicks
      t.integer :total_interactions
      t.float :agency_investment
      t.float :cost_follower

      t.timestamps
    end
  end
end
