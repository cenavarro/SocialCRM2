class TwitterDatum < ActiveRecord::Base
  belongs_to :social_network

  def self.get_new_followers(datum)
    if !isFirstData?(datum)
      previous_data = TwitterDatum.where('end_date <= ? and social_network_id = ?', datum.start_date.to_date, datum.social_network_id).first
      return  datum.total_followers - previous_data.total_followers
    end
    return 0
  end

  def self.get_period_tweets(datum)
    if !isFirstData?(datum)
      previous_data = TwitterDatum.where('end_date <= ? and social_network_id = ?', datum.start_date.to_date, datum.social_network_id).first
      return (previous_data.total_tweets + datum.total_tweets)
    end
    return datum.total_tweets
  end

  def self.get_growth_followers(datum)
    if !isFirstData?(datum)
      previous_data = TwitterDatum.where('end_date <= ? and social_network_id = ?', datum.start_date.to_date, datum.social_network_id).first
      return (datum.new_followers.to_f/previous_data.total_followers.to_f)*100 if previous_data.total_followers != 0
    end
    return 0
  end

  def self.get_change_mentions(datum)
    if !isFirstData?(datum)
      previous_data = TwitterDatum.where('end_date <= ? and social_network_id = ?', datum.start_date.to_date, datum.social_network_id).first
      if previous_data.total_mentions != 0
        return ((datum.total_mentions - previous_data.total_mentions).to_f/previous_data.total_mentions.to_f)*100
      end
    end
    return 0
  end

  def self.get_change_retweets(datum)
    if !isFirstData?(datum)
      previous_data = TwitterDatum.where('end_date <= ? and social_network_id = ?', datum.start_date.to_date, datum.social_network_id).first
      if previous_data.ret_tweets != 0
        return ((datum.ret_tweets - previous_data.ret_tweets).to_f/previous_data.ret_tweets.to_f)*100
      end
    end
    return 0
  end

  def self.get_change_clics(datum)
    if !isFirstData?(datum)
      previous_data = TwitterDatum.where('end_date <= ? and social_network_id = ?', datum.start_date.to_date, datum.social_network_id).first
      if previous_data.total_clicks != 0
        return ((datum.total_clicks - previous_data.total_clicks).to_f/previous_data.total_clicks.to_f)*100
      end
    end
    return 0
  end

  def self.get_change_interactions_ads(datum)
    if !isFirstData?(datum)
      previous_data = TwitterDatum.where('end_date <= ? and social_network_id = ?', datum.start_date.to_date, datum.social_network_id).first
      if previous_data.interactions_ads != 0
        return ((datum.interactions_ads - previous_data.interactions_ads).to_f/previous_data.interactions_ads.to_f)*100
      end
    end
    return 0
  end

  def self.get_total_interactions(datum)
    (datum.total_mentions + datum.ret_tweets + datum.total_clicks + datum.interactions_ads)
  end

  def self.get_change_interactions(datum)
    if !isFirstData?(datum)
      previous_data = TwitterDatum.where('end_date <= ? and social_network_id = ?', datum.start_date.to_date, datum.social_network_id).first
      if previous_data.total_interactions != 0
        return ((datum.total_interactions - previous_data.total_interactions).to_f/previous_data.total_interactions.to_f)*100
      end
    end
    return 0
  end

  def self.get_total_prints(datum)
    (datum.prints + datum.prints_ads)
  end

  def self.get_change_prints(datum)
    if !isFirstData?(datum)
      previous_data = TwitterDatum.where('end_date <= ? and social_network_id = ?', datum.start_date.to_date, datum.social_network_id).first
      previous_total_prints = TwitterDatum.get_total_prints(datum) 
      if previous_total_prints != 0
        return ((TwitterDatum.get_total_prints(datum) - previous_total_prints).to_f/previous_total_prints.to_f)*100
      end
    end
    return 0
  end

  def self.get_total_investment(datum)
    (datum.agency_investment + datum.investment_ads + datum.investment_actions) 
  end

  def self.get_cost_per_prints(datum)
    total_investment = get_total_investment(datum)
    total_prints = get_total_prints(datum)
    return (total_investment.to_f/total_prints.to_f)*1000 if total_prints != 0
    return 0
  end

  def self.get_cost_per_interaction(datum)
    total_investment = get_total_investment(datum)
    total_interactions = get_total_interactions(datum)
    return (total_investment.to_f/total_interactions.to_f) if total_interactions != 0
    return 0
  end

  def self.get_cost_follower(datum)
    if !isFirstData?(datum)
      total_investment = get_total_investment(datum)
      return (total_investment.to_f/datum.new_followers.to_f) if datum.new_followers != 0
    end
    return 0
  end

	def self.isFirstData?(datum)
    previous_data = TwitterDatum.where('end_date < ? and social_network_id = ?',datum.start_date.to_date, datum.social_network_id).first
		if(previous_data == nil)
			return true
		end
		return false
	end

end
