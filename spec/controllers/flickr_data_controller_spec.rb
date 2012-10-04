require 'spec_helper'

describe FlickrDataController do

  before(:each) do
    @controller.stub(:authenticate_user!)
  end

  def valid_attributes
    {}
  end

  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all flickr_data as @flickr_data" do
      flickr_datum = FlickrDatum.create! valid_attributes
      get :index, {}, valid_session
      assigns(:flickr_data).should eq([flickr_datum])
    end
  end

  describe "GET show" do
    it "assigns the requested flickr_datum as @flickr_datum" do
      flickr_datum = FlickrDatum.create! valid_attributes
      get :show, {:id => flickr_datum.to_param}, valid_session
      assigns(:flickr_datum).should eq(flickr_datum)
    end
  end

  describe "GET new" do
    it "assigns a new flickr_datum as @flickr_datum" do
      get :new, {}, valid_session
      assigns(:flickr_datum).should be_a_new(FlickrDatum)
    end
  end

  describe "GET edit" do
    it "assigns the requested flickr_datum as @flickr_datum" do
      flickr_datum = FlickrDatum.create! valid_attributes
      get :edit, {:id => flickr_datum.to_param}, valid_session
      assigns(:flickr_datum).should eq(flickr_datum)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new FlickrDatum" do
        expect {
          post :create, {:flickr_datum => valid_attributes}, valid_session
        }.to change(FlickrDatum, :count).by(1)
      end

      it "assigns a newly created flickr_datum as @flickr_datum" do
        post :create, {:flickr_datum => valid_attributes}, valid_session
        assigns(:flickr_datum).should be_a(FlickrDatum)
        assigns(:flickr_datum).should be_persisted
      end

      it "redirects to the created flickr_datum" do
        post :create, {:flickr_datum => valid_attributes}, valid_session
        response.should redirect_to(FlickrDatum.last)
      end
    end

    #describe "with invalid params" do
    #  it "assigns a newly created but unsaved flickr_datum as @flickr_datum" do
    #    # Trigger the behavior that occurs when invalid params are submitted
    #    FlickrDatum.any_instance.stub(:save).and_return(false)
    #    post :create, {:flickr_datum => {}}, valid_session
    #    assigns(:flickr_datum).should be_a_new(FlickrDatum)
    #  end

    #  it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
    #    FlickrDatum.any_instance.stub(:save).and_return(false)
    #    post :create, {:flickr_datum => {}}, valid_session
    #    response.should render_template("new")
    #  end
    #end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested flickr_datum" do
        flickr_datum = FlickrDatum.create! valid_attributes
        # Assuming there are no other flickr_data in the database, this
        # specifies that the FlickrDatum created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        FlickrDatum.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => flickr_datum.to_param, :flickr_datum => {'these' => 'params'}}, valid_session
      end

      it "assigns the requested flickr_datum as @flickr_datum" do
        flickr_datum = FlickrDatum.create! valid_attributes
        put :update, {:id => flickr_datum.to_param, :flickr_datum => valid_attributes}, valid_session
        assigns(:flickr_datum).should eq(flickr_datum)
      end

      it "redirects to the flickr_datum" do
        flickr_datum = FlickrDatum.create! valid_attributes
        put :update, {:id => flickr_datum.to_param, :flickr_datum => valid_attributes}, valid_session
        response.should redirect_to(flickr_datum)
      end
    end

    describe "with invalid params" do
      it "assigns the flickr_datum as @flickr_datum" do
        flickr_datum = FlickrDatum.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        FlickrDatum.any_instance.stub(:save).and_return(false)
        put :update, {:id => flickr_datum.to_param, :flickr_datum => {}}, valid_session
        assigns(:flickr_datum).should eq(flickr_datum)
      end

      it "re-renders the 'edit' template" do
        flickr_datum = FlickrDatum.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        FlickrDatum.any_instance.stub(:save).and_return(false)
        put :update, {:id => flickr_datum.to_param, :flickr_datum => {}}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested flickr_datum" do
      flickr_datum = FlickrDatum.create! valid_attributes
      expect {
        delete :destroy, {:id => flickr_datum.to_param}, valid_session
      }.to change(FlickrDatum, :count).by(-1)
    end

    it "redirects to the flickr_data list" do
      flickr_datum = FlickrDatum.create! valid_attributes
      delete :destroy, {:id => flickr_datum.to_param}, valid_session
      response.should redirect_to(flickr_data_url)
    end
  end

end
