class TwitterDatum < ActiveRecord::Base
	belongs_to :client

  def self.get_new_followers(datum)
    if !isFirstData?(datum)
      old_data = TwitterDatum.where('end_date <= ?', datum.start_date.to_date).first
      return old_data.total_followers + datum.total_followers
    end
    return 0
  end

  def self.get_period_tweets(datum)
    if !isFirstData?(datum)
      old_data = TwitterDatum.where('end_date <= ?', datum.start_date.to_date).first
      return (old_data.total_tweets + datum.total_tweets)
    end
    return 0
  end

  def self.get_growth_followers(datum)
    if !isFirstData?(datum)
      old_data = TwitterDatum.where('end_date <= ?', datum.start_date.to_date).first
      return (datum.new_followers.to_f/old_data.total_followers.to_f)
    end
    return 0
  end

  def self.get_change_mentions(datum)
    if !isFirstData?(datum)
      old_data = TwitterDatum.where('end_date <= ?', datum.start_date.to_date).first
      if old_data.total_mentions != 0
        return ((datum.total_mentions - old_data.total_mentions).to_f/old_data.total_mentions.to_f)
      end
    end
    return 0
  end

  def self.get_change_retweets(datum)
    if !isFirstData?(datum)
      old_data = TwitterDatum.where('end_date <= ?', datum.start_date.to_date).first
      if old_data.ret_tweets != 0
        return ((datum.ret_tweets - old_data.ret_tweets).to_f/old_data.ret_tweets.to_f)
      end
    end
    return 0
  end

  def self.get_change_clics(datum)
    if !isFirstData?(datum)
      old_data = TwitterDatum.where('end_date <= ?', datum.start_date.to_date).first
      if old_data.total_clicks != 0
        return ((datum.total_clicks - old_data.total_clicks).to_f/old_data.total_clicks.to_f)
      end
    end
    return 0
  end

  def self.get_change_interactions_ads(datum)
    if !isFirstData?(datum)
      old_data = TwitterDatum.where('end_date <= ?', datum.start_date.to_date).first
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
      old_data = TwitterDatum.where('end_date <= ?', datum.start_date.to_date).first
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
      old_data = TwitterDatum.where('end_date <= ?', datum.start_date.to_date).first
      if old_data.total_prints != 0
        return ((datum.total_prints - old_data.total_prints).to_f/old_data.total_prints.to_f)
      end
    end
    return 0
  end

	def self.isFirstData?(datum)
    before_data = TwitterDatum.where('end_date < ?',datum.start_date.to_date).first
		if(before_data == nil)
			return true
		end
		return false
	end

end
