require 'spec_helper'

describe "tuenti_data/index" do
  before(:each) do
    assign(:tuenti_data, [
      stub_model(TuentiDatum,
        :client_id => 1,
        :social_network_id => 2,
        :new_fans => 3,
        :real_fans => 4,
        :goal_fans => 5,
        :investment_agency => 1.5,
        :investment_actions => 1.5,
        :investment_ads => 1.5,
        :cost_fan => 1.5,
        :page_prints => 6,
        :unique_total_users => 7,
        :external_clics => 8,
        :clics => 9,
        :downloads => 10,
        :comments => 11,
        :ctr_external_clics => 1.5,
        :upload_photos => 12
      ),
      stub_model(TuentiDatum,
        :client_id => 1,
        :social_network_id => 2,
        :new_fans => 3,
        :real_fans => 4,
        :goal_fans => 5,
        :investment_agency => 1.5,
        :investment_actions => 1.5,
        :investment_ads => 1.5,
        :cost_fan => 1.5,
        :page_prints => 6,
        :unique_total_users => 7,
        :external_clics => 8,
        :clics => 9,
        :downloads => 10,
        :comments => 11,
        :ctr_external_clics => 1.5,
        :upload_photos => 12
      )
    ])
  end

  it "renders a list of tuenti_data" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => 5.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => 6.to_s, :count => 2
    assert_select "tr>td", :text => 7.to_s, :count => 2
    assert_select "tr>td", :text => 8.to_s, :count => 2
    assert_select "tr>td", :text => 9.to_s, :count => 2
    assert_select "tr>td", :text => 10.to_s, :count => 2
    assert_select "tr>td", :text => 11.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => 12.to_s, :count => 2
  end
end
