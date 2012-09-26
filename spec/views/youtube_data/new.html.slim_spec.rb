require 'spec_helper'

describe "youtube_data/new" do
  before(:each) do
    assign(:youtube_datum, stub_model(YoutubeDatum,
      :client_id => 1,
      :social_network_id => 1,
      :new_subscriber => 1,
      :total_subscriber => 1,
      :total_video_views => 1,
      :inserted_player => 1,
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
    ).as_new_record)
  end

  it "renders new youtube_datum form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => youtube_data_path, :method => "post" do
      assert_select "input#youtube_datum_client_id", :name => "youtube_datum[client_id]"
      assert_select "input#youtube_datum_social_network_id", :name => "youtube_datum[social_network_id]"
      assert_select "input#youtube_datum_new_subscriber", :name => "youtube_datum[new_subscriber]"
      assert_select "input#youtube_datum_total_subscriber", :name => "youtube_datum[total_subscriber]"
      assert_select "input#youtube_datum_total_video_views", :name => "youtube_datum[total_video_views]"
      assert_select "input#youtube_datum_inserted_player", :name => "youtube_datum[inserted_player]"
      assert_select "input#youtube_datum_mobile_devise", :name => "youtube_datum[mobile_devise]"
      assert_select "input#youtube_datum_youtube_search", :name => "youtube_datum[youtube_search]"
      assert_select "input#youtube_datum_youtube_suggestion", :name => "youtube_datum[youtube_suggestion]"
      assert_select "input#youtube_datum_youtube_page", :name => "youtube_datum[youtube_page]"
      assert_select "input#youtube_datum_external_web_site", :name => "youtube_datum[external_web_site]"
      assert_select "input#youtube_datum_google_search", :name => "youtube_datum[google_search]"
      assert_select "input#youtube_datum_youtube_others", :name => "youtube_datum[youtube_others]"
      assert_select "input#youtube_datum_youtube_subscriptions", :name => "youtube_datum[youtube_subscriptions]"
      assert_select "input#youtube_datum_youtube_ads", :name => "youtube_datum[youtube_ads]"
      assert_select "input#youtube_datum_investment_agency", :name => "youtube_datum[investment_agency]"
      assert_select "input#youtube_datum_investment_actions", :name => "youtube_datum[investment_actions]"
      assert_select "input#youtube_datum_investment_anno", :name => "youtube_datum[investment_anno]"
    end
  end
end
