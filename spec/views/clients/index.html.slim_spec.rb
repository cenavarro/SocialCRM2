require 'spec_helper'

describe "clients/index.html.slim" do
  before(:each) do
    assign(:clients, [
      stub_model(Client,
        :name => "Name",
        :description => "Description",
        :image => "logo1.png"
      ),
      stub_model(Client,
        :name => "Name2",
        :description => "Description2",
        :image => "logo2.png"
      )
    ])
  end

  it "renders a list of clients" do
    

    render

    assert_select "tr>td", :text => "Name".to_s, :count => 1
    assert_select "tr>td", :text => "Name2".to_s, :count => 1
    assert_select "tr>td", :text => "Description".to_s, :count => 1
    assert_select "tr>td", :text => "Description2".to_s, :count => 1
  end
end
