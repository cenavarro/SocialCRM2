require 'spec_helper'

describe "twitter_data/show" do
  before(:each) do
    @twitter_datum = assign(:twitter_datum, stub_model(TwitterDatum,
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
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
    rendered.should match(/Global Goal/)
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/3/)
    rendered.should match(/4/)
    rendered.should match(/5/)
    rendered.should match(/6/)
    rendered.should match(/7/)
    rendered.should match(/8/)
    rendered.should match(/9/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
  end
end
