class ClientsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :has_admin_credentials?, :except => [:social_networks, :reports, :generate_report]

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
  		mensaje = 'El Cliente se ha ingresado correctamente.'
    else
      Client.find(client_id).destroy 
      mensaje = 'El Cliente NO se pudo ingresar correctamente.'
  	end
  	respond_to do |format|
	  	format.html { redirect_to request.referer, notice: mensaje }
  	  format.json { head :ok }
	  end
  end

  def create
    begin
      @client = Client.new(:name => params[:name], :description => params[:description], :attachment => params[:attachment] ) 
      create_user(@client.id) if @client.save!
    rescue
      respond_to do |format|
        format.html { redirect_to request.referer, notice: 'El Cliente NO se pudo ingresar correctamente.'}
        format.json { head :ok }
      end
    end
  end

  def edit
    @client = Client.find(params[:id])
    @user = User.find_by_client_id(@client.id)
  end

  def update
    @client = Client.find(params[:id])
    @user = User.find_by_client_id(@client.id)
    password_changed = !params[:password].empty?
    password_changed ? (user_save = @user.update_attributes!(params)) : (user_save = @user.update_without_password(params))
    @client.name = params[:name]
    @client.description = params[:description]
    @client.attachment = params[:attachment] if !params[:attachment].nil?
    respond_to do |format|
      if @client.save! && user_save
        format.html { redirect_to clients_path, notice: 'El Cliente fue actualizado correctamente.' }
        format.json { head :ok }
      else
        format.html { render action: "edit", notice: "No se pudo actualizar el cliente!" }
        format.json { head :ok }
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
    (session.has_key?(:client_id)) ? (@client = Client.find(session[:client_id]) ): (@client = Client.find(params[:idc]))
    respond_to do|format|
      format.html
      format.json { render json: @client }
    end
  end

  def result_of_get(uri)
    (open(URI.parse(URI.escape(uri.to_s))).read).to_s
  end

  def getInfoPage(page_id,access_token)
    uri = "https://graph.facebook.com/fql?q=select page_id, name, username, pic_large, description, type from page where page_id = "+page_id.to_s+"&access_token="+access_token.to_s
    JSON.parse(result_of_get(uri))
  end

  def getAccessToken(code)
    client_id = "#{SOCIAL_NETWORKS_CONFIG['facebook']['client_id']}"
    client_secret = "#{SOCIAL_NETWORKS_CONFIG['facebook']['client_secret']}"
    uri = "https://graph.facebook.com/oauth/access_token?client_id=#{client_id}&redirect_uri=#{request.protocol}#{request.host_with_port}/#{params[:locale]}/clients/facebook/&code=#{code}&client_secret=#{client_secret}"
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
        key = info['data'][0]['page_id']
        @pages_array[key]['name'] << info['data'][0]['name']
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

  def reports
    current_user.rol_id == 1 ? @clients = Client.all : @clients = [Client.find(current_user.client_id)]
  end

  def generate_report
    client = Client.find(params[:client_id])
    date = Time.now.strftime("%d-%b-%Y")
    file_name = "Reporte_#{date}.xlsx"
    date_range = OpenStruct.new(start_date: params[:start_date], end_date: params[:end_date])
    reports = client.build_reports(date_range)
    file_path = Rails.root.join(file_name)
    reports.serialize(file_path)
    send_file file_path, :type => "application/vnd.ms-excel"
    #File.delete(file_path)
  end

end
