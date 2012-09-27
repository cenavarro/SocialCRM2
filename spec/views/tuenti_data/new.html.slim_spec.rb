require 'spec_helper'

describe "tuenti_data/new" do
  before(:each) do
    assign(:tuenti_datum, stub_model(TuentiDatum,
      :client_id => 1,
      :social_network_id => 1,
      :new_fans => 1,
      :real_fans => 1,
      :goal_fans => 1,
      :investment_agency => 1.5,
      :investment_actions => 1.5,
      :investment_ads => 1.5,
      :cost_fan => 1.5,
      :page_prints => 1,
      :unique_total_users => 1,
      :external_clics => 1,
      :clics => 1,
      :downloads => 1,
      :comments => 1,
      :ctr_external_clics => 1.5,
      :upload_photos => 1
    ).as_new_record)
  end

  it "renders new tuenti_datum form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tuenti_data_path, :method => "post" do
      assert_select "input#tuenti_datum_client_id", :name => "tuenti_datum[client_id]"
      assert_select "input#tuenti_datum_social_network_id", :name => "tuenti_datum[social_network_id]"
      assert_select "input#tuenti_datum_new_fans", :name => "tuenti_datum[new_fans]"
      assert_select "input#tuenti_datum_real_fans", :name => "tuenti_datum[real_fans]"
      assert_select "input#tuenti_datum_goal_fans", :name => "tuenti_datum[goal_fans]"
      assert_select "input#tuenti_datum_investment_agency", :name => "tuenti_datum[investment_agency]"
      assert_select "input#tuenti_datum_investment_actions", :name => "tuenti_datum[investment_actions]"
      assert_select "input#tuenti_datum_investment_ads", :name => "tuenti_datum[investment_ads]"
      assert_select "input#tuenti_datum_cost_fan", :name => "tuenti_datum[cost_fan]"
      assert_select "input#tuenti_datum_page_prints", :name => "tuenti_datum[page_prints]"
      assert_select "input#tuenti_datum_unique_total_users", :name => "tuenti_datum[unique_total_users]"
      assert_select "input#tuenti_datum_external_clics", :name => "tuenti_datum[external_clics]"
      assert_select "input#tuenti_datum_clics", :name => "tuenti_datum[clics]"
      assert_select "input#tuenti_datum_downloads", :name => "tuenti_datum[downloads]"
      assert_select "input#tuenti_datum_comments", :name => "tuenti_datum[comments]"
      assert_select "input#tuenti_datum_ctr_external_clics", :name => "tuenti_datum[ctr_external_clics]"
      assert_select "input#tuenti_datum_upload_photos", :name => "tuenti_datum[upload_photos]"
    end
  end
end
