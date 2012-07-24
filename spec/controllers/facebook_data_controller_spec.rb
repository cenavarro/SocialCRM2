require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe FacebookDataController do

  # This should return the minimal set of attributes required to create a valid
  # FacebookDatum. As you add validations to FacebookDatum, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end

  describe "GET index" do
    it "assigns all facebook_data as @facebook_data" do
      facebook_datum = FacebookDatum.create! valid_attributes
      get :index
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
      get :new
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