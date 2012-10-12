require 'spec_helper'

describe "benchmark_data/index" do
  before(:each) do
    assign(:benchmark_data, [
      stub_model(BenchmarkDatum,
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
      ),
      stub_model(BenchmarkDatum,
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
      )
    ])
  end

  it "renders a list of benchmark_data" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "Competitor".to_s, :count => 2
    assert_select "tr>td", :text => 5.to_s, :count => 2
    assert_select "tr>td", :text => 6.to_s, :count => 2
    assert_select "tr>td", :text => 7.to_s, :count => 2
    assert_select "tr>td", :text => 8.to_s, :count => 2
    assert_select "tr>td", :text => 9.to_s, :count => 2
    assert_select "tr>td", :text => 10.to_s, :count => 2
  end
end
