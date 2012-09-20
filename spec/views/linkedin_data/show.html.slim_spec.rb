require 'spec_helper'

describe "linkedin_data/show" do
  before(:each) do
    @linkedin_datum = assign(:linkedin_datum, stub_model(LinkedinDatum,
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
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/3/)
    rendered.should match(/4/)
    rendered.should match(/5/)
    rendered.should match(/6/)
    rendered.should match(/7/)
    rendered.should match(/8/)
    rendered.should match(/9/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
  end
end
