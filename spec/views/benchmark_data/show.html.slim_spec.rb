require 'spec_helper'

describe "benchmark_data/show" do
  before(:each) do
    @benchmark_datum = assign(:benchmark_datum, stub_model(BenchmarkDatum,
      :client_id => 1,
      :social_network_id => 2,
      :start_date => 3,
      :end_date => 4,
      :title => "Title",
      :competitor => "Competitor",
      :blogs => 5,
      :forums => 6,
      :videos => 7,
      :twitter => 8,
      :facebook => 9,
      :others => 10
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/3/)
    rendered.should match(/4/)
    rendered.should match(/Title/)
    rendered.should match(/Competitor/)
    rendered.should match(/5/)
    rendered.should match(/6/)
    rendered.should match(/7/)
    rendered.should match(/8/)
    rendered.should match(/9/)
    rendered.should match(/10/)
  end
end
