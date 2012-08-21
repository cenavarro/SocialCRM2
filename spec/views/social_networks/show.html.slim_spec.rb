require 'spec_helper'

describe "social_networks/show.html.slim" do
  before(:each) do
    client = assign(:client, stub_model(Client, :name => "Name", :id => 1))
    Client.stub(:find).and_return(client)

    info_social_network = assign(:info_social_network, stub_model(InfoSocialNetwork, :name => 'Twitter', :id => 1))
    InfoSocialNetwork.stub(:find).and_return(info_social_network)

    @social_network = assign(:social_network, stub_model(SocialNetwork,
      :name => "Name",
      :client_id => 1,
      :info_social_network => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    rendered.should match(/Name/)
    rendered.should match(/1/)
  end
end
