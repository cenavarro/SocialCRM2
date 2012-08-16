class FacebookDataController < ApplicationController
  before_filter :authenticate_user!

  require 'open-uri'

  # GET /facebook_data
  # GET /facebook_data.json
  def index
    if params.has_key?(:id)  
      @facebook_data = FacebookDatum.find(:all, :conditions => {:client_id => params[:id]})
      @dates = ""
      @facebook_data.each do |facebook_datum|
        @dates = @dates + facebook_datum.start_date.mday().to_s + " al " + facebook_datum.end_date.mday().to_s + " de " + facebook_datum.end_date.strftime('%B') + ","
      end
    
      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @facebook_data }
      end
    else
      redirect_to :controller => 'home', :action => 'index'
    end
  end

  # GET /facebook_data/1
  # GET /facebook_data/1.json
  def show
    @facebook_datum = FacebookDatum.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @facebook_datum }
    end
  end
  
  def http_get(object_id,command,start_date,end_date,access_token)
    uri = 'https://graph.facebook.com/'+object_id+'/insights/'+command+'/day/?since='+start_date.to_s+'&until='+end_date.to_s+'&access_token='+access_token
    result = URI.parse(URI.escape(uri))
    json_object = JSON.parse(open(result).read)
  end

  # GET /facebook_data/new
  # GET /facebook_data/new.json
  def new
    if params.has_key?(:id)
      access_token = params[:access_token]
      fecha_inicio = DateTime.new(params[:start_date]['fd(1i)'].to_i,params[:start_date]['fd(2i)'].to_i,params[:start_date]['fd(3i)'].to_i,0,0,0).to_time.to_i
      fecha_final = DateTime.new(params[:end_date]['fd(1i)'].to_i,params[:end_date]['fd(2i)'].to_i,params[:end_date]['fd(3i)'].to_i,23,59,59).to_time.to_i
      object_id = params[:object_id]

      #@page_fan_adds_unique = http_get(object_id,'page_fan_adds_unique',fecha_inicio,fecha_final,access_token)
      #@page_fan_removes_unique = http_get(object_id,'page_fan_removes_unique',fecha_inicio,fecha_final,access_token)
      #@page_impressions_organic = http_get(object_id,'page_impressions_organic',fecha_inicio,fecha_final,access_token)
      #@page_storytellers = http_get(object_id,'page_storytellers',fecha_inicio,fecha_final,access_token)
      #@page_impressions_organic_unique = http_get(object_id,'page_impressions_organic_unique',fecha_inicio,fecha_final,access_token)
      #@page_consumptions_unique = http_get(object_id,'page_consumptions_unique',fecha_inicio,fecha_final,access_token)
      #@page_impressions_unique = http_get(object_id,'page_impressions_unique',fecha_inicio,fecha_final,access_token)
      #@page_friends_of_fans = http_get(object_id,'page_friends_of_fans',fecha_inicio,fecha_final,access_token)
      #@page_impressions = http_get(object_id,'page_impressions',fecha_inicio,fecha_final,access_token)

      #calcular_datos()

      @page_fan_adds = 0
      @page_fan_removes = 0
      @page_impressions_org = 0
      @page_story_teller = 0
      @page_impressions_organic_u = 0
      @page_consumptions_u = 0
      @page_impressions_u = 0
      @page_impression = 0

      @page_friends_of_fan = 0

      @facebook_datum = FacebookDatum.new
      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @facebook_datum }
      end
    else
      redirect_to :controller => 'home', :action => 'index'
    end
  end

  # GET /facebook_data/1/edit
  def edit
    @facebook_datum = FacebookDatum.find(params[:id])
  end

  # POST /facebook_data
  # POST /facebook_data.json
  def create
    @facebook_datum = FacebookDatum.new(params[:facebook_datum])
    if FacebookDatum.all.first == nil
      @facebook_datum.total_fans = 151261
    else
      @facebook_datum.total_fans = @facebook_datum.new_fans + FacebookDatum.all.last.total_fans
    end
    
    respond_to do |format|
      if @facebook_datum.save
        format.html { redirect_to @facebook_datum, notice: 'Facebook datum was successfully created.' }
        format.json { render json: @facebook_datum, status: :created, location: @facebook_datum }
      else
        format.html { render action: "new" }
        format.json { render json: @facebook_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /facebook_data/1
  # PUT /facebook_data/1.json
  def update
    @facebook_datum = FacebookDatum.find(params[:id])

    respond_to do |format|
      if @facebook_datum.update_attributes(params[:facebook_datum])
        format.html { redirect_to @facebook_datum, notice: 'Facebook datum was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @facebook_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /facebook_data/1
  # DELETE /facebook_data/1.json
  def destroy
    @facebook_datum = FacebookDatum.find(params[:id])
    @facebook_datum.destroy

    respond_to do |format|
      format.html { redirect_to facebook_data_url }
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

end
