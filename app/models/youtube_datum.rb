class YoutubeDatum < ActiveRecord::Base
  include Datum

  belongs_to :social_network

  set_type :youtube_data

  def new_subscribers
    previous_datum.present? ? total_subscriber - previous_datum.total_subscriber : 0
  end

  def total_investment
    (investment_agency + investment_anno + investment_actions) 
  end

end
