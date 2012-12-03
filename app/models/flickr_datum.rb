class FlickrDatum < ActiveRecord::Base
  include Datum
  belongs_to :social_network

  set_type :flickr_data

  def new_contacts
    previous_datum.present? ? total_contacts - previous_datum.total_contacts : 0
  end

  def total_investment
    (investment_agency + investment_ads + investment_actions)
  end

end
