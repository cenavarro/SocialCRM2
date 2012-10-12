require "spec_helper"

describe BenchmarkDataController do
  describe "routing" do

    it "routes to #index" do
      get("/benchmark_data").should route_to("benchmark_data#index")
    end

    it "routes to #new" do
      get("/benchmark_data/new").should route_to("benchmark_data#new")
    end

    it "routes to #show" do
      get("/benchmark_data/1").should route_to("benchmark_data#show", :id => "1")
    end

    it "routes to #edit" do
      get("/benchmark_data/1/edit").should route_to("benchmark_data#edit", :id => "1")
    end

    it "routes to #create" do
      post("/benchmark_data").should route_to("benchmark_data#create")
    end

    it "routes to #update" do
      put("/benchmark_data/1").should route_to("benchmark_data#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/benchmark_data/1").should route_to("benchmark_data#destroy", :id => "1")
    end

  end
end
