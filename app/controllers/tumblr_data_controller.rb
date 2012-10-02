class TumblrDataController < ApplicationController
  before_filter :authenticate_user!

  def createChartData
    @dates = @tumblr_datum.collect {|ld| "'" + ld.start_date.strftime('%d %b') + "-" + ld.end_date.strftime('%d %b') + "'"}.join(', ')
    @new_followers = @tumblr_datum.collect(&:new_followers).join(', ')
    @total_followers = @tumblr_datum.collect(&:total_followers).join(', ')
    @likes = @tumblr_datum.collect(&:likes).join(', ')
    @reblogged = @tumblr_datum.collect(&:reblogged).join(', ')
    @total_investment = @tumblr_datum.collect{ |fd| TumblrDatum.get_total_investment(fd)}.join(', ')
  end

  def index
    if existParamIdClient?
      if !getDataDateRange?
        @tumblr_datum = TumblrDatum.where('social_network_id = ?', params[:id_social]).order("start_date ASC")
      else
        fechaInicio = params[:start_date].to_date
        fechaFinal = params[:end_date].to_date
        @tumblr_datum = TumblrDatum.where('social_network_id = ? and start_date >= ? and end_date <= ?',params[:id_social], fechaInicio, fechaFinal).order("start_date ASC")
      end

      createChartData

      respond_to do |format|
        format.html 
        format.json { render json: @tumblr_datum }
      end
    else
      redirect_to root2_path
    end
  end

  def new
    @tumblr_datum = TumblrDatum.new

    respond_to do |format|
      format.html
      format.json { render json: @tumblr_datum }
    end
  end

  def edit
    @tumblr_datum = TumblrDatum.find(params[:id])
  end

  def create
    @tumblr_datum = TumblrDatum.new(params[:tumblr_datum])
    @tumblr_datum.new_followers = TumblrDatum.get_new_followers(@tumblr_datum)

    respond_to do |format|
      if @tumblr_datum.save
        format.html { redirect_to tumblr_index_path(@tumblr_datum.client_id, 1, @tumblr_datum.social_network_id), notice: 'La informacion se ha ingresado exitosamente.'}
        format.json { render json: @tumblr_datum, status: :created, location: @tumblr_datum }
      else
        format.html { render action: "new" }
        format.json { render json: @tumblr_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @tumblr_datum = TumblrDatum.find(params[:id])

    respond_to do |format|
      if @tumblr_datum.update_attributes(params[:tumblr_datum])
        @tumblr_datum.new_followers = TumblrDatum.get_new_followers(@tumblr_datum)
        @tumblr_datum.save!
        format.html { redirect_to tumblr_index_path(@tumblr_datum.client_id, 1, @tumblr_datum.social_network_id), notice: 'La informacion ha sido actualizada exitosamente.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @tumblr_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @tumblr_datum = TumblrDatum.find(params[:id])
    client_id = @tumblr_datum.client_id
    social_id = @tumblr_datum.social_network_id
    @tumblr_datum.destroy

    respond_to do |format|
      format.html { redirect_to tumblr_index_path(client_id, 1, social_id), notice: 'La informacion ha sido borrada exitosamente.' }
      format.json { head :ok }
    end
  end

  def save_comment
    comment = TumblrComment.find_by_social_network_id(params[:social_network].to_i)
    case params[:id_comment].to_i
      when 1
        comment.table = params[:comment]
      when 2
        comment.followers = params[:comment]
      when 3
        comment.interactivity = params[:comment]
      when 4
        comment.investment = params[:comment]
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

  def existParamIdClient?
    return true if params.has_key?(:idc)
    return false
  end  

  def getDataDateRange?
    return true if params[:opcion].to_i == 2
    return false
  end
end
