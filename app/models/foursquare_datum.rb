class FoursquareDatum < ActiveRecord::Base
  include Datum
  belongs_to :social_network

  set_type :foursquare_data

  comparable_metrics :clients, :likes, :checkins, :total_unlocks, :total_visits

  def new_followers
    previous_datum.present? ? total_followers - previous_datum.total_followers : 0
  end

end
