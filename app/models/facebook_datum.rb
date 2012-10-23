class FacebookDatum < ActiveRecord::Base
  belongs_to :social_network

  def self.get_total_interactions(datum)
    (datum.total_clicks_anno + datum.total_interactions)
  end

  def self.get_total_prints(datum)
    (datum.total_prints_per_anno + datum.prints)
  end

  def self.get_total_investment(datum)
    datum.agency_investment.to_f+datum.new_stock_investment.to_f+datum.anno_investment.to_f
  end

  def self.get_fan_cost(datum)
    if !isFirstData?(datum)
      total_investment = get_total_investment(datum)
      return (total_investment.to_f/datum.new_fans.to_f)
    end
    return 0
  end

  def self.get_new_fans(datum)
    if !isFirstData?(datum)
      previous_data = FacebookDatum.where('end_date < ? and social_network_id = ?', datum.start_date.to_date, datum.social_network_id).last
      return (datum.total_fans - previous_data.total_fans) 
    end
    return 0
  end

  def self.get_fan_growth_percentage(datum)
    diffFans = datum.total_fans-datum.new_fans
    (diffFans != 0) ? (return (datum.new_fans.to_f/(datum.total_fans-datum.new_fans).to_f)*100) : ( return 100)
  end

  def self.get_print_percentage(datum)
    !isFirstData?(datum) ? (return getPercentagePrints(datum)) : (return 0)
  end

  def self.getPercentagePrints(datum)
    prevPrintsData = FacebookDatum.where('end_date < ? and social_network_id = ?', datum.start_date.to_date, datum.social_network_id).last.prints
    (prevPrintsData != 0) ? (return ((datum.prints.to_f - prevPrintsData).to_f/prevPrintsData.to_f)*100) : ( return 100)
  end

  def self.get_interactions_percentage(datum)
     !isFirstData?(datum) ? (return getPercentageIteractions(datum)) : ( return 0 )
  end

  def self.getPercentageIteractions(datum)
    prevIteractionData = FacebookDatum.where('end_date < ? and social_network_id = ?', datum.start_date.to_date, datum.social_network_id).last.total_interactions
    (prevIteractionData != 0) ? ( return ((datum.total_interactions.to_f-prevIteractionData.to_f)/prevIteractionData.to_f)*100) : ( return 100)
  end

  def self.percentage_total_reach(datum) 
    !isFirstData?(datum) ? (return getPercentageTotalReach(datum)) : (return 0)
  end

  def self.getPercentageTotalReach(datum)
    prevTotalReach = FacebookDatum.where('end_date < ? and social_network_id = ?',datum.start_date.to_date, datum.social_network_id).last.total_reach
    (prevTotalReach != 0) ? (return ((datum.total_reach - prevTotalReach).to_f/prevTotalReach.to_f) * 100) : ( return 0)
  end

  def self.percentage_change_interactions(datum) 
    !isFirstData?(datum) ? (return getPercentageChangeInteractions(datum)) : ( return 0) 
  end

  def self.getPercentageChangeInteractions(datum)
    prevData = FacebookDatum.where('end_date < ? and social_network_id = ?',datum.start_date.to_date, datum.social_network_id).last
    prevTotalInteractions = get_total_interactions(prevData)
    total_interactions = get_total_interactions(datum)
    return ((total_interactions - prevTotalInteractions).to_f / prevTotalInteractions.to_f) * 100
  end

  def self.percentage_change_prints(datum) 
    !isFirstData?(datum) ? (return getPercentageChangePrints(datum)) : (return 0)
  end

  def self.getPercentageChangePrints(datum)
    prevData = FacebookDatum.where('end_date < ? and social_network_id = ?',datum.start_date.to_date, datum.social_network_id).last
    prevTotalPrints = get_total_prints(prevData)
    total_prints = get_total_prints(datum)
    return ((total_prints - prevTotalPrints).to_f / prevTotalPrints.to_f) * 100
  end

  def self.get_cpm_general(datum)
    total_investment = get_total_investment(datum)
    total_prints = get_total_prints(datum)
    (total_prints != 0) ? (return (total_investment.to_f/total_prints.to_f)/1000.0) : (return 0)
  end

  def self.get_coste_interaction(datum)
   total_investment = get_total_investment(datum)
   total_interaction = get_total_interactions(datum)
   (total_interaction != 0) ? (return (total_investment.to_f/total_interaction.to_f)) : (return 0)
  end

  def self.isFirstData?(datum)
    previous_data = FacebookDatum.where('end_date < ? and social_network_id = ?', datum.start_date.to_date, datum.social_network_id).last
    return previous_data.nil?
  end
end
