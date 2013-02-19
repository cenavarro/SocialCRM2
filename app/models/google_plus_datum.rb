class GooglePlusDatum < ActiveRecord::Base
  include Datum
  belongs_to :social_network

  set_type :google_plus_data

  comparable_metrics :total_followers, :total_interactions

  def new_followers
    previous_datum.present? ? total_followers - previous_datum.total_followers : 0
  end

  def total_investment
    (investment_agency + investment_ads + investment_actions) 
  end

  def total_interactions
    (plus + content_shared)
  end

end
