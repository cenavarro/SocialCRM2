require "spec_helper"

describe FoursquareDataController do
  describe "routing" do

    it "routes to #index" do
      get("/foursquare_data").should route_to("foursquare_data#index")
    end

    it "routes to #new" do
      get("/foursquare_data/new").should route_to("foursquare_data#new")
    end

    it "routes to #show" do
      get("/foursquare_data/1").should route_to("foursquare_data#show", :id => "1")
    end

    it "routes to #edit" do
      get("/foursquare_data/1/edit").should route_to("foursquare_data#edit", :id => "1")
    end

    it "routes to #create" do
      post("/foursquare_data").should route_to("foursquare_data#create")
    end

    it "routes to #update" do
      put("/foursquare_data/1").should route_to("foursquare_data#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/foursquare_data/1").should route_to("foursquare_data#destroy", :id => "1")
    end

  end
end
