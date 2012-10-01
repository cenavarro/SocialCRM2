require "spec_helper"

describe GooglePlusDataController do
  describe "routing" do

    it "routes to #index" do
      get("/google_plus_data").should route_to("google_plus_data#index")
    end

    it "routes to #new" do
      get("/google_plus_data/new").should route_to("google_plus_data#new")
    end

    it "routes to #show" do
      get("/google_plus_data/1").should route_to("google_plus_data#show", :id => "1")
    end

    it "routes to #edit" do
      get("/google_plus_data/1/edit").should route_to("google_plus_data#edit", :id => "1")
    end

    it "routes to #create" do
      post("/google_plus_data").should route_to("google_plus_data#create")
    end

    it "routes to #update" do
      put("/google_plus_data/1").should route_to("google_plus_data#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/google_plus_data/1").should route_to("google_plus_data#destroy", :id => "1")
    end

  end
end
