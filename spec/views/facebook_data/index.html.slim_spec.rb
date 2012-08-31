require 'spec_helper'

describe "facebook_data/index.html.slim" do
  before(:each) do
    info_social_network = assign(:info_social_network, stub_model(InfoSocialNetwork, :name => 'Info Social Network Name', :id => 1, :image => 'Image'))
    InfoSocialNetwork.stub(:find).and_return(info_social_network)
    SocialNetwork.create!(:client_id => 1, :info_social_network_id => 1, :name => "Social Network Name")

    params[:idc] = 1

    FacebookDatum.new(
        :client_id => 1,
        :actions => "MyText",
        :new_fans => 2,
        :total_fans => 3,
        :goal_fans => 4,
        :prints => 6,
        :total_interactions => 8,
        :total_reach => 9,
        :potential_reach => 10,
        :total_prints_per_anno => 11.5,
        :total_prints => 12,
        :total_clicks_anno => 13,
        :start_date => 7.days.ago,
        :end_date => 0.day.ago,
        :fans_through_anno => 14,
        :agency_investment => 15.5,
        :new_stock_investment => 16.5,
        :anno_investment => 17.5,
        :ctr_anno => 20.5,
        :cpm_anno => 21.5,
        :cpc_anno => 22.5,
      ).save!
    FacebookDatum.new(
        :client_id => 1,
        :actions => "MyText",
        :new_fans => 2,
        :total_fans => 3,
        :goal_fans => 4,
        :prints => 6,
        :total_interactions => 8,
        :total_reach => 9,
        :potential_reach => 10,
        :total_prints_per_anno => 11.5,
        :total_prints => 12,
        :total_clicks_anno => 13,
        :start_date => 7.days.ago,
        :end_date => 0.day.ago,
        :fans_through_anno => 14,
        :agency_investment => 15.5,
        :new_stock_investment => 16.5,
        :anno_investment => 17.5,
        :ctr_anno => 20.5,
        :cpm_anno => 21.5,
        :cpc_anno => 22.5,
      ).save!
      assign(:facebook_data, FacebookDatum.all)
  end

  it "renders a list of facebook_data" do

    render

    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 5
    assert_select "tr>td", :text => 6.to_s, :count => 2
    assert_select "tr>td", :text => 8.to_s, :count => 2
    assert_select "tr>td", :text => 9.to_s, :count => 2
    assert_select "tr>td", :text => 10.to_s, :count => 2
    assert_select "tr>td", :text => 11.5.to_s, :count => 2
    assert_select "tr>td", :text => 12.to_s, :count => 2
    assert_select "tr>td", :text => 13.to_s, :count => 2
    assert_select "tr>td", :text => 14.to_s, :count => 2
    assert_select "tr>td", :text => 15.5.to_s, :count => 2
    assert_select "tr>td", :text => 16.5.to_s, :count => 2
    assert_select "tr>td", :text => 17.5.to_s, :count => 2
    assert_select "tr>td", :text => 20.5.to_s, :count => 2
    assert_select "tr>td", :text => 21.5.to_s, :count => 2
    assert_select "tr>td", :text => 22.5.to_s, :count => 2
  end
end
