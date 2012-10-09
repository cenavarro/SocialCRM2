class GooglePlusDataController < ApplicationController
  before_filter :authenticate_user!

  def createChartData
    @dates = @google_plus_datum.collect {|ld| "'" + ld.start_date.strftime('%d %b') + "-" + ld.end_date.strftime('%d %b') + "'"}.join(', ')
    @new_followers = @google_plus_datum.collect(&:new_followers).join(', ')
    @total_followers = @google_plus_datum.collect(&:total_followers).join(', ')
    @plus = @google_plus_datum.collect(&:plus).join(', ')
    @content_shared = @google_plus_datum.collect(&:content_shared).join(', ')
    @total_interactions = @google_plus_datum.collect{ |fd| GooglePlusDatum.get_total_interactions(fd)}.join(', ')
    @total_investment = @google_plus_datum.collect{ |fd| GooglePlusDatum.get_total_investment(fd)}.join(', ')
  end

  def index
    if existParamIdClient?
      if !getDataDateRange?
        @google_plus_datum = GooglePlusDatum.where('social_network_id = ?', params[:id_social]).order("start_date ASC")
      else
        fechaInicio = params[:start_date].to_date
        fechaFinal = params[:end_date].to_date
        @google_plus_datum = GooglePlusDatum.where('social_network_id = ? and start_date >= ? and end_date <= ?',params[:id_social], fechaInicio, fechaFinal).order("start_date ASC")
      end

      createChartData

      respond_to do |format|
        format.html 
        format.json { render json: @google_plus_datum }
      end
    else
      redirect_to root2_path
    end
  end

  def new
    @google_plus_datum = GooglePlusDatum.new

    respond_to do |format|
      format.html
      format.json { render json: @google_plus_datum }
    end
  end

  def edit
    @google_plus_datum = GooglePlusDatum.find(params[:id])
  end

  def create
    @google_plus_datum = GooglePlusDatum.new(params[:google_plus_datum])
    @google_plus_datum.new_followers = GooglePlusDatum.get_new_followers(@google_plus_datum)

    respond_to do |format|
      if @google_plus_datum.save
        format.html { redirect_to google_plus_index_path(@google_plus_datum.client_id,1,@google_plus_datum.social_network_id), notice: 'La informacion se ha ingresado exitosamente.' }
        format.json { render json: @google_plus_datum, status: :created, location: @google_plus_datum }
      else
        format.html { render action: "new" }
        format.json { render json: @google_plus_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @google_plus_datum = GooglePlusDatum.find(params[:id])

    respond_to do |format|
      if @google_plus_datum.update_attributes(params[:google_plus_datum])
        @google_plus_datum.new_followers = GooglePlusDatum.get_new_followers(@google_plus_datum)
        @google_plus_datum.save!
        format.html { redirect_to google_plus_index_path(@google_plus_datum.client_id,1,@google_plus_datum.social_network_id), notice: 'La informacion ha sido actualizada exitosamente.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @google_plus_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @google_plus_datum = GooglePlusDatum.find(params[:id])
    client_id = @google_plus_datum.client_id
    social_id = @google_plus_datum.social_network_id
    @google_plus_datum.destroy

    respond_to do |format|
      format.html { redirect_to google_plus_index_path(client_id,1,social_id), notice: 'La informacion ha sido borrada exitosamente.' }
      format.json { head :ok }
    end
  end

  def save_comment
    comment = GooglePlusComment.find_by_social_network_id(params[:social_network].to_i)
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
    comment.save! ? (msg = "Comentario Guardado!") : (msg = "El comentario no se pudo guardar!")
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
