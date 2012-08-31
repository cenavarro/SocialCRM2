require 'spec_helper'

describe InfoSocialNetworksController do
  before(:each) do
    @controller.stub(:authenticate_user!)
  end

  def valid_attributes
    {:name => "Facebook"}
  end

  describe "# index" do
    it "assigns all info_social_networks as @info_social_networks" do
      info_social_network = InfoSocialNetwork.create! valid_attributes
      get :index
      assigns(:info_social_networks).should eq([info_social_network])
    end
  end

  describe "# edit" do
    it "assigns the requested info_social_network as @info_social_network" do
      info_social_network = InfoSocialNetwork.create! valid_attributes
      get :edit, :id => info_social_network.id.to_s
      assigns(:info_social_network).should eq(info_social_network)
    end
  end

  describe "# update" do
    context "with valid params" do
      it "updates the requested info_social_network" do
        info_social_network = InfoSocialNetwork.create! valid_attributes
        InfoSocialNetwork.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => info_social_network.id, :info_social_network => {'these' => 'params'}
      end

      it "assigns the requested info_social_network as @info_social_network" do
        info_social_network = InfoSocialNetwork.create! valid_attributes
        put :update, :id => info_social_network.id, :info_social_network => valid_attributes
        assigns(:info_social_network).should eq(info_social_network)
      end

      it "redirects to the info_social_network" do
        info_social_network = InfoSocialNetwork.create! valid_attributes
        put :update, :id => info_social_network.id, :info_social_network => valid_attributes
        response.should redirect_to(info_social_networks_path)
      end
    end

    context "with invalid params" do
      it "assigns the info_social_network as @info_social_network" do
        info_social_network = InfoSocialNetwork.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        InfoSocialNetwork.any_instance.stub(:save).and_return(false)
        put :update, :id => info_social_network.id.to_s, :info_social_network => {}
        assigns(:info_social_network).should eq(info_social_network)
      end

      it "re-renders the 'edit' template" do
        info_social_network = InfoSocialNetwork.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        InfoSocialNetwork.any_instance.stub(:save).and_return(false)
        put :update, :id => info_social_network.id.to_s, :info_social_network => {}
        response.should render_template("edit")
      end
    end
  end
end
