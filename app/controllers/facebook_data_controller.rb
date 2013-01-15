class FacebookDataController < ApplicationController
  before_filter :authenticate_user!
  before_filter :has_admin_credentials?, :except => [:index]

  require 'open-uri'

  def index
    if !get_data_from_range_date?
      @facebook_data = FacebookDatum.where('social_network_id = ?', params[:id_social]).order("start_date ASC")
    else
      @facebook_data = FacebookDatum.where(['start_date >= ? and end_date <= ? and social_network_id = ?', params[:start_date].to_date, params[:end_date].to_date, params[:id_social]]).order("start_date ASC")
    end
    @chart = create_chart_data(@facebook_data)
  end

  def callback
    uri = access_token_url
    facebook_response = open(URI.parse(URI.escape(uri))).read
    access_token = facebook_response.split("&")[0].split("=")[1]
    respond_to do |format|
      format.html {redirect_to facebook_new_path(params[:idc], 1, params[:id_social], params[:start_date], params[:end_date], access_token)}
    end
  end

  def new
    @facebook = Hash.new(0)
    if data_from_facebook?
      facebook_id = SocialNetwork.find_by_id_and_client_id(params[:id_social], params[:idc]).id_object.to_s
      @facebook = calc_facebook_values(facebook_id)
    end
    @facebook_datum = FacebookDatum.new
  end

  def edit
    @facebook_datum = FacebookDatum.find(params[:id])
  end

  def create
    @facebook_datum = FacebookDatum.new(params[:facebook_datum])

    respond_to do |format|
      if @facebook_datum.save
        format.html { redirect_to facebook_index_path(@facebook_datum.client_id.to_i,1,@facebook_datum.social_network_id), notice: 'La Nueva Entrada de Datos se creo satisfactoriamente.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @facebook_datum = FacebookDatum.find(params[:id])

    respond_to do |format|
      if @facebook_datum.update_attributes(params[:facebook_datum])
        @facebook_datum.save!
        format.html { redirect_to facebook_index_path(@facebook_datum.client_id,1,@facebook_datum.social_network_id), notice: 'La informacion ha sido actualizada con exitosamente.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @facebook_datum = FacebookDatum.find(params[:id])
    client_id = @facebook_datum.client_id
    id_social = @facebook_datum.social_network_id
    @facebook_datum.destroy

    respond_to do |format|
      format.html { redirect_to facebook_index_path(client_id, 1, id_social), notice: 'La informacion ha sido borrada exitosamente.' }
    end
  end

  private

  def data_from_facebook?
    (params[:opcion].to_i == 1) ? ( return true) : (return false)
  end

  def create_chart_data(data)
    chart_values = {}
    chart_data_keys.each do |key|
      chart_values[key] = data.collect(&:"#{key}").join(', ')
    end
    chart_values['dates'] =  data.collect { |fd| "'#{fd.start_date.strftime('%d %b')} - #{fd.end_date.strftime('%d %b')}'" }.join(', ')
    chart_values['coste_fan'] = data.collect {|fd| fd.fan_cost}.join(', ')
    chart_values['prints'] = data.collect{ |fd| fd.total_prints }.join(', ')
    chart_values['investment'] = data.collect { |fd| fd.total_investment }.join(', ')
    return chart_values
  end

  def calc_facebook_values(facebook_id)
    flash[:notice] = "Usted no tiene privilegios para obtener informacion de esta pagina de facebook! Pero el ingreso manual si es permitido"
    facebook_values = Hash.new(0) 
    facebook_data_keys.each do |key|
      data = http_get(facebook_id, key, params[:start_date],params[:end_date],params[:access_token])
      if !data.nil? && !data['data'].empty?
        if key != 'page_friends_of_fans'
          facebook_values[key] = data['data'][0]['values'].inject(0){|sum, val| sum + val['value']}
        else
          facebook_values[key] = data['data'][0]['values'].last['value']
        end
        flash[:notice] = nil
      end
    end 
    facebook_values
  end

  def facebook_data_keys
    ['page_fan_adds_unique', 
      'page_fan_removes_unique', 
      'page_impressions_organic', 
      'page_storytellers', 
      'page_impressions_organic_unique',
      'page_consumptions_unique', 
      'page_impressions_unique', 
      'page_friends_of_fans',
      'page_impressions']
  end

  def chart_data_keys
    ['new_fans',
      'total_fans',
      'goal_fans',
      'total_interactions',
      'coste_interactions',
      'total_clicks_anno',
      'ctr_anno',
      'cpc_anno',
      'cpm_anno',
      'cpm_general',
      'total_reach',
      'potential_reach',
      'brand_total_interactions'
    ]
  end

  def http_get(object_id,command,start_date,end_date,access_token)
    json_object = nil 
    begin
      start_date = start_date.to_time.to_i.to_s
      end_date = end_date.to_time.to_i.to_s
      uri = 'https://graph.facebook.com/'+object_id+'/insights/'+command+'/day/?since='+start_date+'&until='+end_date+'&access_token='+access_token
      result = URI.parse(URI.escape(uri))
      json_object = JSON.parse(open(result).read)
    rescue
      flash[:notice] = "Ha ocurrido un error a la hora de obtener los datos con el servidor!"
    end
    json_object
  end

  def access_token_url
    client_id = "#{SOCIAL_NETWORKS_CONFIG['facebook']['client_id']}"
    client_secret = "#{SOCIAL_NETWORKS_CONFIG['facebook']['client_secret']}"
    hostname = "#{request.protocol}#{request.host_with_port}"
    "https://graph.facebook.com/oauth/access_token?client_id=#{client_id}&redirect_uri="+
      "#{hostname}#{facebook_callback_dates_path(params[:idc], params[:id_social], 
      params[:start_date],params[:end_date])}/&code=#{params[:code]}&client_secret=#{client_secret}"
  end

end
