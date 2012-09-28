require "spec_helper"

describe FlickrDataController do
  describe "routing" do

    it "routes to #index" do
      get("/flickr_data").should route_to("flickr_data#index")
    end

    it "routes to #new" do
      get("/flickr_data/new").should route_to("flickr_data#new")
    end

    it "routes to #show" do
      get("/flickr_data/1").should route_to("flickr_data#show", :id => "1")
    end

    it "routes to #edit" do
      get("/flickr_data/1/edit").should route_to("flickr_data#edit", :id => "1")
    end

    it "routes to #create" do
      post("/flickr_data").should route_to("flickr_data#create")
    end

    it "routes to #update" do
      put("/flickr_data/1").should route_to("flickr_data#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/flickr_data/1").should route_to("flickr_data#destroy", :id => "1")
    end

  end
end
