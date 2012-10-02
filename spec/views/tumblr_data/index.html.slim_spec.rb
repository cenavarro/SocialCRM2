require 'spec_helper'

describe "tumblr_data/index" do
  before(:each) do
    assign(:tumblr_data, [
      stub_model(TumblrDatum,
        :client_id => 1,
        :social_network_id => 2,
        :new_followers => 3,
        :total_followers => 4,
        :likes => 5,
        :reblogged => 6,
        :investment_agency => 1.5,
        :investment_actions => 1.5,
        :investment_ads => 1.5
      ),
      stub_model(TumblrDatum,
        :client_id => 1,
        :social_network_id => 2,
        :new_followers => 3,
        :total_followers => 4,
        :likes => 5,
        :reblogged => 6,
        :investment_agency => 1.5,
        :investment_actions => 1.5,
        :investment_ads => 1.5
      )
    ])
  end

  it "renders a list of tumblr_data" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => 5.to_s, :count => 2
    assert_select "tr>td", :text => 6.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
  end
end
