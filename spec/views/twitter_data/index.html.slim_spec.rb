require 'spec_helper'

describe "twitter_data/index" do
  before(:each) do
    assign(:twitter_data, [
      stub_model(TwitterDatum,
        :client_id => "",
        :global_goal => "Global Goal",
        :new_followers => 1,
        :total_followers => 2,
        :goal_followers => 3,
        :amount_tweets => 4,
        :total_tweets => 5,
        :total_mentions => 6,
        :ret_tweets => 7,
        :total_clicks => 8,
        :total_integereractions => 9,
        :agency_investment => 1.5,
        :cost_follower => 1.5
      ),
      stub_model(TwitterDatum,
        :client_id => "",
        :global_goal => "Global Goal",
        :new_followers => 1,
        :total_followers => 2,
        :goal_followers => 3,
        :amount_tweets => 4,
        :total_tweets => 5,
        :total_mentions => 6,
        :ret_tweets => 7,
        :total_clicks => 8,
        :total_integereractions => 9,
        :agency_investment => 1.5,
        :cost_follower => 1.5
      )
    ])
  end

  it "renders a list of twitter_data" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "Global Goal".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => 5.to_s, :count => 2
    assert_select "tr>td", :text => 6.to_s, :count => 2
    assert_select "tr>td", :text => 7.to_s, :count => 2
    assert_select "tr>td", :text => 8.to_s, :count => 2
    assert_select "tr>td", :text => 9.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
  end
end
