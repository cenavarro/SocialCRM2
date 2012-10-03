class BlogDatum < ActiveRecord::Base
  belongs_to :social_network

  def self.get_diff_unique_visits(datum)
    if !isFirstData?(datum)
      previous_data = BlogDatum.where('end_date < ? and social_network_id = ?', datum.start_date.to_date, datum.social_network_id).first
      return ((datum.unique_visits-previous_data.unique_visits).to_f/previous_data.unique_visits.to_f)*100 if previous_data.unique_visits != 0
    end
    return 0 
  end

  def self.get_diff_views_pages(datum)
    if !isFirstData?(datum)
      previous_data = BlogDatum.where('end_date < ? and social_network_id = ?', datum.start_date.to_date, datum.social_network_id).first
      return ((datum.view_pages-previous_data.view_pages).to_f/previous_data.view_pages.to_f)*100 if previous_data.view_pages != 0
    end
    return 0 
  end

  def self.isFirstData?(datum)
    previous_data = BlogDatum.where('end_date < ? and social_network_id = ?',datum.start_date.to_date, datum.social_network_id).first
		if(previous_data == nil)
			return true
		end
		return false
  end
end

