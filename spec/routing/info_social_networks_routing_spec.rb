require "spec_helper"

describe InfoSocialNetworksController do
  describe "routing" do

    it "routes to #index" do
      get("/info_social_networks").should route_to("info_social_networks#index")
    end

    it "routes to #new" do
      get("/info_social_networks/new").should route_to("info_social_networks#new")
    end

    it "routes to #show" do
      get("/info_social_networks/1").should route_to("info_social_networks#show", :id => "1")
    end

    it "routes to #edit" do
      get("/info_social_networks/1/edit").should route_to("info_social_networks#edit", :id => "1")
    end

    it "routes to #create" do
      post("/info_social_networks").should route_to("info_social_networks#create")
    end

    it "routes to #update" do
      put("/info_social_networks/1").should route_to("info_social_networks#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/info_social_networks/1").should route_to("info_social_networks#destroy", :id => "1")
    end

  end
end
