class GooglePlusDatum < ActiveRecord::Base
  belongs_to :client

  def self.get_new_followers(datum)
    if !isFirstData?(datum)
      old_data = GooglePlusDatum.where('end_date < ? and social_network_id = ?', datum.start_date.to_date, datum.social_network_id).first
      return (datum.total_followers - old_data.total_followers)
    end
    return datum.total_followers
  end

  def self.get_total_investment(datum)
    (datum.investment_agency + datum.investment_ads + datum.investment_actions) 
  end

  def self.get_grown_followers(datum)
    if !isFirstData?(datum)
      old_data = GooglePlusDatum.where('end_date < ? and social_network_id = ?', datum.start_date.to_date, datum.social_network_id).first
      return ((datum.total_followers-old_data.total_followers).to_f/old_data.total_followers.to_f) if old_data.total_followers != 0
    end
    return 0 
  end

  def self.get_total_interactions(datum)
    return (datum.plus + datum.content_shared)
  end

  def self.get_change_interactions(datum)
    if !isFirstData?(datum)
      old_data = GooglePlusDatum.where('end_date < ? and social_network_id = ?', datum.start_date.to_date, datum.social_network_id).first
      total_interactions = GooglePlusDatum.get_total_interactions(datum)
      before_total_interactions = GooglePlusDatum.get_total_interactions(old_data)
      p "TI:" + total_interactions.to_s
      p "BTI:" + total_interactions.to_s
      return (total_interactions-before_total_interactions).to_f/before_total_interactions.to_f if before_total_interactions != 0
    end
    return 0 
  end

  def self.isFirstData?(datum)
    before_data = GooglePlusDatum.where('end_date < ? and social_network_id = ?',datum.start_date.to_date, datum.social_network_id).first
		if(before_data == nil)
			return true
		end
		return false
	end
end
