class FacebookDataController < ApplicationController
  before_filter :authenticate_user!

  require 'open-uri'

  def index
    if existParamIdClient?
      if !getDataDateRange?
        @facebook_data = FacebookDatum.order("start_date ASC")
      else
        fechaInicio = Date.new(params[:fi]['fi(1i)'].to_i,params[:fi]['fi(2i)'].to_i,params[:fi]['fi(3i)'].to_i)
        fechaFinal = Date.new(params[:ff]['ff(1i)'].to_i,params[:ff]['ff(2i)'].to_i,params[:ff]['ff(3i)'].to_i)
        @facebook_data = FacebookDatum.where(['start_date >= ? and end_date <= ? AND client_id = ?', fechaInicio,fechaFinal,params[:idc].to_i]).order("start_date ASC")
        @dates = ""
        @facebook_data.each do |facebook_datum|
          @dates = @dates + facebook_datum.start_date.mday().to_s + " al " + facebook_datum.end_date.mday().to_s + " de " + facebook_datum.end_date.strftime('%B') + ","
        end
      end

      respond_to do |format|
        format.html
        format.json { render json: @facebook_data }
      end
    else
      redirect_to :controller => 'home', :action => 'index'
    end
  end
  
  def http_get(object_id,command,start_date,end_date,access_token)
    uri = 'https://graph.facebook.com/'+object_id+'/insights/'+command+'/day/?since='+start_date.to_s+'&until='+end_date.to_s+'&access_token='+access_token
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
        access_token = params[:access_token]
        fecha_inicio = DateTime.new(params[:fi]['fi(1i)'].to_i,params[:fi]['fi(2i)'].to_i,params[:fi]['fi(3i)'].to_i,0,0,0).to_time.to_i
        fecha_final = DateTime.new(params[:ff]['ff(1i)'].to_i,params[:ff]['ff(2i)'].to_i,params[:ff]['ff(3i)'].to_i,23,59,59).to_time.to_i
        object_id = params[:object_id]

        @facebook_datum = FacebookDatum.new
        respond_to do |format|
          format.html
          format.json { render json: @facebook_datum }
        end
      else
        @facebook_datum = FacebookDatum.new
        respond_to do |format|
          format.html
          format.json { render json: @facebook_datum }
        end
      end
    else
      redirect_to :controller => 'home', :action => 'index'
    end
  end

  def edit
    @facebook_datum = FacebookDatum.find(params[:id])
  end

  def create
    @facebook_datum = FacebookDatum.new(params[:facebook_datum])

    if FacebookDatum.all.first == nil
      @facebook_datum.total_fans = 151261
    else
      @facebook_datum.total_fans = @facebook_datum.new_fans + FacebookDatum.all.last.total_fans
    end
    
    respond_to do |format|
      if @facebook_datum.save
        @path = %{/facebook_data/#{@facebook_datum.client_id.to_i}/1}
        format.html { redirect_to @path, notice: 'La Nueva Entrada de Datos se creo satisfactoriamente.' }
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
        format.html { redirect_to %{/facebook_data/#{@facebook_datum.client_id}/1}, notice: 'La informacion ha sido actualizada con exitosamente.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @facebook_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @facebook_datum = FacebookDatum.find(params[:id])
    @client_id = @facebook_datum.client_id
    @facebook_datum.destroy

    respond_to do |format|
      format.html { redirect_to %{/facebook_data/#{@client_id}/1}, notice: 'La informacion ha sido borrada exitosamente.' }
      format.json { head :ok }
    end
  end

  def calcular_datos

    @page_fan_adds = 0
    @page_fan_removes = 0
    @page_impressions_org = 0
    @page_story_teller = 0
    @page_impressions_organic_u = 0
    @page_consumptions_u = 0
    @page_impressions_u = 0
    @page_impression = 0

    @page_friends_of_fan = @page_friends_of_fans['data'][0]['values'].last['value']

    @page_fan_adds_unique['data'][0]['values'].each do |f|
      @page_fan_adds += f['value'].to_i
    end

    @page_fan_removes_unique['data'][0]['values'].each do |f|
      @page_fan_removes += f['value'].to_i
    end

    @page_impressions_organic['data'][0]['values'].each do |f|
      @page_impressions_org += f['value'].to_i
    end

    @page_storytellers['data'][0]['values'].each do |f|
      @page_story_teller += f['value'].to_i
    end

    @page_impressions_organic_unique['data'][0]['values'].each do |f|
      @page_impressions_organic_u += f['value'].to_i
    end

    @page_consumptions_unique['data'][0]['values'].each do |f|
      @page_consumptions_u += f['value'].to_i
    end

    @page_impressions_unique['data'][0]['values'].each do |f|
      @page_impressions_u += f['value'].to_i
    end

    @page_impressions['data'][0]['values'].each do |f|
      @page_impression += f['value'].to_i
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
