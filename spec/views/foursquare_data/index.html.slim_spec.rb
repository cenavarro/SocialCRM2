require 'spec_helper'

describe "foursquare_data/index" do
  before(:each) do
    assign(:foursquare_data, [
      stub_model(FoursquareDatum,
        :client_id => 1,
        :social_network_id => 2,
        :new_followers => 3,
        :total_followers => 4,
        :total_unlocks => 5,
        :total_visits => 6
      ),
      stub_model(FoursquareDatum,
        :client_id => 1,
        :social_network_id => 2,
        :new_followers => 3,
        :total_followers => 4,
        :total_unlocks => 5,
        :total_visits => 6
      )
    ])
  end

  it "renders a list of foursquare_data" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => 5.to_s, :count => 2
    assert_select "tr>td", :text => 6.to_s, :count => 2
  end
end
