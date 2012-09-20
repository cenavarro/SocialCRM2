require 'spec_helper'

describe "linkedin_data/new" do
  before(:each) do
    assign(:linkedin_datum, stub_model(LinkedinDatum,
      :new_followers => 1,
      :total_followers => 1,
      :summary => 1,
      :employment => 1,
      :products_services => 1,
      :prints => 1,
      :clics => 1,
      :recommendation => 1,
      :shared => 1,
      :investment_agency => 1.5,
      :investment_actions => 1.5,
      :investment_anno => 1.5
    ).as_new_record)
  end

  it "renders new linkedin_datum form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => linkedin_data_path, :method => "post" do
      assert_select "input#linkedin_datum_new_followers", :name => "linkedin_datum[new_followers]"
      assert_select "input#linkedin_datum_total_followers", :name => "linkedin_datum[total_followers]"
      assert_select "input#linkedin_datum_summary", :name => "linkedin_datum[summary]"
      assert_select "input#linkedin_datum_employment", :name => "linkedin_datum[employment]"
      assert_select "input#linkedin_datum_products_services", :name => "linkedin_datum[products_services]"
      assert_select "input#linkedin_datum_prints", :name => "linkedin_datum[prints]"
      assert_select "input#linkedin_datum_clics", :name => "linkedin_datum[clics]"
      assert_select "input#linkedin_datum_recommendation", :name => "linkedin_datum[recommendation]"
      assert_select "input#linkedin_datum_shared", :name => "linkedin_datum[shared]"
      assert_select "input#linkedin_datum_investment_agency", :name => "linkedin_datum[investment_agency]"
      assert_select "input#linkedin_datum_investment_actions", :name => "linkedin_datum[investment_actions]"
      assert_select "input#linkedin_datum_investment_anno", :name => "linkedin_datum[investment_anno]"
    end
  end
end
