require 'spec_helper'

describe UsersController do


  before(:each) do
    adminUser = User.new(:name => "Admin User", :email => "admin@test.com", :password => "123456", :password_confirmation => "123456", :rol_id => 1)
    clientUser = User.new(:name => "Client User", :email => "client@test.com", :password => "123456", :password_confirmation => "123456", :rol_id => 2)
    adminUser.save!
    clientUser.save!
    @controller.stub(:authenticate_user!)
    @controller.stub!(:current_user).and_return(User.find(1))
  end

  def valid_attributes
    {
      :name => "User Test", :email => "userTest@test.com", 
      :password => "123456", :password_confirmation => "123456", 
      :rol_id => 1, :user_type => 1
    }
  end

  def invalid_attributes
    {
      :name => "User Test", :email => "", 
      :password => "123456", :password_confirmation => "123456", 
      :rol_id => 1, :user_type => 1
    }
  end

  def valid_attributesClient
    {
      :name => "Client Test", :email => "clientTest@test.com", 
      :password => "123456", :password_confirmation => "123456", 
      :rol_id => 2, :user_type => 2, :description => "Description Client", 
      :image => "image"
    }
  end

  def invalid_attributesClient
    {
      :name => "", :email => "userTest@test.com", :password => "123456", 
      :password_confirmation => "123456", :rol_id => 2, :user_type => 2, 
      :description => "Description Client", :image => "image"
    }
  end

  def invalid_attributesClient2
    {
      :name => "Client Test", :email => "userTest@test.com", :password => "", 
      :password_confirmation => "123456", :rol_id => 2, :user_type => 2, 
      :description => "Description Client", :image => "image"
    }
  end

  describe "# delete" do
    it "GET delete success" do
      users = User.all
      get :delete
      assigns(:users).should eq(users)
    end
  end

  describe '# destroy' do
    it "destroys a requested user" do
      user = User.find(2)
      expect{
        put :destroy, {:id => user.to_param}
      }.to change(User,:count).by(-1)
    end
  end

  describe '# new' do
   it "renders sucess" do
     get :new, :option => 1
     response.should be_success
   end
  end

  describe '# create' do
    context 'when is a admin user' do
      it 'with valid params' do
        expect{
          post :create, valid_attributes
        }.to change(User, :count).by(1)
      end

      it 'with invalid params(no email address)' do
        expect{
          post :create, invalid_attributes
        }.to change(User, :count).by(0)
      end
    end

    context 'when is a client user' do
      it 'with valid params' do
        expect{
          post :create, valid_attributesClient
        }.to change(Client, :count).by(1)
      end

      it 'with invalid params (no client name)' do 
        expect{
          post :create, invalid_attributesClient
        }.to change(Client, :count).by(0)
      end

      it 'with invalid params (no password)' do
        expect{
          post :create, invalid_attributesClient2
        }.to change(Client, :count).by(0)
      end
    end
  end

end
