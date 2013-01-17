require 'spec_helper'

describe ClientsController do
  before(:each) do
    @controller.stub(:authenticate_user!)
    @controller.stub(:has_admin_credentials?)
  end

  def valid_attributes
    {:name => "Test", :description => "Test", :user_attributes => {:email=> "test@test.com", :password => "password", :password_confirmation => "password", :rol_id => 2}}
  end

  def create_client_with_user
    client = Client.new(valid_attributes)
    client.attachment = File.new("spec/fixtures/client.png")
    client.save!
    client
  end

  describe "#index" do
    it "verifies @clients has a the correct information" do
      client = create_client_with_user
      get :index, :locale => :en
      assigns(:clients).should eq([client])
    end
  end

  describe "#create" do
    context "with valid data" do
      it "new client" do
        expect {
          @request.env["HTTP_REFERER"] = root_path
          post :create, :locale => :es, :client => valid_attributes
        }.to change(Client, :count).by(1)
      end
    end

    context "with invalid data" do
      it "customer doesnt save" do
        expect {
          @request.env["HTTP_REFERER"] = root_path
          Client.any_instance.stub(:save!).and_return("El Cliente NO se pudo ingresar correctamente.")
          post :create, :locale => :es, :client => valid_attributes
        }.to change(Client, :count).by(0)
      end
    end
  end

  describe "#edit" do
    it "verifies @client has the information of a selected customer" do
      client = create_client_with_user
      get :edit, :locale => :en, :id => client.id.to_s
      assigns(:client).should eq(client)
    end
  end

  describe "#update" do
    context "with valid params" do
      it "the requested customer" do
        client = create_client_with_user
        put :update, :locale => :es, :id => client.id, :client => {:name => "Test Name", :description => "Test", :user_attributes => {:email=> "test@test.com", :password => "password", :password_confirmation => "password", :rol_id => 2}} 
        client = Client.find_by_name('Test Name')
        client.should_not be_nil
      end

      it "redirects to the index client page" do
        client = create_client_with_user
        put :update, :locale => :es, :id => client.id, :client => valid_attributes
        response.should redirect_to(clients_path)
      end
    end

    context "with invalid params" do
      it "assigns the client as @client" do
        client = create_client_with_user
        Client.any_instance.stub(:update_attributes).and_return(false)
        put :update, :locale => :es, :id => client.id.to_s, :name => "Test Name", :password => "", :description => ""
        assigns(:client).should eq(client)
      end

      it "re-renders the 'edit' template" do
        client = create_client_with_user
        Client.any_instance.stub(:update_attributes).and_return(false)
        put :update, :locale => :es, :id => client.id.to_s, :name => "Test Name", :password => "", :description => ""
        response.should render_template("edit")
      end
    end
  end

  describe "#destroy" do
    it "destroys the requested client" do
      client = create_client_with_user
      expect {
        delete :destroy, :locale => :es, :id => client.id.to_s
      }.to change(Client, :count).by(-1)
    end

    it "redirects to the clients list" do
      client = create_client_with_user
      delete :destroy, :locale => :es, :id => client.id.to_s
      response.should redirect_to(clients_url)
    end
  end

  describe "#social_networks" do
    it "gets a list of clients" do
       client = Client.create!(valid_attributes)
       get :social_networks, :locale => :es, :idc => client.id
       assigns(:client).should eq(client)
    end
  end

end
