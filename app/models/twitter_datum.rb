class TwitterDatum < ActiveRecord::Base
  include Datum
  
  belongs_to :social_network

  set_type :twitter_data

  comparable_metrics :total_followers, :total_mentions, :ret_tweets, :total_clicks, :interactions_ads, :total_interactions, :total_prints

  def new_followers
    previous_datum.present? ? total_followers - previous_datum.total_followers : 0
  end

  def period_tweets
    previous_datum.present? ? total_tweets + total_tweets : total_tweets
  end

  def total_interactions
    (total_mentions + ret_tweets + total_clicks + interactions_ads)
  end

  def total_prints
    (prints + prints_ads)
  end

  def total_investment
    (agency_investment + investment_ads + investment_actions) 
  end

  def cost_per_prints
    total_prints != 0 ? (total_investment.to_f/total_prints.to_f)*1000 : 0
  end

  def cost_per_interaction
    total_interactions != 0 ? (total_investment.to_f/total_interactions.to_f) : 0
  end

  def cost_follower
    (total_investment.to_f/total_followers.to_f)
  end

end
