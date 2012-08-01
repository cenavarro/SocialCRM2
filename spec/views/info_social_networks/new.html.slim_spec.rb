require 'spec_helper'

describe "info_social_networks/new.html.slim" do
  before(:each) do
    assign(:info_social_network, stub_model(InfoSocialNetwork,
      :name => "MyString",
      :description => "MyText",
      :image => "MyString"
    ).as_new_record)
  end

  it "renders new info_social_network form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => info_social_networks_path, :method => "post" do
      assert_select "input#info_social_network_name", :name => "info_social_network[name]"
      assert_select "textarea#info_social_network_description", :name => "info_social_network[description]"
      assert_select "input#info_social_network_image", :name => "info_social_network[image]"
    end
  end
end
