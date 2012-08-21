require 'spec_helper'

describe "info_social_networks/index.html.slim" do
  before(:each) do
    assign(:info_social_networks, [
      stub_model(InfoSocialNetwork,
        :name => "Info Social Network Name 1",
        :description => "Text 1",
        :image => "Image File 1"
      ),
      
      stub_model(InfoSocialNetwork,
        :name => "Info Social Network Name 2",
        :description => "Text 2",
        :image => "Image File 2"
      )
    ])
  end

  it "renders a list of info_social_networks" do
    render

    assert_select "tr>td", :text => "Info Social Network Name 1", :count => 1
    assert_select "tr>td", :text => "Info Social Network Name 2", :count => 1
    assert_select "tr>td", :text => "Text 1", :count => 1
    assert_select "tr>td", :text => "Text 2", :count => 1
  end
end
