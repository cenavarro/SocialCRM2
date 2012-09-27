class TuentiDatum < ActiveRecord::Base
  belongs_to :client

  def self.get_new_fans(datum)
    if !isFirstData?(datum)
      old_data = TuentiDatum.where('end_date < ? and social_network_id = ?', datum.start_date.to_date, datum.social_network_id).first
      return (datum.real_fans - old_data.real_fans)
    end
    return datum.real_fans 
  end

  def self.get_total_investment(datum)
    (datum.investment_agency + datum.investment_ads + datum.investment_actions) 
  end

  def self.get_cost_fan(datum)
    total_investment = get_total_investment(datum)
    new_fans = get_new_fans(datum)
    return (total_investment.to_f/new_fans.to_f) if new_fans != 0
    return 0
  end

  def self.get_grown_fans_percent(datum)
    if !isFirstData?(datum)
      old_data = TuentiDatum.where('end_date < ? and social_network_id = ?', datum.start_date.to_date, datum.social_network_id).first
      return ((datum.real_fans.to_f-old_data.real_fans.to_f)*100) if old_data.real_fans != 0
    end
    return datum.new_fans * 100.0
  end

  def self.isFirstData?(datum)
    before_data = TuentiDatum.where('end_date < ? and social_network_id = ?',datum.start_date.to_date, datum.social_network_id).first
		if(before_data == nil)
			return true
		end
		return false
	end
end
