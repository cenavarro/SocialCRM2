class Monitoring < ActiveRecord::Base
  has_many "monitoring_data", :dependent => :destroy
end
