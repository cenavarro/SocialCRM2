require 'spec_helper'

describe TuentiDataController do

  def valid_attributes
    {}
  end

  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all tuenti_data as @tuenti_data" do
      tuenti_datum = TuentiDatum.create! valid_attributes
      get :index, {}, valid_session
      assigns(:tuenti_data).should eq([tuenti_datum])
    end
  end

  describe "GET show" do
    it "assigns the requested tuenti_datum as @tuenti_datum" do
      tuenti_datum = TuentiDatum.create! valid_attributes
      get :show, {:id => tuenti_datum.to_param}, valid_session
      assigns(:tuenti_datum).should eq(tuenti_datum)
    end
  end

  describe "GET new" do
    it "assigns a new tuenti_datum as @tuenti_datum" do
      get :new, {}, valid_session
      assigns(:tuenti_datum).should be_a_new(TuentiDatum)
    end
  end

  describe "GET edit" do
    it "assigns the requested tuenti_datum as @tuenti_datum" do
      tuenti_datum = TuentiDatum.create! valid_attributes
      get :edit, {:id => tuenti_datum.to_param}, valid_session
      assigns(:tuenti_datum).should eq(tuenti_datum)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new TuentiDatum" do
        expect {
          post :create, {:tuenti_datum => valid_attributes}, valid_session
        }.to change(TuentiDatum, :count).by(1)
      end

      it "assigns a newly created tuenti_datum as @tuenti_datum" do
        post :create, {:tuenti_datum => valid_attributes}, valid_session
        assigns(:tuenti_datum).should be_a(TuentiDatum)
        assigns(:tuenti_datum).should be_persisted
      end

      it "redirects to the created tuenti_datum" do
        post :create, {:tuenti_datum => valid_attributes}, valid_session
        response.should redirect_to(TuentiDatum.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved tuenti_datum as @tuenti_datum" do
        TuentiDatum.any_instance.stub(:save).and_return(false)
        post :create, {:tuenti_datum => {}}, valid_session
        assigns(:tuenti_datum).should be_a_new(TuentiDatum)
      end

      it "re-renders the 'new' template" do
        TuentiDatum.any_instance.stub(:save).and_return(false)
        post :create, {:tuenti_datum => {}}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested tuenti_datum" do
        tuenti_datum = TuentiDatum.create! valid_attributes
        TuentiDatum.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => tuenti_datum.to_param, :tuenti_datum => {'these' => 'params'}}, valid_session
      end

      it "assigns the requested tuenti_datum as @tuenti_datum" do
        tuenti_datum = TuentiDatum.create! valid_attributes
        put :update, {:id => tuenti_datum.to_param, :tuenti_datum => valid_attributes}, valid_session
        assigns(:tuenti_datum).should eq(tuenti_datum)
      end

      it "redirects to the tuenti_datum" do
        tuenti_datum = TuentiDatum.create! valid_attributes
        put :update, {:id => tuenti_datum.to_param, :tuenti_datum => valid_attributes}, valid_session
        response.should redirect_to(tuenti_datum)
      end
    end

    describe "with invalid params" do
      it "assigns the tuenti_datum as @tuenti_datum" do
        tuenti_datum = TuentiDatum.create! valid_attributes
        TuentiDatum.any_instance.stub(:save).and_return(false)
        put :update, {:id => tuenti_datum.to_param, :tuenti_datum => {}}, valid_session
        assigns(:tuenti_datum).should eq(tuenti_datum)
      end

      it "re-renders the 'edit' template" do
        tuenti_datum = TuentiDatum.create! valid_attributes
        TuentiDatum.any_instance.stub(:save).and_return(false)
        put :update, {:id => tuenti_datum.to_param, :tuenti_datum => {}}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested tuenti_datum" do
      tuenti_datum = TuentiDatum.create! valid_attributes
      expect {
        delete :destroy, {:id => tuenti_datum.to_param}, valid_session
      }.to change(TuentiDatum, :count).by(-1)
    end

    it "redirects to the tuenti_data list" do
      tuenti_datum = TuentiDatum.create! valid_attributes
      delete :destroy, {:id => tuenti_datum.to_param}, valid_session
      response.should redirect_to(tuenti_data_url)
    end
  end

end
