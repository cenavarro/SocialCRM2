require 'spec_helper'

describe "linkedin_data/index" do
  before(:each) do
    assign(:linkedin_data, [
      stub_model(LinkedinDatum,
        :new_followers => 1,
        :total_followers => 2,
        :summary => 3,
        :employment => 4,
        :products_services => 5,
        :prints => 6,
        :clics => 7,
        :recommendation => 8,
        :shared => 9,
        :investment_agency => 1.5,
        :investment_actions => 1.5,
        :investment_anno => 1.5
      ),
      stub_model(LinkedinDatum,
        :new_followers => 1,
        :total_followers => 2,
        :summary => 3,
        :employment => 4,
        :products_services => 5,
        :prints => 6,
        :clics => 7,
        :recommendation => 8,
        :shared => 9,
        :investment_agency => 1.5,
        :investment_actions => 1.5,
        :investment_anno => 1.5
      )
    ])
  end

  it "renders a list of linkedin_data" do
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
    assert_select "tr>td", :text => 9.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
  end
end
