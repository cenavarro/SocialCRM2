require "spec_helper"

describe LinkedinDataController do
  describe "routing" do

    it "routes to #index" do
      get("/linkedin_data").should route_to("linkedin_data#index")
    end

    it "routes to #new" do
      get("/linkedin_data/new").should route_to("linkedin_data#new")
    end

    it "routes to #show" do
      get("/linkedin_data/1").should route_to("linkedin_data#show", :id => "1")
    end

    it "routes to #edit" do
      get("/linkedin_data/1/edit").should route_to("linkedin_data#edit", :id => "1")
    end

    it "routes to #create" do
      post("/linkedin_data").should route_to("linkedin_data#create")
    end

    it "routes to #update" do
      put("/linkedin_data/1").should route_to("linkedin_data#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/linkedin_data/1").should route_to("linkedin_data#destroy", :id => "1")
    end

  end
end
