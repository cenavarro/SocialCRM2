class RowsCampaign < ActiveRecord::Base
  include Datum

  has_many :row_data, :dependent => :destroy

  set_type :rows_campaign
end
