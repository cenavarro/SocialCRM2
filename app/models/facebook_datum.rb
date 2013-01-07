class FacebookDatum < ActiveRecord::Base
  include Datum
  belongs_to :social_network

  set_type :facebook_data
  comparable_metrics :total_fans, :total_prints, :total_interactions, :total_reach

  def total_prints
    total_prints_per_anno + prints
  end

  def brand_total_interactions
    (total_clicks_anno + total_interactions)
  end

  def total_investment
    agency_investment.to_f+new_stock_investment.to_f+anno_investment.to_f
  end

  def fan_cost
    new_fans != 0 ? total_investment.to_f / new_fans.to_f : 0
  end

  def new_fans
    previous_datum.present? ? total_fans - previous_datum.total_fans : 0
  end

  def cpm_general
    (agency_investment + (new_stock_investment/prints) + total_interactions)*1000.0
  end

  def coste_interactions
    brand_total_interactions != 0 ? total_investment.to_f/brand_total_interactions.to_f : 0
  end
end
