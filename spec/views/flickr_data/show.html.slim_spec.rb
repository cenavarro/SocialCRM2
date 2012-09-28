require 'spec_helper'

describe "flickr_data/show" do
  before(:each) do
    @flickr_datum = assign(:flickr_datum, stub_model(FlickrDatum,
      :client_id => 1,
      :social_network_id => 2,
      :new_contacts => 3,
      :total_contacts => 4,
      :visits => 5,
      :comments => 6,
      :favorites => 7,
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
