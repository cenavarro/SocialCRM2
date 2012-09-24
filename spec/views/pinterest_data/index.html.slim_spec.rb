require 'spec_helper'

describe "pinterest_data/index" do
  before(:each) do
    assign(:pinterest_data, [
      stub_model(PinterestDatum,
        :new_followers => 1,
        :total_followers => 2,
        :boards => 3,
        :pins => 4,
        :liked => 5,
        :repin => 6,
        :comments => 7,
        :community_boards => 8,
        :investment_agency => 1.5,
        :investment_actions => 1.5,
        :investment_ads => 1.5,
        :client_id => 9,
        :social_network_id => 10
      ),
      stub_model(PinterestDatum,
        :new_followers => 1,
        :total_followers => 2,
        :boards => 3,
        :pins => 4,
        :liked => 5,
        :repin => 6,
        :comments => 7,
        :community_boards => 8,
        :investment_agency => 1.5,
        :investment_actions => 1.5,
        :investment_ads => 1.5,
        :client_id => 9,
        :social_network_id => 10
      )
    ])
  end

  it "renders a list of pinterest_data" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => 5.to_s, :count => 2
    assert_select "tr>td", :text => 6.to_s, :count => 2
    assert_select "tr>td", :text => 7.to_s, :count => 2
    assert_select "tr>td", :text => 8.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => 9.to_s, :count => 2
    assert_select "tr>td", :text => 10.to_s, :count => 2
  end
end
