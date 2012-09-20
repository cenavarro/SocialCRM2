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

describe LinkedinDataController do

  # This should return the minimal set of attributes required to create a valid
  # LinkedinDatum. As you add validations to LinkedinDatum, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # LinkedinDataController. Be sure to keep this updated too.
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
        # Trigger the behavior that occurs when invalid params are submitted
        LinkedinDatum.any_instance.stub(:save).and_return(false)
        post :create, {:linkedin_datum => {}}, valid_session
        assigns(:linkedin_datum).should be_a_new(LinkedinDatum)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
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
        # Assuming there are no other linkedin_data in the database, this
        # specifies that the LinkedinDatum created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
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
        # Trigger the behavior that occurs when invalid params are submitted
        LinkedinDatum.any_instance.stub(:save).and_return(false)
        put :update, {:id => linkedin_datum.to_param, :linkedin_datum => {}}, valid_session
        assigns(:linkedin_datum).should eq(linkedin_datum)
      end

      it "re-renders the 'edit' template" do
        linkedin_datum = LinkedinDatum.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
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
