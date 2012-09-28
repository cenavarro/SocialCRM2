require 'spec_helper'

describe "flickr_data/new" do
  before(:each) do
    assign(:flickr_datum, stub_model(FlickrDatum,
      :client_id => 1,
      :social_network_id => 1,
      :new_contacts => 1,
      :total_contacts => 1,
      :visits => 1,
      :comments => 1,
      :favorites => 1,
      :investment_agency => 1.5,
      :investment_actions => 1.5,
      :investment_ads => 1.5
    ).as_new_record)
  end

  it "renders new flickr_datum form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => flickr_data_path, :method => "post" do
      assert_select "input#flickr_datum_client_id", :name => "flickr_datum[client_id]"
      assert_select "input#flickr_datum_social_network_id", :name => "flickr_datum[social_network_id]"
      assert_select "input#flickr_datum_new_contacts", :name => "flickr_datum[new_contacts]"
      assert_select "input#flickr_datum_total_contacts", :name => "flickr_datum[total_contacts]"
      assert_select "input#flickr_datum_visits", :name => "flickr_datum[visits]"
      assert_select "input#flickr_datum_comments", :name => "flickr_datum[comments]"
      assert_select "input#flickr_datum_favorites", :name => "flickr_datum[favorites]"
      assert_select "input#flickr_datum_investment_agency", :name => "flickr_datum[investment_agency]"
      assert_select "input#flickr_datum_investment_actions", :name => "flickr_datum[investment_actions]"
      assert_select "input#flickr_datum_investment_ads", :name => "flickr_datum[investment_ads]"
    end
  end
end
