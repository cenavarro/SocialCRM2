class FlickrDatum < ActiveRecord::Base
  belongs_to :social_network

  def self.get_new_contacts(datum)
    if !isFirstData?(datum)
      previous_data = FlickrDatum.where('end_date < ? and social_network_id = ?', datum.start_date.to_date, datum.social_network_id).first
      return (datum.total_contacts - previous_data.total_contacts)
    end
    return 0
  end

  def self.get_total_investment(datum)
    (datum.investment_agency + datum.investment_ads + datum.investment_actions) 
  end

  def self.isFirstData?(datum)
    previous_data = FlickrDatum.where('end_date < ? and social_network_id = ?',datum.start_date.to_date, datum.social_network_id).first
		(previous_data == nil) ? (return true) : (return false)
  end
end
