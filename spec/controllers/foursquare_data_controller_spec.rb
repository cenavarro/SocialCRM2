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

describe FoursquareDataController do

  # This should return the minimal set of attributes required to create a valid
  # FoursquareDatum. As you add validations to FoursquareDatum, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # FoursquareDataController. Be sure to keep this updated too.
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
        # Trigger the behavior that occurs when invalid params are submitted
        FoursquareDatum.any_instance.stub(:save).and_return(false)
        post :create, {:foursquare_datum => {}}, valid_session
        assigns(:foursquare_datum).should be_a_new(FoursquareDatum)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
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
        # Assuming there are no other foursquare_data in the database, this
        # specifies that the FoursquareDatum created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
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
        # Trigger the behavior that occurs when invalid params are submitted
        FoursquareDatum.any_instance.stub(:save).and_return(false)
        put :update, {:id => foursquare_datum.to_param, :foursquare_datum => {}}, valid_session
        assigns(:foursquare_datum).should eq(foursquare_datum)
      end

      it "re-renders the 'edit' template" do
        foursquare_datum = FoursquareDatum.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
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