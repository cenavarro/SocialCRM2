class GooglePlusDatum < ActiveRecord::Base
  belongs_to :social_network

  def self.get_new_followers(datum)
    if !isFirstData?(datum)
      previous_data = GooglePlusDatum.where('end_date < ? and social_network_id = ?', datum.start_date.to_date, datum.social_network_id).first
      return (datum.total_followers - previous_data.total_followers)
    end
    return 0 
  end

  def self.get_total_investment(datum)
    (datum.investment_agency + datum.investment_ads + datum.investment_actions) 
  end

  def self.get_grown_followers(datum)
    if !isFirstData?(datum)
      previous_data = GooglePlusDatum.where('end_date < ? and social_network_id = ?', datum.start_date.to_date, datum.social_network_id).first
      return ((datum.total_followers-previous_data.total_followers).to_f/previous_data.total_followers.to_f) if previous_data.total_followers != 0
    end
    return 0 
  end

  def self.get_total_interactions(datum)
    return (datum.plus + datum.content_shared)
  end

  def self.get_change_interactions(datum)
    if !isFirstData?(datum)
      previous_data = GooglePlusDatum.where('end_date < ? and social_network_id = ?', datum.start_date.to_date, datum.social_network_id).first
      total_interactions = GooglePlusDatum.get_total_interactions(datum)
      previous_total_interactions = GooglePlusDatum.get_total_interactions(previous_data)
      return (total_interactions-previous_total_interactions).to_f/previous_total_interactions.to_f if previous_total_interactions != 0
    end
    return 0 
  end

  def self.isFirstData?(datum)
    previous_data = GooglePlusDatum.where('end_date < ? and social_network_id = ?',datum.start_date.to_date, datum.social_network_id).first
		if(previous_data == nil)
			return true
		end
		return false
	end
end
