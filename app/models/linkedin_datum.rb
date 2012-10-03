class LinkedinDatum < ActiveRecord::Base
  belongs_to :social_network

  def self.get_new_followers(datum)
    if !isFirstData?(datum)
      previous_data = LinkedinDatum.where('end_date < ? and social_network_id = ?', datum.start_date.to_date, datum.social_network_id).first
      return (datum.total_followers - previous_data.total_followers)
    end
    return 0
  end

  def self.get_growth_followers(datum)
    if !isFirstData?(datum)
      previous_data = LinkedinDatum.where('end_date < ? and social_network_id = ?', datum.start_date.to_date, datum.social_network_id).first
      if previous_data.total_followers != 0
        return (datum.new_followers.to_f/previous_data.total_followers.to_f)*100
      end
      return 100 
    end
    return 0
  end

  def self.get_views_page(datum)
    return (datum.summary + datum.employment + datum.products_services)
  end

  def self.get_total_investment(datum)
    (datum.investment_agency + datum.investment_anno + datum.investment_actions) 
  end

  def self.isFirstData?(datum)
    previous_data = LinkedinDatum.where('end_date < ? and social_network_id = ?',datum.start_date.to_date, datum.social_network_id).first
		if(previous_data == nil)
			return true
		end
		return false
	end

end
