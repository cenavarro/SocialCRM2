class FacebookDatum < ActiveRecord::Base

  def self.get_real_fans(datum,isCreate)
    if !all.first.nil?
      if isCreate
        prevRealFans = FacebookDatum.where('end_date < ?', datum.start_date.to_date).first.total_fans
      else
        prevRealFans = FacebookDatum.last.total_fans
      end
      return (datum.new_fans+prevRealFans)
    end
    return datum.new_fans
  end

  def self.get_fan_growth_percentage(datum)
    diffFans = datum.total_fans-datum.new_fans
    if diffFans != 0
      return (datum.new_fans.to_f/(datum.total_fans-datum.new_fans).to_f)*100
    end
    return 100
  end

  def self.get_print_percentage(datum)
    if !isFirstData?(datum)
      return getPercentagePrints(datum)
    end
    return nil
  end

  def self.getPercentagePrints(datum)
    prevPrintsData = FacebookDatum.where('end_date < ?', datum.start_date.to_date).first.prints
    if prevPrintsData != 0
      return ((datum.prints.to_f - prevPrintsData).to_f/prevPrintsData.to_f)*100
    end
    return 100
  end

  def self.get_interactions_percentage(datum)
    if !isFirstData?(datum)
      return getPercentageIteractions(datum)
    end
    return nil
  end

  def self.getPercentageIteractions(datum)
    prevIteractionData = FacebookDatum.where('end_date < ?', datum.start_date.to_date).first.total_interactions
    if prevIteractionData != 0
      return ((datum.total_interactions.to_f-prevIteractionData.to_f)/prevIteractionData.to_f)*100
    end
    return 100
  end

  def self.get_total_investment(datum)
    datum.agency_investment.to_f+datum.new_stock_investment.to_f+datum.anno_investment.to_f
  end
  def self.get_cpm(datum)
    (datum.agency_investment.to_f+datum.new_stock_investment.to_f)/(datum.prints.to_f+datum.total_interactions)*1000
  end
  def self.get_fan_cost(datum)
    (datum.agency_investment.to_f+datum.new_stock_investment.to_f+datum.anno_investment.to_f)/datum.new_fans.to_f
  end

  def self.isFirstData?(datum)
    if(datum.id != all.first.id)
      data_anterior = FacebookDatum.where('end_date < ?', datum.start_date.to_date).first
      if !data_anterior.nil?
        return false
      end
    end
    return true
  end
end
