class PinterestDatum < ActiveRecord::Base
  include Datum

  belongs_to :social_network

  set_type :pinterest_data

  comparable_metrics :total_followers, :liked, :repin, :comments, :community_boards

  def total_investment
    (investment_agency + investment_ads + investment_actions) 
  end

  def coste_fan
    (total_investment.to_f / total_followers) 
  end

end
