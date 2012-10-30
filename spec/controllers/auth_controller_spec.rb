require 'spec_helper'

describe AuthController do

  before(:each) do
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
      :provider => "google_oauth2",
      :info => {:email => "user@test.com"},
      :uid => "123456"
    })
    request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:google_oauth2]
    request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe "#google_oauth2" do
    context "user with an account" do
      it "logs in success" do
        user = User.create!(:email => "user@test.com", :password => "password_test", :password_confirmation => "password_test")
        get :google_oauth2
        assigns(:user).email.should eq(user.email)
      end

      it "redirects to root path" do
        user = User.create!(:email => "user@test.com", :password => "password_test", :password_confirmation => "password_test")
        get :google_oauth2
        response.should redirect_to(root2_path)
      end
    end

    context "user without an account" do
      it "logs in unsuccess" do
        user = User.create!(:email => "fake@test.com", :password => "password_test", :password_confirmation => "password_test")
        get :google_oauth2
        assigns(:user).should be_nil
      end

      it "redirects to new session page" do
        user = User.create!(:email => "fake@test.com", :password => "password_test", :password_confirmation => "password_test")
        get :google_oauth2
        response.should redirect_to(new_user_session_url)
      end

    end 
  end

  describe "#facebook" do
    context "user with an account" do
      it "logs in success" do
        user = User.create!(:email => "user@test.com", :password => "password_test", :password_confirmation => "password_test")
        get :facebook
        assigns(:user).email.should eq(user.email)
      end

      it "redirects to root path" do
        user = User.create!(:email => "user@test.com", :password => "password_test", :password_confirmation => "password_test")
        get :facebook
        response.should redirect_to(root2_path)
      end
    end

    context "user without an account" do
      it "logs in unsuccess" do
        user = User.create!(:email => "fake@test.com", :password => "password_test", :password_confirmation => "password_test")
        get :facebook
        assigns(:user).should be_nil
      end

      it "redirects to new session page" do
        user = User.create!(:email => "fake@test.com", :password => "password_test", :password_confirmation => "password_test")
        get :facebook
        response.should redirect_to(new_user_session_url)
      end

    end
  end

end
