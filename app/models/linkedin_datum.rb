class LinkedinDatum < ActiveRecord::Base
  include Datum

  belongs_to :social_network

  set_type :linkedin_data

  comparable_metrics :total_followers

  def new_followers
    previous_datum.present? ? total_followers - previous_datum.total_followers : 0
  end

  def views_page
    (summary + employment + products_services)
  end

  def total_investment
    (investment_agency + investment_anno + investment_actions) 
  end

end