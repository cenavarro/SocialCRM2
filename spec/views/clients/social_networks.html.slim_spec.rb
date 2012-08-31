require 'spec_helper'

describe "clients/social_networks.html.slim" do


  before(:each) do
    client = Client.new(:name => "Client 1", :description => "Description", :image => "image.png")
    client.save!
    info = InfoSocialNetwork.new(:name => "Info Social Network Name 1", :description => "Info Social Description 1", :image => "logo1.png")
    info.save!
    info = InfoSocialNetwork.new(:name => "Info Social Network Name 2", :description => "Info Social Description 2", :image => "logo2.png")
    info.save!
    info = InfoSocialNetwork.new(:name => "Info Social Network Name 3", :description => "Info Social Description 3", :image => "logo3.png")
    info.save!
    SocialNetwork.new(:name => "Social Network Client 1", :client_id => client.id, :info_social_network_id => 1).save!
    SocialNetwork.new(:name => "Social Network Client 2", :client_id => client.id, :info_social_network_id => 2).save!
    SocialNetwork.new(:name => "Social Network Client 3", :client_id => client.id, :info_social_network_id => 3).save!
    assign(:client,  Client.find(client.id))
  end

  it "renders a list of social networks" do
    render

    rendered.should have_content("Social Network Client 1")
    rendered.should have_content("Social Network Client 2")
    rendered.should have_content("Social Network Client 3")
  end

end
