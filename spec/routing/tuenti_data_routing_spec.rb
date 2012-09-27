require "spec_helper"

describe TuentiDataController do
  describe "routing" do

    it "routes to #index" do
      get("/tuenti_data").should route_to("tuenti_data#index")
    end

    it "routes to #new" do
      get("/tuenti_data/new").should route_to("tuenti_data#new")
    end

    it "routes to #show" do
      get("/tuenti_data/1").should route_to("tuenti_data#show", :id => "1")
    end

    it "routes to #edit" do
      get("/tuenti_data/1/edit").should route_to("tuenti_data#edit", :id => "1")
    end

    it "routes to #create" do
      post("/tuenti_data").should route_to("tuenti_data#create")
    end

    it "routes to #update" do
      put("/tuenti_data/1").should route_to("tuenti_data#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/tuenti_data/1").should route_to("tuenti_data#destroy", :id => "1")
    end

  end
end
