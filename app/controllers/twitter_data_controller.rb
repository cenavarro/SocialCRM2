class TwitterDataController < ApplicationController

  def index
    if params.has_key?(:id)
      if params[:opcion].to_i == 1
        @twitter_data = TwitterDatum.all
      else
        fechaInicio = Date.new(params[:fi]['fi(1i)'].to_i,params[:fi]['fi(2i)'].to_i,params[:fi]['fi(3i)'].to_i)
        fechaFinal = Date.new(params[:ff]['ff(1i)'].to_i,params[:ff]['ff(2i)'].to_i,params[:ff]['ff(3i)'].to_i)
        @twitter_data = TwitterDatum.where(['start_date >= ? and end_date <= ? AND client_id = ?', fechaInicio,fechaFinal,params[:id].to_i])
        @dates = ""
        @twitter_data.each do |twitter_datum|
          @dates = @dates + twitter_datum.start_date.mday().to_s + " al " + twitter_datum.end_date.mday().to_s + " de " + twitter_datum.end_date.strftime('%B') + ","
        end
      end

      respond_to do |format|
        format.html
        format.json { render json: @twitter_data }
      end
    else
      redirect_to :controller => 'home', :action => 'index'
    end
  end

  # GET /twitter_data/1
  # GET /twitter_data/1.json
  def show
    @twitter_datum = TwitterDatum.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @twitter_datum }
    end
  end

  # GET /twitter_data/new
  # GET /twitter_data/new.json
  def new
    if params.has_key?(:id)
      if params[:opcion].to_i == 1
        @twitter_datum = TwitterDatum.new
        respond_to do |format|
          format.html # new.html.erb
          format.json { render json: @twitter_datum }
        end
      else
        @twitter_datum = TwitterDatum.new
        respond_to do |format|
          format.html # new.html.erb
          format.json { render json: @twitter_datum }
        end
      end
    else
      redirect_to :controller => 'home', :action => 'index'
    end
  end

  # GET /twitter_data/1/edit
  def edit
    @twitter_datum = TwitterDatum.find(params[:id])
  end

  # POST /twitter_data
  # POST /twitter_data.json
  def create
    @twitter_datum = TwitterDatum.new(params[:twitter_datum])

    respond_to do |format|
      if @twitter_datum.save
        format.html { redirect_to @twitter_datum, notice: 'Twitter datum was successfully created.' }
        format.json { render json: @twitter_datum, status: :created, location: @twitter_datum }
      else
        format.html { render action: "new" }
        format.json { render json: @twitter_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /twitter_data/1
  # PUT /twitter_data/1.json
  def update
    @twitter_datum = TwitterDatum.find(params[:id])

    respond_to do |format|
      if @twitter_datum.update_attributes(params[:twitter_datum])
        format.html { redirect_to @twitter_datum, notice: 'Twitter datum was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @twitter_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /twitter_data/1
  # DELETE /twitter_data/1.json
  def destroy
    @twitter_datum = TwitterDatum.find(params[:id])
    @twitter_datum.destroy

    respond_to do |format|
      format.html { redirect_to twitter_data_url }
      format.json { head :ok }
    end
  end
end
