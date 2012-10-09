class TuentiDatum < ActiveRecord::Base
  belongs_to :social_network

  def self.get_new_fans(datum)
    if !isFirstData?(datum)
      previous_data = TuentiDatum.where('end_date < ? and social_network_id = ?', datum.start_date.to_date, datum.social_network_id).first
      return (datum.real_fans - previous_data.real_fans)
    end
    return 0
  end

  def self.get_total_investment(datum)
    (datum.investment_agency + datum.investment_ads + datum.investment_actions) 
  end

  def self.get_cost_fan(datum)
    total_investment = get_total_investment(datum)
    new_fans = get_new_fans(datum)
    (new_fans != 0) ? (return (total_investment.to_f/new_fans.to_f)) : (return 0)
  end

  def self.get_grown_fans_percent(datum)
    if !isFirstData?(datum)
      previous_data = TuentiDatum.where('end_date < ? and social_network_id = ?', datum.start_date.to_date, datum.social_network_id).first
      return ((datum.real_fans.to_f-previous_data.real_fans.to_f)*100) if previous_data.real_fans != 0
    end
    return datum.new_fans * 100.0
  end

  def self.isFirstData?(datum)
    previous_data = TuentiDatum.where('end_date < ? and social_network_id = ?',datum.start_date.to_date, datum.social_network_id).first
    (previous_data == nil) ? (return true) : (return false)
  end
end
