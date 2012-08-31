require 'spec_helper'

describe "twitter_data/index" do

  before(:each) do

    InfoSocialNetwork.new(:name => "ISN 1", :image => "logo1.png").save!
    InfoSocialNetwork.new(:name => "ISN 2", :image => "logo2.png").save!

    Client.new(:name => "Name Client", :description => "Description", :image => "image.png").save!
    params[:idc] = 1

    SocialNetwork.new(:name => "SN C1", :client_id => 1, :info_social_network_id => 2).save!

    TwitterDatum.new(:client_id => 1,
        :global_goal => "Global Goal",
        :new_followers => 1,
        :total_followers => 2,
        :goal_followers => 3,
        :amount_tweets => 4,
        :total_tweets => 5,
        :total_mentions => 6,
        :ret_tweets => 7,
        :total_clicks => 8,
        :total_interactions => 9,
        :agency_investment => 1.5,
        :cost_follower => 1.5,
        :start_date => "2012/08/01".to_date,
        :end_date => "2012/08/15".to_date).save!

    TwitterDatum.new(:client_id => 1,
        :global_goal => "Global Goal",
        :new_followers => 1,
        :total_followers => 2,
        :goal_followers => 3,
        :amount_tweets => 4,
        :total_tweets => 5,
        :total_mentions => 6,
        :ret_tweets => 7,
        :total_clicks => 8,
        :total_interactions => 9,
        :agency_investment => 1.5,
        :cost_follower => 1.5,
        :start_date => "2012/08/01".to_date,
        :end_date => "2012/08/15".to_date).save!

    assign(:twitter_data, [
      stub_model(TwitterDatum,
        :id => 1,
        :client_id => 1,
        :global_goal => "Global Goal",
        :new_followers => 1,
        :total_followers => 2,
        :goal_followers => 3,
        :amount_tweets => 4,
        :total_tweets => 5,
        :total_mentions => 6,
        :ret_tweets => 7,
        :total_clicks => 8,
        :total_interactions => 9,
        :agency_investment => 1.5,
        :cost_follower => 1.5,
        :start_date => "2012/08/01".to_date,
        :end_date => "2012/08/15".to_date
     ),
      stub_model(TwitterDatum,
        :id => 2,
        :client_id => 1,
        :global_goal => "Global Goal",
        :new_followers => 1,
        :total_followers => 2,
        :goal_followers => 3,
        :amount_tweets => 4,
        :total_tweets => 5,
        :total_mentions => 6,
        :ret_tweets => 7,
        :total_clicks => 8,
        :total_interactions => 9,
        :agency_investment => 1.5,
        :cost_follower => 1.5,
        :start_date => "2012/08/01".to_date,
        :end_date => "2012/08/15".to_date
      )
    ])
  end

  it "renders a list of twitter_data" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => 5.to_s, :count => 2
    assert_select "tr>td", :text => 6.to_s, :count => 2
    assert_select "tr>td", :text => 7.to_s, :count => 2
    assert_select "tr>td", :text => 8.to_s, :count => 2
    assert_select "tr>td", :text => 9.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 4
  end
end
