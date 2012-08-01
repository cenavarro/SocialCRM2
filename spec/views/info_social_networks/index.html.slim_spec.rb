require 'spec_helper'

describe "info_social_networks/index.html.slim" do
  before(:each) do
    assign(:info_social_networks, [
      stub_model(InfoSocialNetwork,
        :name => "Name",
        :description => "MyText",
        :image => "Image"
      ),
      stub_model(InfoSocialNetwork,
        :name => "Name",
        :description => "MyText",
        :image => "Image"
      )
    ])
  end

  it "renders a list of info_social_networks" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Image".to_s, :count => 2
  end
end
