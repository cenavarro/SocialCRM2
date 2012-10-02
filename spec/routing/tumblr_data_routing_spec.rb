require "spec_helper"

describe TumblrDataController do
  describe "routing" do

    it "routes to #index" do
      get("/tumblr_data").should route_to("tumblr_data#index")
    end

    it "routes to #new" do
      get("/tumblr_data/new").should route_to("tumblr_data#new")
    end

    it "routes to #show" do
      get("/tumblr_data/1").should route_to("tumblr_data#show", :id => "1")
    end

    it "routes to #edit" do
      get("/tumblr_data/1/edit").should route_to("tumblr_data#edit", :id => "1")
    end

    it "routes to #create" do
      post("/tumblr_data").should route_to("tumblr_data#create")
    end

    it "routes to #update" do
      put("/tumblr_data/1").should route_to("tumblr_data#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/tumblr_data/1").should route_to("tumblr_data#destroy", :id => "1")
    end

  end
end
