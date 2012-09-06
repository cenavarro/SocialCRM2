class HomeController < ApplicationController

  require 'open-uri'

  def index
    if !user_signed_in?
      redirect_to "/users/sign_in"
    else
      if isUserClient?
        redirect_to "/clients/social_networks?id="
      else
        p session.to_s
        p user_signed_in?
        p current_user
        @clients = Client.all
        respond_to do |format|
          format.html
          format.json
        end
      end
    end
  end

  def validate_user
    code = params[:code]
    client_id = "#{SOCIAL_NETWORKS_CONFIG['facebook']['client_id']}"
    client_secret = "#{SOCIAL_NETWORKS_CONFIG['facebook']['client_secret']}"
    hostname = request.host_with_port
    uri = "https://graph.facebook.com/oauth/access_token?client_id=#{client_id}&redirect_uri=#{request.protocol}#{hostname}/validate_user/&code=#{code}&client_secret=#{client_secret}"
    p "uri1:" + uri
    result_from_facebook = open(URI.parse(URI.escape(uri))).read
    access_token = result_from_facebook.split("&")[0].split("=")[1]
    uri = "https://graph.facebook.com/me?access_token=#{access_token}"
    result = JSON.parse(open(URI.parse(URI.escape(uri))).read)
    p "Code:" + code.to_s
    p "client_idi:" + client_id.to_s
    p "client_secret:" + client_secret.to_s
    p "hostname:" + hostname.to_s
    p "result_from_facebook:" + result_from_facebook.to_s
    p "accesstoken:" + access_token.to_s
    p "uri2:" + uri.to_s
    p "result:" + result.to_s
    @user = User.find_by_email(result['email'])
    if @user.nil?
      respond_to do |format|
        format.html { redirect_to new_user_session_path, notice: 'Este usuario de facebook no tiene cuenta asociada.' }
      end
    else
      session[:user] = @user
      session[:fb_accessToken] = access_token
      session[:fb_code] = code
      session[:fb_app_id] = @user.fbapp_id
      respond_to do |format|
        sign_in @user
        format.html { redirect_to "/" }
      end
    end
  end

  def isUserClient?
    if current_user.rol_id == 2
      return true
    end
    return false
  end

end
