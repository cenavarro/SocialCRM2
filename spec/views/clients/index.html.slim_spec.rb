require 'spec_helper'

describe "clients/index.html.slim" do
  before(:each) do
    assign(:clients, [
      stub_model(Client,
        :name => "Name"
      ),
      stub_model(Client,
        :name => "Name"
      )
    ])
  end

  it "renders a list of clients" do
    pending

    render

    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
