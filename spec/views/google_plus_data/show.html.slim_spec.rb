require 'spec_helper'

describe "google_plus_data/show" do
  before(:each) do
    @google_plus_datum = assign(:google_plus_datum, stub_model(GooglePlusDatum,
      :client_id => 1,
      :social_network_id => 2,
      :new_followers => 3,
      :total_followers => 4,
      :plus => 5,
      :content_shared => 6,
      :total_interactions => 7,
      :investment_agency => 1.5,
      :investment_actions => 1.5,
      :investment_ads => 1.5
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
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
  end
end
