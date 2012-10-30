require 'spec_helper'

describe LinkedinDataController do

  def valid_attributes
    {}
  end

  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all linkedin_data as @linkedin_data" do
      linkedin_datum = LinkedinDatum.create! valid_attributes
      get :index, {}, valid_session
      assigns(:linkedin_data).should eq([linkedin_datum])
    end
  end

  describe "GET show" do
    it "assigns the requested linkedin_datum as @linkedin_datum" do
      linkedin_datum = LinkedinDatum.create! valid_attributes
      get :show, {:id => linkedin_datum.to_param}, valid_session
      assigns(:linkedin_datum).should eq(linkedin_datum)
    end
  end

  describe "GET new" do
    it "assigns a new linkedin_datum as @linkedin_datum" do
      get :new, {}, valid_session
      assigns(:linkedin_datum).should be_a_new(LinkedinDatum)
    end
  end

  describe "GET edit" do
    it "assigns the requested linkedin_datum as @linkedin_datum" do
      linkedin_datum = LinkedinDatum.create! valid_attributes
      get :edit, {:id => linkedin_datum.to_param}, valid_session
      assigns(:linkedin_datum).should eq(linkedin_datum)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new LinkedinDatum" do
        expect {
          post :create, {:linkedin_datum => valid_attributes}, valid_session
        }.to change(LinkedinDatum, :count).by(1)
      end

      it "assigns a newly created linkedin_datum as @linkedin_datum" do
        post :create, {:linkedin_datum => valid_attributes}, valid_session
        assigns(:linkedin_datum).should be_a(LinkedinDatum)
        assigns(:linkedin_datum).should be_persisted
      end

      it "redirects to the created linkedin_datum" do
        post :create, {:linkedin_datum => valid_attributes}, valid_session
        response.should redirect_to(LinkedinDatum.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved linkedin_datum as @linkedin_datum" do
        LinkedinDatum.any_instance.stub(:save).and_return(false)
        post :create, {:linkedin_datum => {}}, valid_session
        assigns(:linkedin_datum).should be_a_new(LinkedinDatum)
      end

      it "re-renders the 'new' template" do
        LinkedinDatum.any_instance.stub(:save).and_return(false)
        post :create, {:linkedin_datum => {}}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested linkedin_datum" do
        linkedin_datum = LinkedinDatum.create! valid_attributes
        LinkedinDatum.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => linkedin_datum.to_param, :linkedin_datum => {'these' => 'params'}}, valid_session
      end

      it "assigns the requested linkedin_datum as @linkedin_datum" do
        linkedin_datum = LinkedinDatum.create! valid_attributes
        put :update, {:id => linkedin_datum.to_param, :linkedin_datum => valid_attributes}, valid_session
        assigns(:linkedin_datum).should eq(linkedin_datum)
      end

      it "redirects to the linkedin_datum" do
        linkedin_datum = LinkedinDatum.create! valid_attributes
        put :update, {:id => linkedin_datum.to_param, :linkedin_datum => valid_attributes}, valid_session
        response.should redirect_to(linkedin_datum)
      end
    end

    describe "with invalid params" do
      it "assigns the linkedin_datum as @linkedin_datum" do
        linkedin_datum = LinkedinDatum.create! valid_attributes
        LinkedinDatum.any_instance.stub(:save).and_return(false)
        put :update, {:id => linkedin_datum.to_param, :linkedin_datum => {}}, valid_session
        assigns(:linkedin_datum).should eq(linkedin_datum)
      end

      it "re-renders the 'edit' template" do
        linkedin_datum = LinkedinDatum.create! valid_attributes
        LinkedinDatum.any_instance.stub(:save).and_return(false)
        put :update, {:id => linkedin_datum.to_param, :linkedin_datum => {}}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested linkedin_datum" do
      linkedin_datum = LinkedinDatum.create! valid_attributes
      expect {
        delete :destroy, {:id => linkedin_datum.to_param}, valid_session
      }.to change(LinkedinDatum, :count).by(-1)
    end

    it "redirects to the linkedin_data list" do
      linkedin_datum = LinkedinDatum.create! valid_attributes
      delete :destroy, {:id => linkedin_datum.to_param}, valid_session
      response.should redirect_to(linkedin_data_url)
    end
  end

end
