class TwitterDataController < ApplicationController

  def index
    if existParamIdClient?
      if !getDataDateRange?
        @twitter_data = TwitterDatum.order("start_date ASC")
      else
        fechaInicio = Date.new(params[:fi]['fi(1i)'].to_i,params[:fi]['fi(2i)'].to_i,params[:fi]['fi(3i)'].to_i)
        fechaFinal = Date.new(params[:ff]['ff(1i)'].to_i,params[:ff]['ff(2i)'].to_i,params[:ff]['ff(3i)'].to_i)
        @twitter_data = TwitterDatum.where(['start_date >= ? and end_date <= ? AND client_id = ?', fechaInicio,fechaFinal,params[:idc].to_i]).order("start_date ASC")
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

  def new
    if existParamIdClient?
      if getDataFromTwitter?
        @twitter_datum = TwitterDatum.new
        respond_to do |format|
          format.html
          format.json { render json: @twitter_datum }
        end
      else
        @twitter_datum = TwitterDatum.new
        respond_to do |format|
          format.html
          format.json { render json: @twitter_datum }
        end
      end
    else
      redirect_to :controller => 'home', :action => 'index'
    end
  end

  def edit
    @twitter_datum = TwitterDatum.find(params[:id])
  end

  def create
    @twitter_datum = TwitterDatum.new(params[:twitter_datum])
    @twitter_datum.cost_follower = TwitterDatum.get_cost_follower(@twitter_datum)

    respond_to do |format|
      if @twitter_datum.save
        format.html { redirect_to %{/twitter_data/#{@twitter_datum.client_id}/1}, notice: 'La informacion se ha ingresado exitosamente.'}
        format.json { render json: @twitter_datum, status: :created, location: @twitter_datum }
      else
        format.html { render action: "new" }
        format.json { render json: @twitter_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @twitter_datum = TwitterDatum.find(params[:id])
    @twitter_datum.cost_follower = TwitterDatum.get_cost_follower(@twitter_datum)

    respond_to do |format|
      if @twitter_datum.update_attributes(params[:twitter_datum])
        format.html { redirect_to %{/twitter_data/#{@twitter_datum.client_id}/1}, notice: 'La informacion ha sido actualizada exitosamente.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @twitter_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @twitter_datum = TwitterDatum.find(params[:id])
    @client_id = @twitter_datum.client_id
    @twitter_datum.destroy

    respond_to do |format|
      format.html { redirect_to %{/twitter_data/#{@client_id}/1}, notice: 'La informacion ha sido borrada exitosamente.' }
      format.json { head :ok }
    end
  end

  def existParamIdClient?
    if params.has_key?(:idc)
      return true
    end
    return false
  end  

  def getDataFromTwitter?
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

end



