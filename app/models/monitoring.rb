class Monitoring < ActiveRecord::Base
  extend ApplicationHelper
  has_many "monitoring_data", :dependent => :destroy
end
