require 'spec_helper'

describe "social_networks/edit.html.slim" do
  before(:each) do
    client = assign(:client, stub_model(Client, :name => "Name", :id => 1))
    Client.stub(:find).and_return(client)

    info_social_network = assign(:info_social_network, stub_model(InfoSocialNetwork, :name => 'Twitter', :id => 1))
    InfoSocialNetwork.stub(:find).and_return(info_social_network)

    @social_network = assign(:social_network, stub_model(SocialNetwork,
      :name => "MyString",
      :client_id => 1
    ))
  end

  it "renders the edit social_network form" do
    render

    assert_select "form", :action => social_networks_path(@social_network), :method => "post" do
      assert_select "input#social_network_name", :name => "social_network[name]"
      assert_select "select#social_network_client_id", :name => "social_network[client_id]"
      assert_select "select#social_network_info_social_network_id", :name => "social_network[info_social_network_id]"
    end
  end
end