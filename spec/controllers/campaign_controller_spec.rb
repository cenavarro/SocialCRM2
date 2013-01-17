require 'spec_helper'

describe CampaignDataController do

  before(:each) do
    @controller.stub(:authenticate_user!)
    @controller.stub(:has_admin_credentials?)
    create_test_data
  end

  def attributes_row_data_1
    {:start_date => "01-01-2012", :end_date => "15-01-2012", :value => 5, :rows_campaign_id => 1}
  end

  def attributes_row_data_2
    {:start_date => "01-01-2012", :end_date => "15-01-2012", :value => 10, :rows_campaign_id => 2}
  end

  def attributes_rows_campaign_1
    {:name => "Criterio 1", :social_network_id => 1}
  end

  def attributes_rows_campaign_2
    {:name => "Criterio 2", :social_network_id => 1}
  end

  def create_test_data
    RowsCampaign.create! attributes_rows_campaign_1
    RowsCampaign.create! attributes_rows_campaign_2
    RowDatum.create! attributes_row_data_1
    RowDatum.create! attributes_row_data_2
  end


  describe "#index" do
    it "assigns all rows_campaign as @rows_campaign for a specific Campaign" do
      rows_campaign = RowsCampaign.where('social_network_id = ?', 1)
      get :index, :locale => :es, :idc => 1, :opcion => 1, :id_social => 1
      assigns(:campaign_data).should eq({"dates"=>["01 Jan - 15 Jan"], "data"=>[{"Criterio 1"=>[5]}, {"Criterio 2"=>[10]}], "ids"=>[2]})
    end
  end

  describe "#new" do
    it "assign all rows_campaign as @rows_campaign for a new data entry" do
      rows_campaign = RowsCampaign.where('social_network_id = ?', 1)
      get :new, :locale => :es, :idc => 1, :opcion => 1, :id_social => 1
      assigns(:rows_campaign).should eq(rows_campaign)
    end
  end

  describe "#edit" do
    it "assigns the requested rows_campaign as @rows_campaing and row as @row" do
      rows_campaign = RowsCampaign.where('social_network_id = ?', 1)
      row_data = RowDatum.find(1)
      get :edit, :locale => :es, :id => 1, :idc => 1, :id_social => 1
      assigns(:rows_campaign).should eq(rows_campaign)
      assigns(:row).should eq(row_data)
    end
  end

  describe "#create" do
    it "create a RowDatum for a specific campaign" do
      expect{
        post :create, :locale => :es, :idc => 1, :id_social => 1, :start_date => "16-01-2012", :end_date => "31-01-2012", :criteria_1 => 100, :criteria_2 => 200
      }.to change(RowDatum, :count).by(2)
    end
  end

  describe "#update" do
    it "updates the data of a specific campaign" do
      post :update, :idc => 1, :id_social => 1, :locale => :es, :start_date => "01-02-2012", :end_date => "15-02-2012", :criteria_1 => 300, :criteria_2 => 400
      datum = RowDatum.find(1)
      datum.value.should eq(300)
      datum = RowDatum.find(2)
      datum.value.should eq(400)
    end

    it "redirects to the index Campaign page of Client" do
      post :update, :idc => 1, :id_social => 1, :locale => :es, :start_date => "01-02-2012", :end_date => "15-02-2012", :criteria_1 => 300, :criteria_2 => 400
      response.should redirect_to(campaign_index_path(1,1,1))
    end
  end

  describe "#destroy" do
    it "destroys all the campaign data for a Campaign" do
      expect{
        delete :destroy, :locale => :es, :idc => 1, :id_social => 1, :id => 1
      }.to change(RowDatum, :count).by(-2)
    end

    it "redirects to the index Campaign page of Client" do
      delete :destroy, :locale => :es, :idc => 1, :id_social => 1, :id => 1
      response.should redirect_to(campaign_index_path(1,1,1))
    end
  end

end
