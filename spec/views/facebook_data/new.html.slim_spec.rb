require 'spec_helper'

describe "facebook_data/new.html.slim" do
  before(:each) do
    client = assign(:client, stub_model(Client, :name => "Name", :id => 1))
    Client.stub(:find).and_return(client)

    assign(:facebook_datum, stub_model(FacebookDatum,
      :client_id => 1,
      :actions => "MyText",
      :new_fans => 1,
      :total_fans => 1,
      :goal_fans => 1,
      :prints => 1,
      :total_interactions => 1,
      :total_reach => 1,
      :potential_reach => 1,
      :total_prints_per_anno => 1.5,
      :total_prints => 1,
      :total_clicks_anno => 1,
      :fans_through_anno => 1,
      :agency_investment => 1.5,
      :new_stock_investment => 1.5,
      :anno_investment => 1.5,
      :ctr_anno => 1.5,
      :cpm_anno => 1.5,
      :cpc_anno => 1.5
    ).as_new_record)

    params[:opcion] = 1
    params[:idc] = 1

    assign(:page_fan_adds, 0)
    assign(:page_fan_removes, 0)
    assign(:page_impressions_org, 0)
    assign(:page_story_teller, 0)
    assign(:page_impressions_organic_u, 0)
    assign(:page_consumptions_u, 0)
    assign(:page_impressions_u, 0)
    assign(:page_friends_of_fan, 0)
    assign(:page_impression, 0)
  end

  it "renders new facebook_datum form" do
    render

    assert_select "form", :action => facebook_data_path, :method => "post" do
      assert_select "select#facebook_datum_client_id", :name => "facebook_datum[client_id]"
      assert_select "input#facebook_datum_actions", :name => "facebook_datum[actions]"
      assert_select "input#facebook_datum_new_fans", :name => "facebook_datum[new_fans]"
      assert_select "input#facebook_datum_goal_fans", :name => "facebook_datum[goal_fans]"
      assert_select "input#facebook_datum_prints", :name => "facebook_datum[prints]"
      assert_select "input#facebook_datum_total_interactions", :name => "facebook_datum[total_interactions]"
      assert_select "input#facebook_datum_total_reach", :name => "facebook_datum[total_reach]"
      assert_select "input#facebook_datum_potential_reach", :name => "facebook_datum[potential_reach]"
      assert_select "input#facebook_datum_total_prints_per_anno", :name => "facebook_datum[total_prints_per_anno]"
      assert_select "input#facebook_datum_total_prints", :name => "facebook_datum[total_prints]"
      assert_select "input#facebook_datum_total_clicks_anno", :name => "facebook_datum[total_clicks_anno]"
      assert_select "input#facebook_datum_fans_through_anno", :name => "facebook_datum[fans_through_anno]"
      assert_select "input#facebook_datum_agency_investment", :name => "facebook_datum[agency_investment]"
      assert_select "input#facebook_datum_new_stock_investment", :name => "facebook_datum[new_stock_investment]"
      assert_select "input#facebook_datum_anno_investment", :name => "facebook_datum[anno_investment]"
      assert_select "input#facebook_datum_ctr_anno", :name => "facebook_datum[ctr_anno]"
      assert_select "input#facebook_datum_cpm_anno", :name => "facebook_datum[cpm_anno]"
      assert_select "input#facebook_datum_cpc_anno", :name => "facebook_datum[cpc_anno]"
    end
  end
end
