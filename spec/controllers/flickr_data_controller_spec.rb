require 'spec_helper'

describe FlickrDataController do

  before(:each) do
    @controller.stub(:authenticate_user!)
    @controller.stub(:has_admin_credentials?)
  end

  def valid_attributes
    { 
      :client_id => 1, :social_network_id => 1, :start_date => "01-01-2012", :end_date => "31-01-2012",
      :new_contacts => 100, :total_contacts => 200, :visits => 500, :comments => 150, :favorites => 30,
      :investment_agency => 150, :investment_actions => 120, :investment_ads => 100
    }
  end

  describe "#index" do
    it "assigns all flickr_data as @flickr_data" do
      flickr_datum = FlickrDatum.create! valid_attributes
      get :index, :locale => :es, :id_social => 1, :idc => 1, :opcion => 1
      assigns(:flickr_datum).should eq([flickr_datum])
    end

    it "assigns flickr_data as @flickr_data in a date range" do
      flickr_datum = FlickrDatum.create! valid_attributes
      get :index, :locale => :es, :id_social => 1, :idc => 1, :opcion => 2, :start_date => "01-01-2012", :end_date => "31-01-2012"
      assigns(:flickr_datum).should eq([flickr_datum])
    end

    it "assigns flickr as data for the charts" do
      FlickrDatum.create! valid_attributes
      get :index, :locale => :es, :id_social => 1, :idc => 1, :opcion => 1, :start_date => "01-01-2012", :end_date => "31-01-2012"
      assigns(:flickr).should eq({"new_contacts" => [100], "total_contacts" => [200], "visits" => [500], "comments" => [150], 
                                 "favorites" => [30], "dates" => ["01 Jan - 31 Jan"], "total_investment" => [370.0]})
    end
  end

  describe "#show" do
    it "assigns the requested flickr_datum as @flickr_datum" do
      flickr_datum = FlickrDatum.create! valid_attributes
      get :show, {:id => flickr_datum.to_param}, valid_session
      assigns(:flickr_datum).should eq(flickr_datum)
    end
  end

  describe "#new" do
    it "assigns a new flickr_datum as @flickr_datum" do
      get :new, {}, valid_session
      assigns(:flickr_datum).should be_a_new(FlickrDatum)
    end
  end

  describe "#edit" do
    it "assigns the requested flickr_datum as @flickr_datum" do
      flickr_datum = FlickrDatum.create! valid_attributes
      get :edit, {:id => flickr_datum.to_param}, valid_session
      assigns(:flickr_datum).should eq(flickr_datum)
    end
  end

  describe "#create" do
    describe "with valid params" do
      it "creates a new FlickrDatum" do
        expect {
          post :create, {:flickr_datum => valid_attributes}, valid_session
        }.to change(FlickrDatum, :count).by(1)
      end

      it "assigns a newly created flickr_datum as @flickr_datum" do
        post :create, {:flickr_datum => valid_attributes}, valid_session
        assigns(:flickr_datum).should be_a(FlickrDatum)
        assigns(:flickr_datum).should be_persisted
      end

      it "redirects to the created flickr_datum" do
        post :create, {:flickr_datum => valid_attributes}, valid_session
        response.should redirect_to(FlickrDatum.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved flickr_datum as @flickr_datum" do
        # Trigger the behavior that occurs when invalid params are submitted
        FlickrDatum.any_instance.stub(:save).and_return(false)
        post :create, {:flickr_datum => {}}, valid_session
        assigns(:flickr_datum).should be_a_new(FlickrDatum)
      end

      it "re-renders the 'new' template" do
        FlickrDatum.any_instance.stub(:save).and_return(false)
        post :create, {:flickr_datum => {}}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "#update" do
    describe "with valid params" do
      it "updates the requested flickr_datum" do
        flickr_datum = FlickrDatum.create! valid_attributes
        FlickrDatum.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => flickr_datum.to_param, :flickr_datum => {'these' => 'params'}}, valid_session
      end

      it "assigns the requested flickr_datum as @flickr_datum" do
        flickr_datum = FlickrDatum.create! valid_attributes
        put :update, {:id => flickr_datum.to_param, :flickr_datum => valid_attributes}, valid_session
        assigns(:flickr_datum).should eq(flickr_datum)
      end

      it "redirects to the flickr_datum" do
        flickr_datum = FlickrDatum.create! valid_attributes
        put :update, {:id => flickr_datum.to_param, :flickr_datum => valid_attributes}, valid_session
        response.should redirect_to(flickr_datum)
      end
    end

    describe "with invalid params" do
      it "assigns the flickr_datum as @flickr_datum" do
        flickr_datum = FlickrDatum.create! valid_attributes
        FlickrDatum.any_instance.stub(:save).and_return(false)
        put :update, {:id => flickr_datum.to_param, :flickr_datum => {}}, valid_session
        assigns(:flickr_datum).should eq(flickr_datum)
      end

      it "re-renders the 'edit' template" do
        flickr_datum = FlickrDatum.create! valid_attributes
        FlickrDatum.any_instance.stub(:save).and_return(false)
        put :update, {:id => flickr_datum.to_param, :flickr_datum => {}}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "#destroy" do
    it "destroys the requested flickr_datum" do
      flickr_datum = FlickrDatum.create! valid_attributes
      expect {
        delete :destroy, {:id => flickr_datum.to_param}, valid_session
      }.to change(FlickrDatum, :count).by(-1)
    end

    it "redirects to the flickr_data list" do
      flickr_datum = FlickrDatum.create! valid_attributes
      delete :destroy, {:id => flickr_datum.to_param}, valid_session
      response.should redirect_to(flickr_data_url)
    end
  end

end
