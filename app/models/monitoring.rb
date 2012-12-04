class Monitoring < ActiveRecord::Base
  include Datum

  has_many "monitoring_data", :dependent => :destroy

end
