require 'spec_helper'

describe FacebookDataController do
  before(:each) do
    @controller.stub(:authenticate_user!)
  end

  def valid_attributes
    {
      :start_date => 7.days.ago,
      :end_date => 0.days.ago
    }
  end

  describe "GET index" do
    it "assigns all facebook_data as @facebook_data" do
      facebook_datum = FacebookDatum.create! valid_attributes
      get :index, :id => facebook_datum.client_id
      assigns(:facebook_data).should eq([facebook_datum])
    end
  end

  describe "GET show" do
    it "assigns the requested facebook_datum as @facebook_datum" do
      facebook_datum = FacebookDatum.create! valid_attributes
      get :show, :id => facebook_datum.id.to_s
      assigns(:facebook_datum).should eq(facebook_datum)
    end
  end

  describe "GET new" do
    it "assigns a new facebook_datum as @facebook_datum" do
      get :new, :id => 1, :access_token => 'token', :start_date => {"fd(3i)"=>"21", "fd(2i)"=>"8", "fd(1i)"=>"2012"}, :end_date => {"fd(3i)"=>"21", "fd(2i)"=>"8", "fd(1i)"=>"2012"}, :object_id => 'facqebook_id'

      assigns(:facebook_datum).should be_a_new(FacebookDatum)
    end
  end

  describe "GET edit" do
    it "assigns the requested facebook_datum as @facebook_datum" do
      facebook_datum = FacebookDatum.create! valid_attributes
      get :edit, :id => facebook_datum.id.to_s
      assigns(:facebook_datum).should eq(facebook_datum)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new FacebookDatum" do
        expect {
          post :create, :facebook_datum => valid_attributes
        }.to change(FacebookDatum, :count).by(1)
      end

      it "assigns a newly created facebook_datum as @facebook_datum" do
        post :create, :facebook_datum => valid_attributes
        assigns(:facebook_datum).should be_a(FacebookDatum)
        assigns(:facebook_datum).should be_persisted
      end

      it "redirects to the created facebook_datum" do
        post :create, :facebook_datum => valid_attributes
        response.should redirect_to(FacebookDatum.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved facebook_datum as @facebook_datum" do
        # Trigger the behavior that occurs when invalid params are submitted
        FacebookDatum.any_instance.stub(:save).and_return(false)
        post :create, :facebook_datum => {}
        assigns(:facebook_datum).should be_a_new(FacebookDatum)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        FacebookDatum.any_instance.stub(:save).and_return(false)
        post :create, :facebook_datum => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested facebook_datum" do
        facebook_datum = FacebookDatum.create! valid_attributes
        # Assuming there are no other facebook_data in the database, this
        # specifies that the FacebookDatum created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
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
        response.should redirect_to(facebook_datum)
      end
    end

    describe "with invalid params" do
      it "assigns the facebook_datum as @facebook_datum" do
        facebook_datum = FacebookDatum.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        FacebookDatum.any_instance.stub(:save).and_return(false)
        put :update, :id => facebook_datum.id.to_s, :facebook_datum => {}
        assigns(:facebook_datum).should eq(facebook_datum)
      end

      it "re-renders the 'edit' template" do
        facebook_datum = FacebookDatum.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        FacebookDatum.any_instance.stub(:save).and_return(false)
        put :update, :id => facebook_datum.id.to_s, :facebook_datum => {}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested facebook_datum" do
      facebook_datum = FacebookDatum.create! valid_attributes
      expect {
        delete :destroy, :id => facebook_datum.id.to_s
      }.to change(FacebookDatum, :count).by(-1)
    end

    it "redirects to the facebook_data list" do
      facebook_datum = FacebookDatum.create! valid_attributes
      delete :destroy, :id => facebook_datum.id.to_s
      response.should redirect_to(facebook_data_url)
    end
  end

end
