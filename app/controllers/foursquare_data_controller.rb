class FoursquareDataController < ApplicationController

  def create_chart_data
    @dates = @foursquare_datum.collect {|ld| "'" + ld.start_date.strftime('%d %b') + "-" + ld.end_date.strftime('%d %b') + "'"}.join(', ')
    @followers = @foursquare_datum.collect(&:new_followers).join(', ')
    @total_followers = @foursquare_datum.collect(&:total_followers).join(', ')
    @unlocks = @foursquare_datum.collect(&:total_unlocks).join(', ')
    @visits = @foursquare_datum.collect(&:total_visits).join(', ')
  end

  def index
    if existParamIdClient?
      if !getDataDateRange?
        @foursquare_datum = FoursquareDatum.where('social_network_id = ?', params[:id_social]).order("start_date ASC")
      else
        fechaInicio = params[:start_date].to_date
        fechaFinal = params[:end_date].to_date
        @foursquare_datum = FoursquareDatum.where('social_network_id = ? and start_date >= ? and end_date <= ?',params[:id_social], fechaInicio, fechaFinal).order("start_date ASC")
      end

      create_chart_data

      respond_to do |format|
        format.html 
        format.json { render json: @foursquare_datum }
      end
    else
      redirect_to root2_path
    end
  end

  def new
    @foursquare_datum = FoursquareDatum.new

    respond_to do |format|
      format.html
      format.json { render json: @foursquare_datum }
    end
  end

  def edit
    @foursquare_datum = FoursquareDatum.find(params[:id])
  end

  def create
    @foursquare_datum = FoursquareDatum.new(params[:foursquare_datum])
    @foursquare_datum.new_followers = FoursquareDatum.get_new_followers(@foursquare_datum)

    respond_to do |format|
      if @foursquare_datum.save
        format.html { redirect_to foursquare_index_path(@foursquare_datum.client_id,1,@foursquare_datum.social_network_id), notice: 'La informacion se ha ingresado exitosamente.' }
        format.json { render json: @foursquare_datum, status: :created, location: @foursquare_datum }
      else
        format.html { render action: "new" }
        format.json { render json: @foursquare_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @foursquare_datum = FoursquareDatum.find(params[:id])

    respond_to do |format|
      if @foursquare_datum.update_attributes(params[:foursquare_datum])
        @foursquare_datum.new_followers = FoursquareDatum.get_new_followers(@foursquare_datum)
        @foursquare_datum.save!
        format.html { redirect_to foursquare_index_path(@foursquare_datum.client_id,1,@foursquare_datum.social_network_id), notice: 'La informacion ha sido actualizada exitosamente.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @foursquare_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @foursquare_datum = FoursquareDatum.find(params[:id])
    client_id = @foursquare_datum.client_id
    social_id = @foursquare_datum.social_network_id
    @foursquare_datum.destroy

    respond_to do |format|
      format.html { redirect_to foursquare_index_path(client_id,1,social_id), notice: 'La informacion ha sido borrada exitosamente.' }
      format.json { head :ok }
    end
  end

  def save_comment
    comment = FoursquareComment.find_by_social_network_id(params[:social_network].to_i)
    case params[:id_comment].to_i
      when 1
        comment.table = params[:comment]
      when 2
        comment.followers = params[:comment]
      when 3
        comment.deals = params[:comment]
    end
    comment.save! ? (msg =  "Comentario Guardado!") : (msg =  "El comentario no se pudo almacenar!")
    respond_to do | format |
      format.json { render json: msg.to_json }
    end
  end

  def existParamIdClient?
    params.has_key?(:idc) ? (return true) : (return false)
  end

  def getDataDateRange?
    (params[:opcion].to_i == 2) ? (return true) : (return false)
  end
end
