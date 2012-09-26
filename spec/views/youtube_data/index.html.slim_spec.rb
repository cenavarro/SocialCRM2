require 'spec_helper'

describe "youtube_data/index" do
  before(:each) do
    assign(:youtube_data, [
      stub_model(YoutubeDatum,
        :client_id => 1,
        :social_network_id => 2,
        :new_subscriber => 3,
        :total_subscriber => 4,
        :total_video_views => 5,
        :inserted_player => 6,
        :mobile_devise => 1.5,
        :youtube_search => 1.5,
        :youtube_suggestion => 1.5,
        :youtube_page => 1.5,
        :external_web_site => 1.5,
        :google_search => 1.5,
        :youtube_others => 1.5,
        :youtube_subscriptions => 1.5,
        :youtube_ads => 1.5,
        :investment_agency => 1.5,
        :investment_actions => 1.5,
        :investment_anno => 1.5
      ),
      stub_model(YoutubeDatum,
        :client_id => 1,
        :social_network_id => 2,
        :new_subscriber => 3,
        :total_subscriber => 4,
        :total_video_views => 5,
        :inserted_player => 6,
        :mobile_devise => 1.5,
        :youtube_search => 1.5,
        :youtube_suggestion => 1.5,
        :youtube_page => 1.5,
        :external_web_site => 1.5,
        :google_search => 1.5,
        :youtube_others => 1.5,
        :youtube_subscriptions => 1.5,
        :youtube_ads => 1.5,
        :investment_agency => 1.5,
        :investment_actions => 1.5,
        :investment_anno => 1.5
      )
    ])
  end

  it "renders a list of youtube_data" do
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
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
  end
end
