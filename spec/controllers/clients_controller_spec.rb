require 'spec_helper'

describe ClientsController do
  before(:each) do
    @controller.stub(:authenticate_user!)
  end

  def valid_attributes
    {:name => "Test", :description => "Test", :image => "none.png"}
  end

  def create_client_with_user
    client = Client.create!(valid_attributes)
    User.create!(:client_id => client.id,
                 :email => 'fake@example.com',
                 :password => 'password',
		             :password_confirmation => 'password',
		             :rol_id => 2)
    return client
  end

  describe "GET index" do
    it "assigns all clients as @clients" do
      client = create_client_with_user
      get :index
      assigns(:clients).should eq([client])
    end
  end

  describe "GET edit" do
    it "assigns the requested client as @client" do
      client = create_client_with_user
      get :edit, :id => client.id.to_s
      assigns(:client).should eq(client)
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested client" do
        client = create_client_with_user
        Client.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => client.id, :client => {'these' => 'params'}
      end

      it "assigns the requested client as @client" do
        client = create_client_with_user
        put :update, :id => client.id, :client => valid_attributes
        assigns(:client).should eq(client)
      end

      it "redirects to the client" do
        client = create_client_with_user
        put :update, :id => client.id, :client => valid_attributes
        response.should redirect_to(clients_path)
      end
    end

    describe "with invalid params" do
      it "assigns the client as @client" do
        client = create_client_with_user
        Client.any_instance.stub(:save).and_return(false)
        put :update, :id => client.id.to_s, :client => {}
        assigns(:client).should eq(client)
      end

      it "re-renders the 'edit' template" do
        client = create_client_with_user
        Client.any_instance.stub(:save).and_return(false)
        put :update, :id => client.id.to_s, :client => {}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested client" do
      client = create_client_with_user

      expect {
        delete :destroy, :id => client.id.to_s
      }.to change(Client, :count).by(-1)
    end

    it "redirects to the clients list" do
      client = create_client_with_user

      delete :destroy, :id => client.id.to_s
      response.should redirect_to(clients_url)
    end
  end
end
