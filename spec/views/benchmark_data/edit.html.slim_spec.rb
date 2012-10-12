require 'spec_helper'

describe "benchmark_data/edit" do
  before(:each) do
    @benchmark_datum = assign(:benchmark_datum, stub_model(BenchmarkDatum,
      :client_id => 1,
      :social_network_id => 1,
      :start_date => 1,
      :end_date => 1,
      :title => "MyString",
      :competitor => "MyString",
      :blogs => 1,
      :forums => 1,
      :videos => 1,
      :twitter => 1,
      :facebook => 1,
      :others => 1
    ))
  end

  it "renders the edit benchmark_datum form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => benchmark_data_path(@benchmark_datum), :method => "post" do
      assert_select "input#benchmark_datum_client_id", :name => "benchmark_datum[client_id]"
      assert_select "input#benchmark_datum_social_network_id", :name => "benchmark_datum[social_network_id]"
      assert_select "input#benchmark_datum_start_date", :name => "benchmark_datum[start_date]"
      assert_select "input#benchmark_datum_end_date", :name => "benchmark_datum[end_date]"
      assert_select "input#benchmark_datum_title", :name => "benchmark_datum[title]"
      assert_select "input#benchmark_datum_competitor", :name => "benchmark_datum[competitor]"
      assert_select "input#benchmark_datum_blogs", :name => "benchmark_datum[blogs]"
      assert_select "input#benchmark_datum_forums", :name => "benchmark_datum[forums]"
      assert_select "input#benchmark_datum_videos", :name => "benchmark_datum[videos]"
      assert_select "input#benchmark_datum_twitter", :name => "benchmark_datum[twitter]"
      assert_select "input#benchmark_datum_facebook", :name => "benchmark_datum[facebook]"
      assert_select "input#benchmark_datum_others", :name => "benchmark_datum[others]"
    end
  end
end
