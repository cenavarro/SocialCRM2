class FoursquareDatum < ActiveRecord::Base
  belongs_to :social_network

  def self.get_new_followers(datum)
    if !isFirstData?(datum)
      previous_data = FoursquareDatum.where('end_date < ? and social_network_id = ?', datum.start_date.to_date, datum.social_network_id).last
      return (datum.total_followers - previous_data.total_followers)
    end
    return 0
  end

  def self.isFirstData?(datum)
    previous_data = FoursquareDatum.where('end_date < ? and social_network_id = ?',datum.start_date.to_date, datum.social_network_id).last
		(previous_data == nil) ? (return true) : (return false)
  end
end
