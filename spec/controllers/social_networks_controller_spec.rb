require 'spec_helper'

describe SocialNetworksController do
  before(:each) do
    @controller.stub(:authenticate_user!)
  end

  def valid_attributes
    {:name => "Social Network Name", :client_id => 1, :info_social_network_id => 1}
  end

  describe "# index" do
    it "assigns all social_networks as @social_networks" do
      social_network = SocialNetwork.create! valid_attributes
      get :index
      assigns(:social_networks).should eq([social_network])
    end
  end

  describe "# new" do
    it "assigns a new social_network as @social_network" do
      get :new
      assigns(:social_network).should be_a_new(SocialNetwork)
    end
  end

  describe "# edit" do
    it "assigns the requested social_network as @social_network" do
      social_network = SocialNetwork.create! valid_attributes
      get :edit, :id => social_network.id.to_s
      assigns(:social_network).should eq(social_network)
    end
  end

  describe "# create" do
    context "with valid params" do
      it "creates a new SocialNetwork" do
        expect {
          post :create, :social_network => valid_attributes
        }.to change(SocialNetwork, :count).by(1)
      end

      it "assigns a newly created social_network as @social_network" do
        post :create, :social_network => valid_attributes
        assigns(:social_network).should be_a(SocialNetwork)
        assigns(:social_network).should be_persisted
      end

      it "redirects to the created social_network" do
        post :create, :social_network => valid_attributes
        response.should redirect_to(social_networks_path)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved social_network as @social_network" do
        SocialNetwork.any_instance.stub(:save).and_return(false)
        post :create, :social_network => {}
        assigns(:social_network).should be_a_new(SocialNetwork)
      end

      it "re-renders the 'new' template" do
        SocialNetwork.any_instance.stub(:save).and_return(false)
        post :create, :social_network => {}
        response.should render_template("new")
      end
    end
  end

  describe "# update" do
    context "with valid params" do
      it "updates the requested social_network" do
        social_network = SocialNetwork.create! valid_attributes
        SocialNetwork.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => social_network.id, :social_network => {'these' => 'params'}
      end

      it "assigns the requested social_network as @social_network" do
        social_network = SocialNetwork.create! valid_attributes
        put :update, :id => social_network.id, :social_network => valid_attributes
        assigns(:social_network).should eq(social_network)
      end

      it "redirects to the social_network" do
        social_network = SocialNetwork.create! valid_attributes
        put :update, :id => social_network.id, :social_network => valid_attributes
        response.should redirect_to(social_networks_path)
      end
    end

    context "with invalid params" do
      it "assigns the social_network as @social_network" do
        social_network = SocialNetwork.create! valid_attributes
        SocialNetwork.any_instance.stub(:save).and_return(false)
        put :update, :id => social_network.id.to_s, :social_network => {}
        assigns(:social_network).should eq(social_network)
      end

      it "re-renders the 'edit' template" do
        social_network = SocialNetwork.create! valid_attributes
        SocialNetwork.any_instance.stub(:save).and_return(false)
        put :update, :id => social_network.id.to_s, :social_network => {}
        response.should render_template("edit")
      end
    end
  end

  describe "# destroy" do
    it "destroys the requested social_network" do
      social_network = SocialNetwork.create! valid_attributes
      expect {
        delete :destroy, :id => social_network.id.to_s
      }.to change(SocialNetwork, :count).by(-1)
    end

    it "redirects to the social_networks list" do
      social_network = SocialNetwork.create! valid_attributes
      delete :destroy, :id => social_network.id.to_s
      response.should redirect_to(social_networks_url)
    end
  end

end
