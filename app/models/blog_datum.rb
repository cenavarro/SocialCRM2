class BlogDatum < ActiveRecord::Base
  include Datum
  belongs_to :social_network

  set_type :blog_data
  
  comparable_metrics :unique_visits, :view_pages

end

