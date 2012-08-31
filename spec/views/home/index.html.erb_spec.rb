require 'spec_helper'

describe "home/index" do

  before(:each) do

    Client.new(:name => "Name 1", :description => "Description 1", :image => "logo1.png").save!
    Client.new(:name => "Name 2", :description => "Desctiption 2", :image => "logo2.png").save!

    assign(:clients, [ 
      stub_model(Client,
        :id => 1,
        :name => "Name 1",
        :description => "Desc 1",
        :image => "image1.png"
      ),
        stub_model(Client,
          :id => 2,
          :name => "Name 2",
          :description => "Desc 2",
          :image => "image2.png"
      )
    ])

  end
    

  describe "home/index.slim" do
    it "should have the content" do
      render
      rendered.should have_content("Pagina Principal")
    end
  end

end
