require 'spec_helper'

describe "foursquare_data/new" do
  before(:each) do
    assign(:foursquare_datum, stub_model(FoursquareDatum,
      :client_id => 1,
      :social_network_id => 1,
      :new_followers => 1,
      :total_followers => 1,
      :total_unlocks => 1,
      :total_visits => 1
    ).as_new_record)
  end

  it "renders new foursquare_datum form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => foursquare_data_path, :method => "post" do
      assert_select "input#foursquare_datum_client_id", :name => "foursquare_datum[client_id]"
      assert_select "input#foursquare_datum_social_network_id", :name => "foursquare_datum[social_network_id]"
      assert_select "input#foursquare_datum_new_followers", :name => "foursquare_datum[new_followers]"
      assert_select "input#foursquare_datum_total_followers", :name => "foursquare_datum[total_followers]"
      assert_select "input#foursquare_datum_total_unlocks", :name => "foursquare_datum[total_unlocks]"
      assert_select "input#foursquare_datum_total_visits", :name => "foursquare_datum[total_visits]"
    end
  end
end
