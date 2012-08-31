require 'spec_helper'

describe "facebook_data/edit.html.slim" do
  before(:each) do

    Client.stub(:find).and_return(stub_model(Client, :name => "Name", :id => 1))

    @facebook_datum = assign(:facebook_datum, stub_model(FacebookDatum,
      :client_id => 1,
      :actions => "MyText",
      :new_fans => 2,
      :total_fans => 3,
      :goal_fans => 4,
      :fans_growth_porcent => 5.5,
      :prints => 6,
      :porcentual_diferent => 7.5,
      :total_interactions => 8,
      :total_reach => 9,
      :potential_reach => 10,
      :total_prints_per_anno => 11.5,
      :total_prints => 12,
      :total_clicks_anno => 13,
      :fans_through_anno => 14,
      :agency_investment => 15.5,
      :new_stock_investment => 16.5,
      :anno_investment => 17.5,
      :total_investment => 18.5,
      :cpm_prints => 19.5,
      :ctr_anno => 20.5,
      :cpm_anno => 21.5,
      :cpc_anno => 22.5,
      :fan_cost => 23.5
    ))
  end

  it "renders the edit facebook_datum form" do
    
    render

    assert_select "form", :action => facebook_data_path(@facebook_datum), :method => "post" do
      assert_select "select#facebook_datum_client_id", :name => "facebook_datum[client_id]"
      assert_select "input#facebook_datum_actions", :name => "facebook_datum[actions]"
      assert_select "input#facebook_datum_new_fans", :name => "facebook_datum[new_fans]"
      assert_select "input#facebook_datum_total_fans", :name => "facebook_datum[total_fans]"
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
