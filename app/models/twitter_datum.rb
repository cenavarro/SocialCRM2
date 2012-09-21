class TwitterDatum < ActiveRecord::Base
	belongs_to :client

  def self.get_new_followers(datum)
    if !isFirstData?(datum)
      old_data = TwitterDatum.where('end_date <= ? and id_social_network = ?', datum.start_date.to_date, datum.id_social_network).first
      return  datum.total_followers - old_data.total_followers
    end
    return 0
  end

  def self.get_period_tweets(datum)
    if !isFirstData?(datum)
      old_data = TwitterDatum.where('end_date <= ? and id_social_network = ?', datum.start_date.to_date, datum.id_social_network).first
      return (old_data.total_tweets + datum.total_tweets)
    end
    return 0
  end

  def self.get_growth_followers(datum)
    if !isFirstData?(datum)
      old_data = TwitterDatum.where('end_date <= ? and id_social_network = ?', datum.start_date.to_date, datum.id_social_network).first
      return (datum.new_followers.to_f/old_data.total_followers.to_f)
    end
    return 0
  end

  def self.get_change_mentions(datum)
    if !isFirstData?(datum)
      old_data = TwitterDatum.where('end_date <= ? and id_social_network = ?', datum.start_date.to_date, datum.id_social_network).first
      if old_data.total_mentions != 0
        return ((datum.total_mentions - old_data.total_mentions).to_f/old_data.total_mentions.to_f)
      end
    end
    return 0
  end

  def self.get_change_retweets(datum)
    if !isFirstData?(datum)
      old_data = TwitterDatum.where('end_date <= ? and id_social_network = ?', datum.start_date.to_date, datum.id_social_network).first
      if old_data.ret_tweets != 0
        return ((datum.ret_tweets - old_data.ret_tweets).to_f/old_data.ret_tweets.to_f)
      end
    end
    return 0
  end

  def self.get_change_clics(datum)
    if !isFirstData?(datum)
      old_data = TwitterDatum.where('end_date <= ? and id_social_network = ?', datum.start_date.to_date, datum.id_social_network).first
      if old_data.total_clicks != 0
        return ((datum.total_clicks - old_data.total_clicks).to_f/old_data.total_clicks.to_f)
      end
    end
    return 0
  end

  def self.get_change_interactions_ads(datum)
    if !isFirstData?(datum)
      old_data = TwitterDatum.where('end_date <= ? and id_social_network = ?', datum.start_date.to_date, datum.id_social_network).first
      if old_data.interactions_ads != 0
        return ((datum.interactions_ads - old_data.interactions_ads).to_f/old_data.interactions_ads.to_f)
      end
    end
    return 0
  end

  def self.get_total_interactions(datum)
    (datum.total_mentions + datum.ret_tweets + datum.total_clicks + datum.interactions_ads)
  end

  def self.get_change_interactions(datum)
    if !isFirstData?(datum)
      old_data = TwitterDatum.where('end_date <= ? and id_social_network = ?', datum.start_date.to_date, datum.id_social_network).first
      if old_data.total_interactions != 0
        return ((datum.total_interactions - old_data.total_interactions).to_f/old_data.total_interactions.to_f)
      end
    end
    return 0
  end

  def self.get_total_prints(datum)
    (datum.prints + datum.prints_ads)
  end

  def self.get_change_prints(datum)
    if !isFirstData?(datum)
      old_data = TwitterDatum.where('end_date <= ? and id_social_network = ?', datum.start_date.to_date, datum.id_social_network).first
      before_total_prints = TwitterDatum.get_total_prints(datum) 
      if before_total_prints != 0
        return ((TwitterDatum.get_total_prints(datum) - before_total_prints).to_f/before_total_prints.to_f)
      end
    end
    return 0
  end

  def self.get_total_investment(datum)
    (datum.agency_investment + datum.investment_ads + datum.investment_actions) 
  end

  def self.get_cost_per_prints(datum)
    if !isFirstData?(datum)
      total_investment = get_total_investment(datum)
      total_prints = get_total_prints(datum)
      return (total_investment.to_f/total_prints.to_f)*1000
    end
    return 0
  end

  def self.get_cost_per_interaction(datum)
    if !isFirstData?(datum)
      total_investment = get_total_investment(datum)
      total_interactions = get_total_interactions(datum)
      return (total_investment.to_f/total_interactions.to_f)
    end
    return 0
  end

  def self.get_cost_follower(datum)
    if !isFirstData?(datum)
      total_investment = get_total_investment(datum)
      return (total_investment.to_f/datum.new_followers.to_f)
    end
    return 0
  end
  
	def self.isFirstData?(datum)
    before_data = TwitterDatum.where('end_date < ? and id_social_network = ?',datum.start_date.to_date, datum.id_social_network).first
		if(before_data == nil)
			return true
		end
		return false
	end

end
