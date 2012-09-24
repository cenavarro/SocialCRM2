class LinkedinDatum < ActiveRecord::Base
  belongs_to :client

  def self.get_new_followers(datum)
    if !isFirstData?(datum)
      old_data = LinkedinDatum.where('end_date < ? and id_social_network = ?', datum.start_date.to_date, datum.id_social_network).first
      return (datum.total_followers - old_data.total_followers)
    end
    return 0
  end

  def self.get_growth_followers(datum)
    if !isFirstData?(datum)
      old_data = LinkedinDatum.where('end_date < ? and id_social_network = ?', datum.start_date.to_date, datum.id_social_network).first
      if old_data.total_followers != 0
        return (datum.new_followers.to_f/old_data.total_followers.to_f)*100
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
    before_data = LinkedinDatum.where('end_date < ? and id_social_network = ?',datum.start_date.to_date, datum.id_social_network).first
		if(before_data == nil)
			return true
		end
		return false
	end

end
