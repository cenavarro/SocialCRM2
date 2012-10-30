require 'spec_helper'

describe FoursquareDataController do

  def valid_attributes
    {}
  end

  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all foursquare_data as @foursquare_data" do
      foursquare_datum = FoursquareDatum.create! valid_attributes
      get :index, {}, valid_session
      assigns(:foursquare_data).should eq([foursquare_datum])
    end
  end

  describe "GET show" do
    it "assigns the requested foursquare_datum as @foursquare_datum" do
      foursquare_datum = FoursquareDatum.create! valid_attributes
      get :show, {:id => foursquare_datum.to_param}, valid_session
      assigns(:foursquare_datum).should eq(foursquare_datum)
    end
  end

  describe "GET new" do
    it "assigns a new foursquare_datum as @foursquare_datum" do
      get :new, {}, valid_session
      assigns(:foursquare_datum).should be_a_new(FoursquareDatum)
    end
  end

  describe "GET edit" do
    it "assigns the requested foursquare_datum as @foursquare_datum" do
      foursquare_datum = FoursquareDatum.create! valid_attributes
      get :edit, {:id => foursquare_datum.to_param}, valid_session
      assigns(:foursquare_datum).should eq(foursquare_datum)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new FoursquareDatum" do
        expect {
          post :create, {:foursquare_datum => valid_attributes}, valid_session
        }.to change(FoursquareDatum, :count).by(1)
      end

      it "assigns a newly created foursquare_datum as @foursquare_datum" do
        post :create, {:foursquare_datum => valid_attributes}, valid_session
        assigns(:foursquare_datum).should be_a(FoursquareDatum)
        assigns(:foursquare_datum).should be_persisted
      end

      it "redirects to the created foursquare_datum" do
        post :create, {:foursquare_datum => valid_attributes}, valid_session
        response.should redirect_to(FoursquareDatum.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved foursquare_datum as @foursquare_datum" do
        FoursquareDatum.any_instance.stub(:save).and_return(false)
        post :create, {:foursquare_datum => {}}, valid_session
        assigns(:foursquare_datum).should be_a_new(FoursquareDatum)
      end

      it "re-renders the 'new' template" do
        FoursquareDatum.any_instance.stub(:save).and_return(false)
        post :create, {:foursquare_datum => {}}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested foursquare_datum" do
        foursquare_datum = FoursquareDatum.create! valid_attributes
        FoursquareDatum.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => foursquare_datum.to_param, :foursquare_datum => {'these' => 'params'}}, valid_session
      end

      it "assigns the requested foursquare_datum as @foursquare_datum" do
        foursquare_datum = FoursquareDatum.create! valid_attributes
        put :update, {:id => foursquare_datum.to_param, :foursquare_datum => valid_attributes}, valid_session
        assigns(:foursquare_datum).should eq(foursquare_datum)
      end

      it "redirects to the foursquare_datum" do
        foursquare_datum = FoursquareDatum.create! valid_attributes
        put :update, {:id => foursquare_datum.to_param, :foursquare_datum => valid_attributes}, valid_session
        response.should redirect_to(foursquare_datum)
      end
    end

    describe "with invalid params" do
      it "assigns the foursquare_datum as @foursquare_datum" do
        foursquare_datum = FoursquareDatum.create! valid_attributes
        FoursquareDatum.any_instance.stub(:save).and_return(false)
        put :update, {:id => foursquare_datum.to_param, :foursquare_datum => {}}, valid_session
        assigns(:foursquare_datum).should eq(foursquare_datum)
      end

      it "re-renders the 'edit' template" do
        foursquare_datum = FoursquareDatum.create! valid_attributes
        FoursquareDatum.any_instance.stub(:save).and_return(false)
        put :update, {:id => foursquare_datum.to_param, :foursquare_datum => {}}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested foursquare_datum" do
      foursquare_datum = FoursquareDatum.create! valid_attributes
      expect {
        delete :destroy, {:id => foursquare_datum.to_param}, valid_session
      }.to change(FoursquareDatum, :count).by(-1)
    end

    it "redirects to the foursquare_data list" do
      foursquare_datum = FoursquareDatum.create! valid_attributes
      delete :destroy, {:id => foursquare_datum.to_param}, valid_session
      response.should redirect_to(foursquare_data_url)
    end
  end

end
