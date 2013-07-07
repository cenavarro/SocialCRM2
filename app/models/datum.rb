module Datum

  def compare_metric metric, other_datum
    return 0 if other_datum.nil? || other_datum.send(metric) == 0
    ((send(metric)-other_datum.send(metric)).to_f/other_datum.send(metric).to_f)*100
  end

  def previous_datum
    social_network.send(type).where("end_date <= ? and id != ?", end_date.to_date, id).order('end_date ASC').last
  end

  def type
    self.class.type
  end

  def self.included(obj)
    obj.extend(ClassMethods)
  end

  module ClassMethods

    def set_type (type)
      @type = type
    end

     def type
       @type
     end

    def comparable_metrics(*metrics)
      metrics.each do |metric|
        define_method "#{metric.to_s}_compared_to" do |other_datum|
          compare_metric(metric, other_datum)
        end

        define_method "get_percentage_difference_from_previous_#{metric.to_s}" do
          send("#{metric.to_s}_compared_to", previous_datum)
        end
      end
    end

  end
end
