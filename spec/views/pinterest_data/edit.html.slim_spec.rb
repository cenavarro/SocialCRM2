require 'spec_helper'

describe "pinterest_data/edit" do
  before(:each) do
    @pinterest_datum = assign(:pinterest_datum, stub_model(PinterestDatum,
      :new_followers => 1,
      :total_followers => 1,
      :boards => 1,
      :pins => 1,
      :liked => 1,
      :repin => 1,
      :comments => 1,
      :community_boards => 1,
      :investment_agency => 1.5,
      :investment_actions => 1.5,
      :investment_ads => 1.5,
      :client_id => 1,
      :social_network_id => 1
    ))
  end

  it "renders the edit pinterest_datum form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => pinterest_data_path(@pinterest_datum), :method => "post" do
      assert_select "input#pinterest_datum_new_followers", :name => "pinterest_datum[new_followers]"
      assert_select "input#pinterest_datum_total_followers", :name => "pinterest_datum[total_followers]"
      assert_select "input#pinterest_datum_boards", :name => "pinterest_datum[boards]"
      assert_select "input#pinterest_datum_pins", :name => "pinterest_datum[pins]"
      assert_select "input#pinterest_datum_liked", :name => "pinterest_datum[liked]"
      assert_select "input#pinterest_datum_repin", :name => "pinterest_datum[repin]"
      assert_select "input#pinterest_datum_comments", :name => "pinterest_datum[comments]"
      assert_select "input#pinterest_datum_community_boards", :name => "pinterest_datum[community_boards]"
      assert_select "input#pinterest_datum_investment_agency", :name => "pinterest_datum[investment_agency]"
      assert_select "input#pinterest_datum_investment_actions", :name => "pinterest_datum[investment_actions]"
      assert_select "input#pinterest_datum_investment_ads", :name => "pinterest_datum[investment_ads]"
      assert_select "input#pinterest_datum_client_id", :name => "pinterest_datum[client_id]"
      assert_select "input#pinterest_datum_social_network_id", :name => "pinterest_datum[social_network_id]"
    end
  end
end
