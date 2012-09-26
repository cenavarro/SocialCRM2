class YoutubeDatum < ActiveRecord::Base
  belongs_to :client

  def self.get_new_subscribers(datum)
    if !isFirstData?(datum)
      old_data = YoutubeDatum.where('end_date < ? and social_network_id = ?', datum.start_date.to_date, datum.social_network_id).first
      return (datum.total_subscriber - old_data.total_subscriber)
    end
    return 0
  end

  def self.get_total_investment(datum)
    (datum.investment_agency + datum.investment_anno + datum.investment_actions) 
  end

  def self.isFirstData?(datum)
    before_data = YoutubeDatum.where('end_date < ? and social_network_id = ?',datum.start_date.to_date, datum.social_network_id).first
		if(before_data == nil)
			return true
		end
		return false
	end
end
