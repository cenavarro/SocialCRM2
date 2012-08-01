require 'spec_helper'

describe "info_social_networks/show.html.slim" do
  before(:each) do
    @info_social_network = assign(:info_social_network, stub_model(InfoSocialNetwork,
      :name => "Name",
      :description => "MyText",
      :image => "Image"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Image/)
  end
end
