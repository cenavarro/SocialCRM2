require 'spec_helper'

describe "clients/show.html.slim" do
  before(:each) do
    @client = assign(:client, stub_model(Client,
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    pending

    render

    rendered.should match(/Name/)
  end
end
