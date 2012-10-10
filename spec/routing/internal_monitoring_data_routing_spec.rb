require "spec_helper"

describe InternalMonitoringDataController do
  describe "routing" do

    it "routes to #index" do
      get("/internal_monitoring_data").should route_to("internal_monitoring_data#index")
    end

    it "routes to #new" do
      get("/internal_monitoring_data/new").should route_to("internal_monitoring_data#new")
    end

    it "routes to #show" do
      get("/internal_monitoring_data/1").should route_to("internal_monitoring_data#show", :id => "1")
    end

    it "routes to #edit" do
      get("/internal_monitoring_data/1/edit").should route_to("internal_monitoring_data#edit", :id => "1")
    end

    it "routes to #create" do
      post("/internal_monitoring_data").should route_to("internal_monitoring_data#create")
    end

    it "routes to #update" do
      put("/internal_monitoring_data/1").should route_to("internal_monitoring_data#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/internal_monitoring_data/1").should route_to("internal_monitoring_data#destroy", :id => "1")
    end

  end
end
