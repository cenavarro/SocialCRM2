require 'spec_helper'

describe ClientsController do
  before(:each) do
    @controller.stub(:authenticate_user!)
    @controller.stub(:has_admin_credentials?)
  end

  def valid_attributes
    {:name => "Test", :description => "Test"}
  end

  def create_client_with_user
    client = Client.new(valid_attributes)
    client.attachment = File.new("spec/fixtures/client.png")
    client.save!
    User.create!(:client_id => client.id,
                 :email => 'fake@example.com',
                 :password => 'password',
		             :password_confirmation => 'password',
		             :rol_id => 2)
    return client
  end

  describe "#index" do
    it "verifies @clients has a the correct information" do
      client = create_client_with_user
      get :index, :locale => :es
      assigns(:clients).should eq([client])
    end
  end

  describe "#create" do
    context "with valid data" do
      it "create a new client and the user for the new client" do
        expect {
          @request.env["HTTP_REFERER"] = root_path
          post :create, :locale => :es, :attachment => nil, :name => "Test", :description => "Description", :email => "fake@example.com", :password => "password_test", :password_confirmation => "password_test"
        }.to change(Client, :count).by(1)
        user = User.find_by_email("fake@example.com") 
        user.should_not be_nil
      end
    end

    context "with invalid data" do
      it "client has invalid data only for client info" do
        expect {
          @request.env["HTTP_REFERER"] = root_path
          post :create, :locale => :es, :attachment => nil, :name => "Test", :description => nil, :email => "fake@example.com", :password => "password_test", :password_confirmation => "password_test"
        }.to change(Client, :count).by(0)
      end

      it "client has valid data but the user info is invalid" do
        expect{
          @request.env["HTTP_REFERER"] = root_path
          post :create, :locale => :es, :attachment => nil, :name => "Test", :description => "Description", :email => "fake@example.com", :password => "password_test", :password_confirmation => "password_wrong"
        }.to change(User, :count).by(0)
        Client.all.should be_empty
      end
    end
  end

  describe "#edit" do
    it "verifies @client has the information of a selected client" do
      client = create_client_with_user
      get :edit, :locale => :es, :id => client.id.to_s
      assigns(:client).should eq(client)
    end
  end

  describe "#update" do
    context "with valid params" do
      it "updates the requested client with password changed" do
        client = create_client_with_user
        put :update, :locale => :es, :id => client.id, :description => client.description, :name => "Test Name", :password => "test_pass", :email => 'fake@example.com', :password_confirmation => 'test_pass'
        client = Client.find_by_name('Test Name')
        client.should_not be_nil
      end

      it "updates the requested client without password changed" do
        client = create_client_with_user
        put :update, :locale => :es, :id => client.id, :description => client.description, :name => "Test Name", :password => "", :email => 'fake@example.com', :password_confirmation => "" 
        client = Client.find_by_name('Test Name')
        client.should_not be_nil
      end

      it "assigns the requested client as @client" do
        client = create_client_with_user
        put :update, :locale => :es, :id => client.id, :description => client.description, :name => client.name, :password => "", :email => 'fake@example.com', :password_confirmation => ""
        assigns(:client).should eq(client)
      end

      it "redirects to the index client page" do
        client = create_client_with_user
        put :update, :locale => :es, :id => client.id, :description => client.description, :name => client.name, :password => "", :email => 'fake@example.com', :password_confirmation => ""
        response.should redirect_to(clients_path)
      end
    end

    context "with invalid params" do
      it "assigns the client as @client" do
        client = create_client_with_user
        Client.any_instance.stub(:save!).and_return(false)
        put :update, :locale => :es, :id => client.id.to_s, :name => "Test Name", :password => "", :description => ""
        assigns(:client).should eq(client)
      end

      it "re-renders the 'edit' template" do
        client = create_client_with_user
        Client.any_instance.stub(:save!).and_return(false)
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
