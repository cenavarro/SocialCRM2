require 'spec_helper'

describe FacebookDataController do
  before(:each) do
    @controller.stub(:authenticate_user!)
  end

  def valid_attributes
    {
      :client_id => 1,
      :start_date => "2012/08/1".to_date,
      :end_date => "2012/08/15".to_date,
      :actions => "Test Action",
      :new_fans => 10,
      :total_fans => 10,
      :goal_fans => 10,
      :prints => 100,
      :total_interactions => 100,
      :total_reach => 100,
      :potential_reach => 100,
      :total_prints_per_anno => 100,
      :total_prints => 100,
      :total_clicks_anno => 100,
      :fans_through_anno => 20,
      :agency_investment => 137.5,
      :new_stock_investment => 1500.0,
      :anno_investment => 2200.5,
      :ctr_anno => 0.096,
      :cpm_anno => 0.09,
      :cpc_anno => 0.1,
    }
  end

  def valid_attributes2
    {
      :client_id => 1,
      :start_date => "2012/08/16".to_date,
      :end_date => "2012/08/30".to_date,
      :actions => "Test Action 2",
      :new_fans => 20,
      :total_fans => 20,
      :goal_fans => 20,
      :prints => 200,
      :total_interactions => 200,
      :total_reach => 200,
      :potential_reach => 200,
      :total_prints_per_anno => 200,
      :total_prints => 200,
      :total_clicks_anno => 200,
      :fans_through_anno => 30,
      :agency_investment => 140.5,
      :new_stock_investment => 1600.0,
      :anno_investment => 2300.5,
      :ctr_anno => 0.097,
      :cpm_anno => 0.08,
      :cpc_anno => 0.2,
    }
  end

  describe "# index" do
    it "assigns @facebook_data has the correct data" do
      FacebookDatum.create! valid_attributes2
      FacebookDatum.create! valid_attributes
      facebook_datum = FacebookDatum.find(:all, :order => "start_date ASC")
      get :index, :idc => 1
      assigns(:facebook_data).should eq(facebook_datum)
    end

    it "gets @facebook_data in a date range" do
      facebook_data = FacebookDatum.create! valid_attributes
      get :index, :idc => facebook_data.client_id, :opcion => 2, :ff => {"ff(1i)" => 2012, "ff(2i)" => 8, "ff(3i)" => 15},:fi => {"fi(3i)"=> 1, "fi(2i)"=> 8, "fi(1i)"=> 2012}
      assigns(:facebook_data).should eq([facebook_data])
    end

    it "redirects if try access without id client in the path" do
      get :index
      response.should be_redirect
    end
  end

  describe "# new" do
    it "assigns a new facebook_datum as @facebook_datum" do
      get :new, :idc => 1, :opcion => 2

      assigns(:facebook_datum).should be_a_new(FacebookDatum)
    end
  end

  describe "# edit" do
    it "assigns the requested facebook_datum as @facebook_datum" do
      facebook_datum = FacebookDatum.create! valid_attributes
      get :edit, :id => facebook_datum.id.to_s
      assigns(:facebook_datum).should eq(facebook_datum)
    end
  end

  describe "# create" do
    context "with valid params" do
      it "creates a new FacebookDatum" do
        expect {
          post :create, :facebook_datum => valid_attributes
          post :create, :facebook_datum => valid_attributes2
        }.to change(FacebookDatum, :count).by(2)
      end

      it "assigns a newly created facebook_datum as @facebook_datum" do
        post :create, :facebook_datum => valid_attributes
        assigns(:facebook_datum).should be_a(FacebookDatum)
        assigns(:facebook_datum).should be_persisted
      end

      it "redirects to the created facebook_datum" do
        post :create, :facebook_datum => valid_attributes
        response.should redirect_to(%{/facebook_data/#{FacebookDatum.last.client_id}/1})
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved facebook_datum as @facebook_datum" do
        FacebookDatum.any_instance.stub(:save).and_return(false)
        post :create, :facebook_datum => {}
        assigns(:facebook_datum).should be_a_new(FacebookDatum)
      end

      it "re-renders the 'new' template" do
        FacebookDatum.any_instance.stub(:save).and_return(false)
        post :create, :facebook_datum => {}
        response.should render_template("new")
      end
    end
  end

  describe "# update" do
    context "with valid params" do
      it "updates the requested facebook_datum" do
        FacebookDatum.create! valid_attributes2
        facebook_datum = FacebookDatum.create! valid_attributes
        FacebookDatum.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => facebook_datum.id, :facebook_datum => {'these' => 'params'}
      end

      it "assigns the requested facebook_datum as @facebook_datum" do
        facebook_datum = FacebookDatum.create! valid_attributes
        put :update, :id => facebook_datum.id, :facebook_datum => valid_attributes
        assigns(:facebook_datum).should eq(facebook_datum)
      end

      it "redirects to the facebook_datum" do
        facebook_datum = FacebookDatum.create! valid_attributes
        put :update, :id => facebook_datum.id, :facebook_datum => valid_attributes
        response.should redirect_to(%{/facebook_data/#{facebook_datum.client_id}/1})
      end
    end

    context "with invalid params" do
      it "assigns the facebook_datum as @facebook_datum" do
        facebook_datum = FacebookDatum.create! valid_attributes
        FacebookDatum.any_instance.stub(:save).and_return(false)
        put :update, :id => facebook_datum.id.to_s, :facebook_datum => {}
        assigns(:facebook_datum).should eq(facebook_datum)
      end

      it "re-renders the 'edit' template" do
        facebook_datum = FacebookDatum.create! valid_attributes
        FacebookDatum.any_instance.stub(:save).and_return(false)
        put :update, :id => facebook_datum.id.to_s, :facebook_datum => {}
        response.should render_template("edit")
      end
    end
  end

  describe "# destroy" do
    it "destroys the requested facebook_datum" do
      facebook_datum = FacebookDatum.create! valid_attributes
      expect {
        delete :destroy, :id => facebook_datum.id.to_s
      }.to change(FacebookDatum, :count).by(-1)
    end

    it "redirects to the facebook_data list" do
      facebook_datum = FacebookDatum.create! valid_attributes
      delete :destroy, :id => facebook_datum.id.to_s
      response.should redirect_to(%{/facebook_data/#{facebook_datum.client_id}/1})
    end
  end

end
