require 'spec_helper'

describe "pinterest_data/show" do
  before(:each) do
    @pinterest_datum = assign(:pinterest_datum, stub_model(PinterestDatum,
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
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
    rendered.should match(/9/)
    rendered.should match(/10/)
  end
end
