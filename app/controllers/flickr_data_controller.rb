class FlickrDataController < ApplicationController
  before_filter :authenticate_user!

  def createChartData
    @dates = @flickr_datum.collect {|ld| "'" + ld.start_date.strftime('%d %b') + "-" + ld.end_date.strftime('%d %b') + "'"}.join(', ')
    @new_contacts = @flickr_datum.collect(&:new_contacts).join(', ')
    @total_contacts = @flickr_datum.collect(&:total_contacts).join(', ')
    @visits = @flickr_datum.collect(&:visits).join(', ')
    @comment = @flickr_datum.collect(&:comments).join(', ')
    @favorites = @flickr_datum.collect(&:favorites).join(', ')
    @total_investment = @flickr_datum.collect{ |fd| FlickrDatum.get_total_investment(fd)}.join(', ')
  end

  def index
    if existParamIdClient?
      if !getDataDateRange?
        @flickr_datum = FlickrDatum.where('social_network_id = ?', params[:id_social]).order("start_date ASC")
      else
        fechaInicio = params[:start_date].to_date
        fechaFinal = params[:end_date].to_date
        @flickr_datum = FlickrDatum.where('social_network_id = ? and start_date >= ? and end_date <= ?',params[:id_social], fechaInicio, fechaFinal).order("start_date ASC")
      end

      createChartData

      respond_to do |format|
        format.html 
        format.json { render json: @flickr_datum }
      end
    else
      redirect_to root2_path
    end
  end

  def new
    @flickr_datum = FlickrDatum.new

    respond_to do |format|
      format.html
      format.json { render json: @flickr_datum }
    end
  end

  def edit
    @flickr_datum = FlickrDatum.find(params[:id])
  end

  def create
    @flickr_datum = FlickrDatum.new(params[:flickr_datum])
    @flickr_datum.new_contacts = FlickrDatum.get_new_contacts(@flickr_datum)
    respond_to do |format|
      if @flickr_datum.save
        format.html { redirect_to flickr_index_path(@flickr_datum.client_id,1,@flickr_datum.social_network_id), notice: 'La informacion se ha ingresado exitosamente.' }
        format.json { render json: @flickr_datum, status: :created, location: @flickr_datum }
      else
        format.html { render action: "new" }
        format.json { render json: @flickr_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @flickr_datum = FlickrDatum.find(params[:id])

    respond_to do |format|
      if @flickr_datum.update_attributes(params[:flickr_datum])
        @flickr_datum.new_contacts = FlickrDatum.get_new_contacts(@flickr_datum)
        @flickr_datum.save!
        format.html { redirect_to flickr_index_path(@flickr_datum.client_id,1,@flickr_datum.social_network_id), notice: 'La informacion ha sido actualizada exitosamente.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @flickr_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @flickr_datum = FlickrDatum.find(params[:id])
    client_id = @flickr_datum.client_id
    social_id = @flickr_datum.social_network_id
    @flickr_datum.destroy

    respond_to do |format|
      format.html { redirect_to flickr_index_path(@flickr_datum.client_id,1,social_id), notice: 'La informacion ha sido borrada exitosamente.' }
      format.json { head :ok }
    end
  end

  def save_comment
    comment = FlickrComment.find_by_social_network_id(params[:social_network].to_i)
    case params[:id_comment].to_i
      when 1
        comment.table = params[:comment]
      when 2
        comment.community = params[:comment]
      when 3
        comment.interaction = params[:comment]
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
