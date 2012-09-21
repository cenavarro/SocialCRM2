class ClientsController < ApplicationController
  before_filter :authenticate_user!
  
  require 'open-uri'

  def index
    @clients = Client.all

    respond_to do |format|
      format.html
      format.json { render json: @clients }
    end
  end

  def create_user(client_id)
		@user = User.new
		@user.name = params[:name].to_s
		@user.email = params[:email].to_s
		@user.password = params[:password].to_s
		@user.password_confirmation = params[:password_confirmation].to_s
		@user.rol_id = 2
		@user.client_id = client_id.to_i
  	if @user.save 		
  		@mensaje = 'El Cliente se ha ingresado correctamente.'
    else
      Client.find(client_id).destroy 
      @mensaje = 'El Cliente NO se pudo ingresar correctamente.'
  	end
  	respond_to do |format|
	  	format.html { redirect_to request.referer, notice: @mensaje }
  	  format.json { head :ok }
	  end
	end

  def create
    @client = Client.new(:name => params[:name],:description => params[:description], :image => params[:image]) 
    if @client.save
      create_user(@client.id)
    else
      respond_to do |format|
        format.html { redirect_to request.referer, notice: 'El Cliente NO se pudo ingresar correctamente.'}
        format.json { head :ok }
        end
    end
  end

  def edit
    p "Params Edit:" + params.to_json
    @client = Client.find(params[:id])
    @user = User.find_by_client_id(@client.id)
  end

  def update
    p "Params Update:" + params.to_json
    @client = Client.find(params[:id])
    @client.name = params[:name]
    @client.description = params[:description]
    @client.image = params[:image]
    @user = User.find_by_client_id(@client.id)
    @user.email = params[:email]
    @user.name = @client.name
    @user.password = params[:password]
    @user.password_confirmation = params[:password_confirmation]

    respond_to do |format|
      if @client.update_attributes(params[:client]) && @user.save
        format.html { redirect_to clients_path, notice: 'El Cliente fue actualizado correctamente.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @client = Client.find(params[:id])
    @client.destroy

    respond_to do |format|
      format.html { redirect_to clients_url, notice: 'Cliente se elimino correctamente.'}
      format.json { head :ok }
    end
  end

  def social_networks
    @client = Client.find(params[:idc])
    respond_to do|format|
      format.html
      format.json { render json: @client }
    end
  end

  def result_of_get(uri)
    (open(URI.parse(URI.escape(uri.to_s))).read).to_s
  end

  def getInfoPage(page_id,access_token)
    uri = "https://graph.facebook.com/fql?q=select page_id, username, pic_large, description, type from page where page_id = "+page_id.to_s+"&access_token="+access_token.to_s
    result = JSON.parse(result_of_get(uri))
  end

  def getAccessToken(code)
    client_id = "#{SOCIAL_NETWORKS_CONFIG['facebook']['client_id']}"
    client_secret = "#{SOCIAL_NETWORKS_CONFIG['facebook']['client_secret']}"
    # uri = "https://graph.facebook.com/oauth/access_token?client_id=#{client_id}&redirect_uri=#{request.protocol}#{request.host_with_port}/clients/facebook/&code=#{code}&client_secret=#{client_secret}"
    uri = "https://graph.facebook.com/oauth/access_token?client_id=#{client_id}&redirect_uri=#{clients_facebook_path}/&code=#{code}&client_secret=#{client_secret}"
    result = result_of_get(uri)
    result.split("&")[0].split("=")[1]
  end

  def getPagesFacebook(access_token)
    uri = "https://graph.facebook.com/me/accounts?access_token="+access_token
    JSON.parse(result_of_get(uri))
  end


  def facebook
    access_token = getAccessToken(params[:code])
    pages = getPagesFacebook(access_token)
    @pages_array = Hash.new do |h,k|
      h[k] = Hash.new do |sh, sk|
        sh[sk] = []
      end
    end

    pages['data'].each do | page |
      if page['category'] != 'Application'
        info = getInfoPage(page['id'],access_token)
        key = info['data'][0]['username']
        @pages_array[key]['id'] << info['data'][0]['page_id']
        @pages_array[key]['description'] << info['data'][0]['description']
        @pages_array[key]['picture'] << info['data'][0]['pic_large']
        @pages_array[key]['category'] << page['category']
      end
    end

    respond_to do | format |
      format.html
      format.json { head :ok }
    end
  end

  def insert_social_network
    social_network = SocialNetwork.new(:name => params[:name], :client_id => params[:client_id], :info_social_network_id => params[:info_social], :image => params[:image], :id_object => params[:object_id])
    if social_network.save
      case social_network.info_social_network_id
        when 1
          comments = FacebookComment.new(:social_network_id => social_network.id)
        when 2
          comments = TwitterComments.new(:social_network_id => social_network.id)
        when 3
          comments = LinkedinComments.new(:social_network_id => social_network.id)
      end
      comments.save
      respond_to do | format |
        format.html {redirect_to root2_path, notice: "La red social se asocio correctamente." }
        format.json { head :ok }
      end
    else
      respond_to do | format |
        format.html {redirect_to render.refer, notice: "La red social NO se asocio correctamente." }
        format.json { head :ok }
      end
    end
  end

end
