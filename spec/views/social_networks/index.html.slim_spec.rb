require 'spec_helper'

describe "social_networks/index.html.slim" do
  before(:each) do
    client = assign(:client, stub_model(Client, :name => "Client Name", :id => 1))
    Client.stub(:find).and_return(client)

    info_social_network = assign(:info_social_network, stub_model(InfoSocialNetwork, :name => 'Info Social Network Name', :id => 1))
    InfoSocialNetwork.stub(:find).and_return(info_social_network)

    assign(:social_networks, [
      stub_model(SocialNetwork,
        :name => "Social Network Name 1",
        :client_id => 1
      ),

      stub_model(SocialNetwork,
        :name => "Social Network Name 2",
        :client_id => 1
      )
    ])
  end

  it "renders a list of social_networks" do
    render

    assert_select "tr>td", :text => "Social Network Name 1", :count => 1
    assert_select "tr>td", :text => "Social Network Name 2", :count => 1
    assert_select "tr>td", :text => "Info Social Network Name", :count => 2
    assert_select "tr>td", :text => "Client Name", :count => 2
  end
end
