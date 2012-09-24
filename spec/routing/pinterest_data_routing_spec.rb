require "spec_helper"

describe PinterestDataController do
  describe "routing" do

    it "routes to #index" do
      get("/pinterest_data").should route_to("pinterest_data#index")
    end

    it "routes to #new" do
      get("/pinterest_data/new").should route_to("pinterest_data#new")
    end

    it "routes to #show" do
      get("/pinterest_data/1").should route_to("pinterest_data#show", :id => "1")
    end

    it "routes to #edit" do
      get("/pinterest_data/1/edit").should route_to("pinterest_data#edit", :id => "1")
    end

    it "routes to #create" do
      post("/pinterest_data").should route_to("pinterest_data#create")
    end

    it "routes to #update" do
      put("/pinterest_data/1").should route_to("pinterest_data#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/pinterest_data/1").should route_to("pinterest_data#destroy", :id => "1")
    end

  end
end
