require 'spec_helper'

describe "BlogData" do
  describe "GET /blog_data" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get blog_data_path
      response.status.should be(200)
    end
  end
end
