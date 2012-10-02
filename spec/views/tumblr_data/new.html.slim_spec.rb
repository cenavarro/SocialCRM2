require 'spec_helper'

describe "tumblr_data/new" do
  before(:each) do
    assign(:tumblr_datum, stub_model(TumblrDatum,
      :client_id => 1,
      :social_network_id => 1,
      :new_followers => 1,
      :total_followers => 1,
      :likes => 1,
      :reblogged => 1,
      :investment_agency => 1.5,
      :investment_actions => 1.5,
      :investment_ads => 1.5
    ).as_new_record)
  end

  it "renders new tumblr_datum form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tumblr_data_path, :method => "post" do
      assert_select "input#tumblr_datum_client_id", :name => "tumblr_datum[client_id]"
      assert_select "input#tumblr_datum_social_network_id", :name => "tumblr_datum[social_network_id]"
      assert_select "input#tumblr_datum_new_followers", :name => "tumblr_datum[new_followers]"
      assert_select "input#tumblr_datum_total_followers", :name => "tumblr_datum[total_followers]"
      assert_select "input#tumblr_datum_likes", :name => "tumblr_datum[likes]"
      assert_select "input#tumblr_datum_reblogged", :name => "tumblr_datum[reblogged]"
      assert_select "input#tumblr_datum_investment_agency", :name => "tumblr_datum[investment_agency]"
      assert_select "input#tumblr_datum_investment_actions", :name => "tumblr_datum[investment_actions]"
      assert_select "input#tumblr_datum_investment_ads", :name => "tumblr_datum[investment_ads]"
    end
  end
end
