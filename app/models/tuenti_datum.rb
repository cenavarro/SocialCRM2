class TuentiDatum < ActiveRecord::Base
  include Datum

  belongs_to :social_network

  set_type :tuenti_data

  comparable_metrics :real_fans

  def new_fans
    previous_datum.present? ? real_fans - previous_datum.real_fans : 0
  end

  def total_investment
    (investment_agency + investment_ads + investment_actions) 
  end

  def cost_fan
    (new_fans > 0) ? (total_investment.to_f/new_fans.to_f) : total_investment.to_f
  end

end
