require 'spec_helper'

describe HomeController do

  before(:each) do
    Client.new(:name => "Client1", :description => "Description Client 1", :image => "image.png").save!
    @controller.stub(:prepare_login_form)
  end

  describe '# index' do
    it "GET index for a authenticated Admin User" do
      @controller.stub(:user_signed_in?).and_return(true)
      @controller.stub(:current_user).and_return(stub_model(User, :rol_id => 1))
      clients = Client.all
      get :index
      assigns(:clients).should eq(clients)
    end

    it "denied access to index for no authenticade User" do
      @controller.stub(:user_signed_in?).and_return(false)
      get :index
      response.should redirect_to('/users/sign_in')
    end

    it "redirects if is a client user" do
      @controller.stub(:user_signed_in?).and_return(true)
      @controller.stub(:current_user).and_return(stub_model(User, :rol_id => 2))
      get :index
      response.should be_redirect
    end
  end
end
