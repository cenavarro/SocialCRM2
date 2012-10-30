require 'spec_helper'

describe PinterestDataController do

  def valid_attributes
    {}
  end

  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all pinterest_data as @pinterest_data" do
      pinterest_datum = PinterestDatum.create! valid_attributes
      get :index, {}, valid_session
      assigns(:pinterest_data).should eq([pinterest_datum])
    end
  end

  describe "GET show" do
    it "assigns the requested pinterest_datum as @pinterest_datum" do
      pinterest_datum = PinterestDatum.create! valid_attributes
      get :show, {:id => pinterest_datum.to_param}, valid_session
      assigns(:pinterest_datum).should eq(pinterest_datum)
    end
  end

  describe "GET new" do
    it "assigns a new pinterest_datum as @pinterest_datum" do
      get :new, {}, valid_session
      assigns(:pinterest_datum).should be_a_new(PinterestDatum)
    end
  end

  describe "GET edit" do
    it "assigns the requested pinterest_datum as @pinterest_datum" do
      pinterest_datum = PinterestDatum.create! valid_attributes
      get :edit, {:id => pinterest_datum.to_param}, valid_session
      assigns(:pinterest_datum).should eq(pinterest_datum)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new PinterestDatum" do
        expect {
          post :create, {:pinterest_datum => valid_attributes}, valid_session
        }.to change(PinterestDatum, :count).by(1)
      end

      it "assigns a newly created pinterest_datum as @pinterest_datum" do
        post :create, {:pinterest_datum => valid_attributes}, valid_session
        assigns(:pinterest_datum).should be_a(PinterestDatum)
        assigns(:pinterest_datum).should be_persisted
      end

      it "redirects to the created pinterest_datum" do
        post :create, {:pinterest_datum => valid_attributes}, valid_session
        response.should redirect_to(PinterestDatum.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved pinterest_datum as @pinterest_datum" do
        PinterestDatum.any_instance.stub(:save).and_return(false)
        post :create, {:pinterest_datum => {}}, valid_session
        assigns(:pinterest_datum).should be_a_new(PinterestDatum)
      end

      it "re-renders the 'new' template" do
        PinterestDatum.any_instance.stub(:save).and_return(false)
        post :create, {:pinterest_datum => {}}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested pinterest_datum" do
        pinterest_datum = PinterestDatum.create! valid_attributes
        PinterestDatum.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => pinterest_datum.to_param, :pinterest_datum => {'these' => 'params'}}, valid_session
      end

      it "assigns the requested pinterest_datum as @pinterest_datum" do
        pinterest_datum = PinterestDatum.create! valid_attributes
        put :update, {:id => pinterest_datum.to_param, :pinterest_datum => valid_attributes}, valid_session
        assigns(:pinterest_datum).should eq(pinterest_datum)
      end

      it "redirects to the pinterest_datum" do
        pinterest_datum = PinterestDatum.create! valid_attributes
        put :update, {:id => pinterest_datum.to_param, :pinterest_datum => valid_attributes}, valid_session
        response.should redirect_to(pinterest_datum)
      end
    end

    describe "with invalid params" do
      it "assigns the pinterest_datum as @pinterest_datum" do
        pinterest_datum = PinterestDatum.create! valid_attributes
        PinterestDatum.any_instance.stub(:save).and_return(false)
        put :update, {:id => pinterest_datum.to_param, :pinterest_datum => {}}, valid_session
        assigns(:pinterest_datum).should eq(pinterest_datum)
      end

      it "re-renders the 'edit' template" do
        pinterest_datum = PinterestDatum.create! valid_attributes
        PinterestDatum.any_instance.stub(:save).and_return(false)
        put :update, {:id => pinterest_datum.to_param, :pinterest_datum => {}}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested pinterest_datum" do
      pinterest_datum = PinterestDatum.create! valid_attributes
      expect {
        delete :destroy, {:id => pinterest_datum.to_param}, valid_session
      }.to change(PinterestDatum, :count).by(-1)
    end

    it "redirects to the pinterest_data list" do
      pinterest_datum = PinterestDatum.create! valid_attributes
      delete :destroy, {:id => pinterest_datum.to_param}, valid_session
      response.should redirect_to(pinterest_data_url)
    end
  end

end
