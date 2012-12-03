class PinterestDatum < ActiveRecord::Base
  include Datum

  belongs_to :social_network

  set_type :pinterest_data

  def new_followers
    previous_datum.present? ? total_followers - previous_datum.total_followers : 0
  end

  def total_investment
    (investment_agency + investment_ads + investment_actions) 
  end

end
