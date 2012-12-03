class BenchmarkDatum < ActiveRecord::Base
  include Datum

  belongs_to :social_network

  set_type :benchmark_data

end
