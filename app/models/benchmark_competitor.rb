class BenchmarkCompetitor < ActiveRecord::Base
  belongs_to :social_network
  has_many :benchmark_data, :dependent => :destroy
end
