require 'spec_helper'

describe "foursquare_data/show" do
  before(:each) do
    @foursquare_datum = assign(:foursquare_datum, stub_model(FoursquareDatum,
      :client_id => 1,
      :social_network_id => 2,
      :new_followers => 3,
      :total_followers => 4,
      :total_unlocks => 5,
      :total_visits => 6
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
  end
end
