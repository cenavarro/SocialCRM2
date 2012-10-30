require 'spec_helper'

describe TumblrDataController do

  def valid_attributes
    {}
  end

  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all tumblr_data as @tumblr_data" do
      tumblr_datum = TumblrDatum.create! valid_attributes
      get :index, {}, valid_session
      assigns(:tumblr_data).should eq([tumblr_datum])
    end
  end

  describe "GET show" do
    it "assigns the requested tumblr_datum as @tumblr_datum" do
      tumblr_datum = TumblrDatum.create! valid_attributes
      get :show, {:id => tumblr_datum.to_param}, valid_session
      assigns(:tumblr_datum).should eq(tumblr_datum)
    end
  end

  describe "GET new" do
    it "assigns a new tumblr_datum as @tumblr_datum" do
      get :new, {}, valid_session
      assigns(:tumblr_datum).should be_a_new(TumblrDatum)
    end
  end

  describe "GET edit" do
    it "assigns the requested tumblr_datum as @tumblr_datum" do
      tumblr_datum = TumblrDatum.create! valid_attributes
      get :edit, {:id => tumblr_datum.to_param}, valid_session
      assigns(:tumblr_datum).should eq(tumblr_datum)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new TumblrDatum" do
        expect {
          post :create, {:tumblr_datum => valid_attributes}, valid_session
        }.to change(TumblrDatum, :count).by(1)
      end

      it "assigns a newly created tumblr_datum as @tumblr_datum" do
        post :create, {:tumblr_datum => valid_attributes}, valid_session
        assigns(:tumblr_datum).should be_a(TumblrDatum)
        assigns(:tumblr_datum).should be_persisted
      end

      it "redirects to the created tumblr_datum" do
        post :create, {:tumblr_datum => valid_attributes}, valid_session
        response.should redirect_to(TumblrDatum.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved tumblr_datum as @tumblr_datum" do
        TumblrDatum.any_instance.stub(:save).and_return(false)
        post :create, {:tumblr_datum => {}}, valid_session
        assigns(:tumblr_datum).should be_a_new(TumblrDatum)
      end

      it "re-renders the 'new' template" do
        TumblrDatum.any_instance.stub(:save).and_return(false)
        post :create, {:tumblr_datum => {}}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested tumblr_datum" do
        tumblr_datum = TumblrDatum.create! valid_attributes
        TumblrDatum.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => tumblr_datum.to_param, :tumblr_datum => {'these' => 'params'}}, valid_session
      end

      it "assigns the requested tumblr_datum as @tumblr_datum" do
        tumblr_datum = TumblrDatum.create! valid_attributes
        put :update, {:id => tumblr_datum.to_param, :tumblr_datum => valid_attributes}, valid_session
        assigns(:tumblr_datum).should eq(tumblr_datum)
      end

      it "redirects to the tumblr_datum" do
        tumblr_datum = TumblrDatum.create! valid_attributes
        put :update, {:id => tumblr_datum.to_param, :tumblr_datum => valid_attributes}, valid_session
        response.should redirect_to(tumblr_datum)
      end
    end

    describe "with invalid params" do
      it "assigns the tumblr_datum as @tumblr_datum" do
        tumblr_datum = TumblrDatum.create! valid_attributes
        TumblrDatum.any_instance.stub(:save).and_return(false)
        put :update, {:id => tumblr_datum.to_param, :tumblr_datum => {}}, valid_session
        assigns(:tumblr_datum).should eq(tumblr_datum)
      end

      it "re-renders the 'edit' template" do
        tumblr_datum = TumblrDatum.create! valid_attributes
        TumblrDatum.any_instance.stub(:save).and_return(false)
        put :update, {:id => tumblr_datum.to_param, :tumblr_datum => {}}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested tumblr_datum" do
      tumblr_datum = TumblrDatum.create! valid_attributes
      expect {
        delete :destroy, {:id => tumblr_datum.to_param}, valid_session
      }.to change(TumblrDatum, :count).by(-1)
    end

    it "redirects to the tumblr_data list" do
      tumblr_datum = TumblrDatum.create! valid_attributes
      delete :destroy, {:id => tumblr_datum.to_param}, valid_session
      response.should redirect_to(tumblr_data_url)
    end
  end

end
