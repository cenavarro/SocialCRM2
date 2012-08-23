require "spec_helper"

describe TwitterDataController do
  describe "routing" do

    it "routes to #index" do
      get("/twitter_data").should route_to("twitter_data#index")
    end

    it "routes to #new" do
      get("/twitter_data/new").should route_to("twitter_data#new")
    end

    it "routes to #show" do
      get("/twitter_data/1").should route_to("twitter_data#show", :id => "1")
    end

    it "routes to #edit" do
      get("/twitter_data/1/edit").should route_to("twitter_data#edit", :id => "1")
    end

    it "routes to #create" do
      post("/twitter_data").should route_to("twitter_data#create")
    end

    it "routes to #update" do
      put("/twitter_data/1").should route_to("twitter_data#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/twitter_data/1").should route_to("twitter_data#destroy", :id => "1")
    end

  end
end
