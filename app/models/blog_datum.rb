class BlogDatum < ActiveRecord::Base
  belongs_to :client

  def self.get_diff_unique_visits(datum)
    if !isFirstData?(datum)
      old_data = BlogDatum.where('end_date < ? and social_network_id = ?', datum.start_date.to_date, datum.social_network_id).first
      return ((datum.unique_visits-old_data.unique_visits).to_f/old_data.unique_visits.to_f)*100 if old_data.unique_visits != 0
    end
    return 0 
  end

  def self.get_diff_views_pages(datum)
    if !isFirstData?(datum)
      old_data = BlogDatum.where('end_date < ? and social_network_id = ?', datum.start_date.to_date, datum.social_network_id).first
      return ((datum.view_pages-old_data.view_pages).to_f/old_data.view_pages.to_f)*100 if old_data.view_pages != 0
    end
    return 0 
  end

  def self.isFirstData?(datum)
    before_data = BlogDatum.where('end_date < ? and social_network_id = ?',datum.start_date.to_date, datum.social_network_id).first
		if(before_data == nil)
			return true
		end
		return false
	end
end
