require "spec_helper"

describe BlogDataController do
  describe "routing" do

    it "routes to #index" do
      get("/blog_data").should route_to("blog_data#index")
    end

    it "routes to #new" do
      get("/blog_data/new").should route_to("blog_data#new")
    end

    it "routes to #show" do
      get("/blog_data/1").should route_to("blog_data#show", :id => "1")
    end

    it "routes to #edit" do
      get("/blog_data/1/edit").should route_to("blog_data#edit", :id => "1")
    end

    it "routes to #create" do
      post("/blog_data").should route_to("blog_data#create")
    end

    it "routes to #update" do
      put("/blog_data/1").should route_to("blog_data#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/blog_data/1").should route_to("blog_data#destroy", :id => "1")
    end

  end
end
