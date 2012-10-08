class RowsCampaign < ActiveRecord::Base
  has_many :row_data, :dependent => :destroy
end
