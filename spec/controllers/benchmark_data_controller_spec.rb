require 'spec_helper'

describe BenchmarkDataController do

  before(:each) do
    @controller.stub(:authenticate_user!)
    @controller.stub(:has_admin_credentials?)
  end

  def valid_attributes_datum
    {start_date: "01-01-2010".to_date, end_date: "01-02-2010", blogs: 1, forums: 2, videos: 3, twitter: 4, facebook: 5, others: 6, benchmark_competitor_id: 1}
  end

  def valid_attributes_competitor
    {social_network_id: 1, name: "Competitor 1"}
  end

  describe "#index" do
    it "assigns all benchmark_competitors as @benchmark_competitors" do
      benchmark_competitor = BenchmarkCompetitor.create! valid_attributes_competitor
      competitor_data = BenchmarkDatum.create! valid_attributes_datum
      get :index, :locale => :es, :opcion => 1, :idc => 1, :id_social => 1
      assigns(:benchmark)["Competitor 1"].should eq([1,2,3,4,5,6])
    end
  end

  describe "#new" do
    it "assigns a new benchmark_competitors as @benchmark_competitors" do
      benchmark_competitor = BenchmarkCompetitor.create! valid_attributes_competitor
      get :new, :locale => :es, :opcion => 1, :idc => 1, :id_social => 1
      assigns(:benchmark_competitors).should eq([benchmark_competitor])
    end
  end

  describe "#edit" do
    it "assigns the requested benchmark_competitors as @benchmark_competitors and set the values of @start_date and @end_date" do
      benchmark_datum = BenchmarkDatum.create! valid_attributes_datum
      benchmark_competitor = BenchmarkCompetitor.create! valid_attributes_competitor
      get :edit, :id => benchmark_datum.id, locale: :es, opcion: 1, idc: 1, id_social: 1
      assigns(:benchmark_competitors).should eq([benchmark_competitor])
      assigns(:start_date).should eq(benchmark_datum.start_date.strftime("%d-%m-%Y"))
      assigns(:end_date).should eq(benchmark_datum.end_date.strftime("%d-%m-%Y"))
    end
  end

  describe "#create" do
    it "creates a new BenchmarkDatum to a competitor" do
      benchmark_competitor = BenchmarkCompetitor.create! valid_attributes_competitor
      expect {
        post :create, locale: :es, :social_network_id => 1, :client_id => 1, "1".to_sym => { start_date: "01-03-2012", end_date: "01-04-2012", blogs: 3, forums: 4, videos: 5, twitter: 6, facebook: 7, others: 8, benchmark_competitor_id: 1}, :start_date => "01-01-2012", :end_date => "01-02-2012"
      }.to change(BenchmarkDatum, :count).by(1)
    end

    it "redirects to the Benchmark Index page of a Client" do
      post :create, locale: :es, :social_network_id => 1, :client_id => 1, "1".to_sym => { start_date: "01-03-2012", end_date: "01-04-2012", blogs: 3, forums: 4, videos: 5, twitter: 6, facebook: 7, others: 8, benchmark_competitor_id: 1}, :start_date => "01-01-2012", :end_date => "01-02-2012"
      response.should redirect_to(benchmark_index_path(1, 1, 1))
    end
  end

  describe "#update" do
    it "updates the requested benchmark_datum of a BenchmarkCompetitor" do
      benchmark_competitor = BenchmarkCompetitor.create! valid_attributes_competitor
      benchmark_datum = BenchmarkDatum.create! valid_attributes_datum
      put :update, :id => 1, :locale => :es, :social_network_id => 1, :client_id => 1, "1".to_sym => { start_date: "01-03-2012", end_date: "01-04-2012", blogs: 3, forums: 4, videos: 5, twitter: 6, facebook: 7, others: 8, benchmark_competitor_id: 1}, :start_date => "01-01-2010", :end_date => "01-02-2010"
      benchmark_datum = BenchmarkDatum.find(benchmark_datum.id)
      benchmark_datum.start_date.should eq("01-01-2010".to_date)
      benchmark_datum.end_date.should eq("01-02-2010".to_date)
    end

    it "redirects to the Benchmark Index Page" do
      benchmark_competitor = BenchmarkCompetitor.create! valid_attributes_competitor
      benchmark_datum = BenchmarkDatum.create! valid_attributes_datum
      put :update, :id => 1, :locale => :es, :social_network_id => 1, :client_id => 1, "1".to_sym => { start_date: "01-03-2012", end_date: "01-04-2012", blogs: 3, forums: 4, videos: 5, twitter: 6, facebook: 7, others: 8, benchmark_competitor_id: 1}, :start_date => "01-01-2010", :end_date => "01-02-2010"
      response.should redirect_to(benchmark_index_path(1, 1, 1))
    end
  end

  describe "#destroy" do
    it "destroys the benchmark_datum of a BenchmarkCompetitor for a specific date" do
      SocialNetwork.create!({:name => "Test SN", :client_id => 1, :info_social_network_id => 1})
      benchmark_competitor = BenchmarkCompetitor.create! valid_attributes_competitor
      benchmark_datum = BenchmarkDatum.create! valid_attributes_datum
      expect {
        delete :destroy, :locale => :es, :id => benchmark_datum.to_param
      }.to change(BenchmarkDatum, :count).by(-1)
    end

    it "redirects to the Benchmark Index Page" do
      SocialNetwork.create!({:name => "Test SN", :client_id => 1, :info_social_network_id => 1})
      benchmark_competitor = BenchmarkCompetitor.create! valid_attributes_competitor
      benchmark_datum = BenchmarkDatum.create! valid_attributes_datum
      delete :destroy, :locale => :es, :id => benchmark_datum.to_param
      response.should redirect_to(benchmark_index_path(1, 1, 1))
    end
  end

end
