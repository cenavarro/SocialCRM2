class BenchmarkDatum < ActiveRecord::Base
  include Datum

  belongs_to :benchmark_competitor

  set_type :benchmark_data

end
