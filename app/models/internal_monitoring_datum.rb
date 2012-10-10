class InternalMonitoringDatum < ActiveRecord::Base
  belongs_to :social_network

  def self.get_total_theme(datum)
    (datum.complaints + datum.client_att + datum.lead + datum.engaged + datum.curiosities + datum.mentions + datum.feedback)
  end

  def self.get_total_comments(channels, datum)
    total_comments = 0
    channels.each do |channel|
      channel_value = datum["channel_#{channel.channel_number}"]
      total_comments = total_comments + channel_value.to_i
    end
    total_comments
  end

  def self.get_change_volume_comments(channels, datum)
    if !isFirstData?(datum)
      previous_data = InternalMonitoringDatum.where('end_date < ? and social_network_id = ?',datum.start_date.to_date, datum.social_network_id).first
      prev_total_comments = get_total_comments(channels, previous_data)
      prev_total_comments != 0 ? (return ((get_total_comments(channels, datum).to_f-prev_total_comments.to_f)/prev_total_comments.to_f)) : (return 0) 
    end
    return 0
  end

  def self.get_daily_average(channels, datum)
    total_comments = get_total_comments(channels, datum)
    num_days = datum.end_date - datum.start_date
    return (total_comments.to_f/((num_days.to_i) + 1))
  end

  def self.isFirstData?(datum)
    previous_data = InternalMonitoringDatum.where('end_date < ? and social_network_id = ?',datum.start_date.to_date, datum.social_network_id).first
		(previous_data == nil) ? (return true) : (return false)
  end
end
