require "spec_helper"

describe YoutubeDataController do
  describe "routing" do

    it "routes to #index" do
      get("/youtube_data").should route_to("youtube_data#index")
    end

    it "routes to #new" do
      get("/youtube_data/new").should route_to("youtube_data#new")
    end

    it "routes to #show" do
      get("/youtube_data/1").should route_to("youtube_data#show", :id => "1")
    end

    it "routes to #edit" do
      get("/youtube_data/1/edit").should route_to("youtube_data#edit", :id => "1")
    end

    it "routes to #create" do
      post("/youtube_data").should route_to("youtube_data#create")
    end

    it "routes to #update" do
      put("/youtube_data/1").should route_to("youtube_data#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/youtube_data/1").should route_to("youtube_data#destroy", :id => "1")
    end

  end
end
