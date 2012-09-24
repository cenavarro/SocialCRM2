class FacebookDataController < ApplicationController
  before_filter :authenticate_user!

  require 'open-uri'

  def createCharData
    @dates = @facebook_data.collect { |fd| "'" + fd.start_date.mday().to_s + "-" + fd.end_date.mday().to_s + " " + fd.end_date.strftime('%B') + "'" }.join(', ')
    @newFans = @facebook_data.collect(&:new_fans).join(', ')
    @totalFans = @facebook_data.collect(&:total_fans).join(', ')
    @goalFans = @facebook_data.collect(&:goal_fans).join(', ')
    @interactions = @facebook_data.collect(&:total_interactions).join(', ')
    @clics_anno = @facebook_data.collect(&:total_clicks_anno).join(', ')
    @total_interactions = @facebook_data.collect { |fd| FacebookDatum.get_total_interactions(fd)}.join(', ')
    @newFans = @facebook_data.collect(&:new_fans).join(', ')
    @investment = @facebook_data.collect { |fd| FacebookDatum.get_total_investment(fd) }.join(', ')
    @ctr_anno = @facebook_data.collect(&:ctr_anno).join(', ')
    @cpc_anno = @facebook_data.collect(&:cpc_anno).join(', ')
    @coste_interaction = @facebook_data.collect { |fd| FacebookDatum.get_coste_interaction(fd) }.join(', ')
    @cpm_anno = @facebook_data.collect(&:cpm_anno).join(', ')
    @cpm_general = @facebook_data.collect {|fd| FacebookDatum.get_cpm_general(fd)}.join(', ')
    @coste_fan = @facebook_data.collect {|fd| FacebookDatum.get_fan_cost(fd)}.join(', ')
    @prints = @facebook_data.collect{ |fd| FacebookDatum.get_total_prints(fd) }.join(', ')
    @total_reach = @facebook_data.collect(&:total_reach).join(', ')
    @potencial_reach = @facebook_data.collect(&:potential_reach).join(', ')
  end

  def index
    if existParamIdClient?
      if !getDataDateRange?
        @facebook_data = FacebookDatum.where('id_social_network = ?', params[:id_social]).order("start_date ASC")
      else
        fechaInicio = params[:start_date].to_date
        fechaFinal = params[:end_date].to_date
        @facebook_data = FacebookDatum.where(['start_date >= ? and end_date <= ? and id_social_network = ?', fechaInicio,fechaFinal,params[:id_social]]).order("start_date ASC")
      end

      createCharData
      
      respond_to do |format|
        format.html
        format.json { render json: @facebook_data }
      end
    else
      redirect_to root2_path
    end
  end

  def callback
    client_id = "#{SOCIAL_NETWORKS_CONFIG['facebook']['client_id']}"
    client_secret = "#{SOCIAL_NETWORKS_CONFIG['facebook']['client_secret']}"
    fecha_inicio = params[:start_date]
    fecha_final = params[:end_date]
    hostname = request.host_with_port
    uri = "https://graph.facebook.com/oauth/access_token?client_id=#{client_id}&redirect_uri=#{facebook_callback_path(params[:idc],fecha_inicio,fecha_final)}/&code=#{params[:code]}&client_secret=#{client_secret}"
    result_from_facebook = open(URI.parse(URI.escape(uri))).read
    access_token = result_from_facebook.split("&")[0].split("=")[1]

    respond_to do |format|
      @path = %{#{facebook_new_path(params[:idc],1)}/?start_date=#{params[:start_date]}&end_date=#{params[:end_date]}&access_token=#{access_token}}
      format.html { redirect_to @path }
      format.json
    end
  end

  def http_get(object_id,command,start_date,end_date,access_token)
    start_date = start_date.to_time.to_i.to_s
    end_date = end_date.to_time.to_i.to_s
    uri = 'https://graph.facebook.com/'+object_id+'/insights/'+command+'/day/?since='+start_date+'&until='+end_date+'&access_token='+access_token
    result = URI.parse(URI.escape(uri))
    json_object = JSON.parse(open(result).read)
  end

  def new
    if existParamIdClient?
      @page_fan_adds = 0
      @page_fan_removes = 0
      @page_impressions_org = 0
      @page_story_teller = 0
      @page_impressions_organic_u = 0
      @page_consumptions_u = 0
      @page_impressions_u = 0
      @page_impression = 0
      @page_friends_of_fan = 0
      if getDataFromFacebook?
        facebook_id = SocialNetwork.where("client_id = ? and info_social_network_id = 1",params[:idc])[0].id_object.to_s
        fecha_inicio = params[:start_date]
        fecha_final = params[:end_date]
        access_token = params[:access_token]
        @page_fan_adds_unique = http_get(facebook_id,'page_fan_adds_unique',fecha_inicio,fecha_final,access_token)
        @page_fan_removes_unique = http_get(facebook_id,'page_fan_removes_unique',fecha_inicio,fecha_final,access_token)
        @page_impressions_organic = http_get(facebook_id,'page_impressions_organic',fecha_inicio,fecha_final,access_token)
        @page_storytellers = http_get(facebook_id,'page_storytellers',fecha_inicio,fecha_final,access_token)
        @page_impressions_organic_unique = http_get(facebook_id,'page_impressions_organic_unique',fecha_inicio,fecha_final,access_token)
        @page_consumptions_unique = http_get(facebook_id,'page_consumptions_unique',fecha_inicio,fecha_final,access_token)
        @page_impressions_unique = http_get(facebook_id,'page_impressions_unique',fecha_inicio,fecha_final,access_token)
        @page_friends_of_fans = http_get(facebook_id,'page_friends_of_fans',fecha_inicio,fecha_final,access_token)
        @page_impressions = http_get(facebook_id,'page_impressions',fecha_inicio,fecha_final,access_token)

        calcular_datos()

      end
      @facebook_datum = FacebookDatum.new
      respond_to do |format|
        format.html
        format.json { render json: @facebook_datum }
      end
    else
      redirect_to root2_path
    end
  end

  def edit
    @facebook_datum = FacebookDatum.find(params[:id])
  end

  def create
    @facebook_datum = FacebookDatum.new(params[:facebook_datum])
    @facebook_datum.new_fans = FacebookDatum.get_new_fans(@facebook_datum)
    
    respond_to do |format|
      if @facebook_datum.save
        format.html { redirect_to facebook_index_path(@facebook_datum.client_id.to_i,1,@facebook_datum.id_social_network), notice: 'La Nueva Entrada de Datos se creo satisfactoriamente.' }
      else
        format.html { render action: "new" }
        format.json { render json: @facebook_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @facebook_datum = FacebookDatum.find(params[:id])

    respond_to do |format|
      if @facebook_datum.update_attributes(params[:facebook_datum])
        @facebook_datum.new_fans = FacebookDatum.get_new_fans(@facebook_datum)
        @facebook_datum.save!
        format.html { redirect_to facebook_index_path(@facebook_datum.client_id,1,@facebook_datum.id_social_network), notice: 'La informacion ha sido actualizada con exitosamente.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @facebook_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @facebook_datum = FacebookDatum.find(params[:id])
    client_id = @facebook_datum.client_id
    id_social = @facebook_datum.id_social_network
    @facebook_datum.destroy

    respond_to do |format|
      format.html { redirect_to facebook_index_path(client_id, 1, id_social), notice: 'La informacion ha sido borrada exitosamente.' }
      format.json { head :ok }
    end
  end

  def save_comment
    comment = FacebookComment.where(:social_network_id => params[:social_network].to_i)[0]
    case params[:id_comment].to_i
      when 1
        comment.table = params[:comment]
      when 2
        comment.fans = params[:comment]
      when 3
        comment.interaction = params[:comment]
      when 4
        comment.investment = params[:comment]
      when 5
        comment.cost = params[:comment]
      when 6
        comment.reach = params[:comment]
    end
    if comment.save
        mensaje =  "Comentario Guardado!"
    else
        mensaje =  "El comentario no se pudo almacenar!"
    end
    respond_to do | format |
      format.json { render json: mensaje.to_json }
    end
  end

  def calcular_datos

    if !@page_friends_of_fans['data'].empty?
      @page_friends_of_fan = @page_friends_of_fans['data'][0]['values'].last['value']
    end

    if !@page_fan_adds_unique['data'].empty?
      @page_fan_adds_unique['data'][0]['values'].each do |f|
        @page_fan_adds += f['value'].to_i
      end
    end

    if !@page_fan_removes_unique['data'].empty?
      @page_fan_removes_unique['data'][0]['values'].each do |f|
        @page_fan_removes += f['value'].to_i
      end
    end

    if !@page_impressions_organic['data'].empty?
      @page_impressions_organic['data'][0]['values'].each do |f|
        @page_impressions_org += f['value'].to_i
      end
    end

    if !@page_storytellers['data'].empty?
      @page_storytellers['data'][0]['values'].each do |f|
        @page_story_teller += f['value'].to_i
      end
    end

    if !@page_impressions_organic_unique['data'].empty?
      @page_impressions_organic_unique['data'][0]['values'].each do |f|
        @page_impressions_organic_u += f['value'].to_i
      end
    end

    if !@page_consumptions_unique['data'].empty?
      @page_consumptions_unique['data'][0]['values'].each do |f|
        @page_consumptions_u += f['value'].to_i
      end
    end

    if !@page_impressions_unique['data'].empty?
      @page_impressions_unique['data'][0]['values'].each do |f|
        @page_impressions_u += f['value'].to_i
      end
    end

    if !@page_impressions['data'].empty?
      @page_impressions['data'][0]['values'].each do |f|
        @page_impression += f['value'].to_i
      end
    end
  end

  def getDataFromFacebook?
    if params[:opcion].to_i == 1
      return true
    end
    return false
  end

  def getDataDateRange?
    if params[:opcion].to_i == 2
      return true
    end
    return false
  end

  def existParamIdClient?
    if params.has_key?(:idc)
      return true
    end
    return false
  end

end
