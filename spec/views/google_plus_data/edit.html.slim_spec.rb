require 'spec_helper'

describe "google_plus_data/edit" do
  before(:each) do
    @google_plus_datum = assign(:google_plus_datum, stub_model(GooglePlusDatum,
      :client_id => 1,
      :social_network_id => 1,
      :new_followers => 1,
      :total_followers => 1,
      :plus => 1,
      :content_shared => 1,
      :total_interactions => 1,
      :investment_agency => 1.5,
      :investment_actions => 1.5,
      :investment_ads => 1.5
    ))
  end

  it "renders the edit google_plus_datum form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => google_plus_data_path(@google_plus_datum), :method => "post" do
      assert_select "input#google_plus_datum_client_id", :name => "google_plus_datum[client_id]"
      assert_select "input#google_plus_datum_social_network_id", :name => "google_plus_datum[social_network_id]"
      assert_select "input#google_plus_datum_new_followers", :name => "google_plus_datum[new_followers]"
      assert_select "input#google_plus_datum_total_followers", :name => "google_plus_datum[total_followers]"
      assert_select "input#google_plus_datum_plus", :name => "google_plus_datum[plus]"
      assert_select "input#google_plus_datum_content_shared", :name => "google_plus_datum[content_shared]"
      assert_select "input#google_plus_datum_total_interactions", :name => "google_plus_datum[total_interactions]"
      assert_select "input#google_plus_datum_investment_agency", :name => "google_plus_datum[investment_agency]"
      assert_select "input#google_plus_datum_investment_actions", :name => "google_plus_datum[investment_actions]"
      assert_select "input#google_plus_datum_investment_ads", :name => "google_plus_datum[investment_ads]"
    end
  end
end
