require 'spec_helper'

describe "twitter_data/edit" do
  before(:each) do

    client = assign(:client, stub_model(Client, :name => "Name", :id => 1))
    Client.stub(:find).and_return(client)

    @twitter_datum = assign(:twitter_datum, stub_model(TwitterDatum,
      :client_id => 1,
      :global_goal => "MyString",
      :new_followers => 1,
      :total_followers => 1,
      :goal_followers => 1,
      :amount_tweets => 1,
      :total_tweets => 1,
      :total_mentions => 1,
      :ret_tweets => 1,
      :total_clicks => 1,
      :total_integereractions => 1,
      :agency_investment => 1.5,
      :cost_follower => 1.5
    ))
  end

  it "renders the edit twitter_datum form" do
    render

    assert_select "form", :action => twitter_data_path(@twitter_datum), :method => "post" do
      assert_select "select#twitter_datum_client_id", :name => "twitter_datum[client_id]"
      assert_select "input#twitter_datum_new_followers", :name => "twitter_datum[new_followers]"
      assert_select "input#twitter_datum_total_followers", :name => "twitter_datum[total_followers]"
      assert_select "input#twitter_datum_goal_followers", :name => "twitter_datum[goal_followers]"
      assert_select "input#twitter_datum_amount_tweets", :name => "twitter_datum[amount_tweets]"
      assert_select "input#twitter_datum_total_tweets", :name => "twitter_datum[total_tweets]"
      assert_select "input#twitter_datum_total_mentions", :name => "twitter_datum[total_mentions]"
      assert_select "input#twitter_datum_ret_tweets", :name => "twitter_datum[ret_tweets]"
      assert_select "input#twitter_datum_total_clicks", :name => "twitter_datum[total_clicks]"
      assert_select "input#twitter_datum_total_interactions", :name => "twitter_datum[total_interactions]"
      assert_select "input#twitter_datum_agency_investment", :name => "twitter_datum[agency_investment]"
    end
  end
end
