require 'spec_helper'

describe GooglePlusDataController do

  def valid_attributes
    {}
  end

  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all google_plus_data as @google_plus_data" do
      google_plus_datum = GooglePlusDatum.create! valid_attributes
      get :index, {}, valid_session
      assigns(:google_plus_data).should eq([google_plus_datum])
    end
  end

  describe "GET show" do
    it "assigns the requested google_plus_datum as @google_plus_datum" do
      google_plus_datum = GooglePlusDatum.create! valid_attributes
      get :show, {:id => google_plus_datum.to_param}, valid_session
      assigns(:google_plus_datum).should eq(google_plus_datum)
    end
  end

  describe "GET new" do
    it "assigns a new google_plus_datum as @google_plus_datum" do
      get :new, {}, valid_session
      assigns(:google_plus_datum).should be_a_new(GooglePlusDatum)
    end
  end

  describe "GET edit" do
    it "assigns the requested google_plus_datum as @google_plus_datum" do
      google_plus_datum = GooglePlusDatum.create! valid_attributes
      get :edit, {:id => google_plus_datum.to_param}, valid_session
      assigns(:google_plus_datum).should eq(google_plus_datum)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new GooglePlusDatum" do
        expect {
          post :create, {:google_plus_datum => valid_attributes}, valid_session
        }.to change(GooglePlusDatum, :count).by(1)
      end

      it "assigns a newly created google_plus_datum as @google_plus_datum" do
        post :create, {:google_plus_datum => valid_attributes}, valid_session
        assigns(:google_plus_datum).should be_a(GooglePlusDatum)
        assigns(:google_plus_datum).should be_persisted
      end

      it "redirects to the created google_plus_datum" do
        post :create, {:google_plus_datum => valid_attributes}, valid_session
        response.should redirect_to(GooglePlusDatum.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved google_plus_datum as @google_plus_datum" do
        GooglePlusDatum.any_instance.stub(:save).and_return(false)
        post :create, {:google_plus_datum => {}}, valid_session
        assigns(:google_plus_datum).should be_a_new(GooglePlusDatum)
      end

      it "re-renders the 'new' template" do
        GooglePlusDatum.any_instance.stub(:save).and_return(false)
        post :create, {:google_plus_datum => {}}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested google_plus_datum" do
        google_plus_datum = GooglePlusDatum.create! valid_attributes
        GooglePlusDatum.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => google_plus_datum.to_param, :google_plus_datum => {'these' => 'params'}}, valid_session
      end

      it "assigns the requested google_plus_datum as @google_plus_datum" do
        google_plus_datum = GooglePlusDatum.create! valid_attributes
        put :update, {:id => google_plus_datum.to_param, :google_plus_datum => valid_attributes}, valid_session
        assigns(:google_plus_datum).should eq(google_plus_datum)
      end

      it "redirects to the google_plus_datum" do
        google_plus_datum = GooglePlusDatum.create! valid_attributes
        put :update, {:id => google_plus_datum.to_param, :google_plus_datum => valid_attributes}, valid_session
        response.should redirect_to(google_plus_datum)
      end
    end

    describe "with invalid params" do
      it "assigns the google_plus_datum as @google_plus_datum" do
        google_plus_datum = GooglePlusDatum.create! valid_attributes
        GooglePlusDatum.any_instance.stub(:save).and_return(false)
        put :update, {:id => google_plus_datum.to_param, :google_plus_datum => {}}, valid_session
        assigns(:google_plus_datum).should eq(google_plus_datum)
      end

      it "re-renders the 'edit' template" do
        google_plus_datum = GooglePlusDatum.create! valid_attributes
        GooglePlusDatum.any_instance.stub(:save).and_return(false)
        put :update, {:id => google_plus_datum.to_param, :google_plus_datum => {}}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested google_plus_datum" do
      google_plus_datum = GooglePlusDatum.create! valid_attributes
      expect {
        delete :destroy, {:id => google_plus_datum.to_param}, valid_session
      }.to change(GooglePlusDatum, :count).by(-1)
    end

    it "redirects to the google_plus_data list" do
      google_plus_datum = GooglePlusDatum.create! valid_attributes
      delete :destroy, {:id => google_plus_datum.to_param}, valid_session
      response.should redirect_to(google_plus_data_url)
    end
  end

end
