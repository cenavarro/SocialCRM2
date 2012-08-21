require 'spec_helper'

describe "social_networks/new.html.slim" do
  before(:each) do
    client = assign(:client, stub_model(Client, :name => "Name", :id => 1))
    Client.stub(:find).and_return(client)

    info_social_network = assign(:info_social_network, stub_model(InfoSocialNetwork, :name => 'Twitter', :id => 1))
    InfoSocialNetwork.stub(:find).and_return(info_social_network)

    assign(:social_network, stub_model(SocialNetwork,
      :name => "Name",
      :client_id => 1,
      :info_social_network => 1
    ).as_new_record)
  end

  it "renders new social_network form" do
    render

    assert_select "form", :action => social_networks_path, :method => "post" do
      assert_select "input#social_network_name", :name => "social_network[name]"
      assert_select "select#social_network_client_id", :name => "social_network[client_id]"
      assert_select "select#social_network_info_social_network_id", :name => "social_network[info_social_network_id]"
    end
  end
end
