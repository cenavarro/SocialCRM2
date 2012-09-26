require 'spec_helper'

describe "youtube_data/show" do
  before(:each) do
    @youtube_datum = assign(:youtube_datum, stub_model(YoutubeDatum,
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
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/3/)
    rendered.should match(/4/)
    rendered.should match(/5/)
    rendered.should match(/6/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
  end
end
