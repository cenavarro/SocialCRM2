class BlogDataController < ApplicationController
  before_filter :authenticate_user!

  def createChartData
    @dates = @blog_datum.collect {|ld| "'" + ld.start_date.strftime('%d %b') + "-" + ld.end_date.strftime('%d %b') + "'"}.join(', ')
    @unique_visits = @blog_datum.collect(&:unique_visits).join(', ')
    @view_pages = @blog_datum.collect(&:view_pages).join(', ')
    @rebound_percent = @blog_datum.collect(&:rebound_percent).join(', ')
  end

  def index
    if existParamIdClient?
      if !getDataDateRange?
        @blog_datum = BlogDatum.where('social_network_id = ?', params[:id_social]).order("start_date ASC")
      else
        fechaInicio = params[:start_date].to_date
        fechaFinal = params[:end_date].to_date
        @blog_datum = BlogDatum.where('social_network_id = ? and start_date >= ? and end_date <= ?',params[:id_social], fechaInicio, fechaFinal).order("start_date ASC")
      end

      createChartData

      respond_to do |format|
        format.html 
        format.json { render json: @blog_datum }
      end
    else
      redirect_to root2_path
    end
  end

  def new
    @blog_datum = BlogDatum.new

    respond_to do |format|
      format.html
      format.json { render json: @blog_datum }
    end
  end

  def edit
    @blog_datum = BlogDatum.find(params[:id])
  end

  def create
    @blog_datum = BlogDatum.new(params[:blog_datum])

    respond_to do |format|
      if @blog_datum.save
        format.html { redirect_to blog_index_path(@blog_datum.client_id,1,@blog_datum.social_network_id), notice: 'La informacion se ha ingresado exitosamente.' }
        format.json { render json: @blog_datum, status: :created, location: @blog_datum }
      else
        format.html { render action: "new" }
        format.json { render json: @blog_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @blog_datum = BlogDatum.find(params[:id])

    respond_to do |format|
      if @blog_datum.update_attributes(params[:blog_datum])
        format.html { redirect_to blog_index_path(@blog_datum.client_id,1,@blog_datum.social_network_id), notice: 'La informacion ha sido actualizada exitosamente.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @blog_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @blog_datum = BlogDatum.find(params[:id])
    client_id = @blog_datum.client_id
    social_id = @blog_datum.social_network_id
    @blog_datum.destroy

    respond_to do |format|
      format.html { redirect_to blog_index_path(client_id,1,social_id), notice: 'La informacion ha sido borrada exitosamente.' }
      format.json { head :ok }
    end
  end

  def save_comment
    comment = BlogComment.find_by_social_network_id(params[:social_network].to_i)
    case params[:id_comment].to_i
      when 1
        comment.table = params[:comment]
      when 2
        comment.visits = params[:comment]
      when 3
        comment.percentages = params[:comment]
    end
    comment.save ? (mensaje =  "Comentario Guardado!") : (mensaje =  "El comentario no se pudo almacenar!")
    respond_to do | format |
      format.json { render json: mensaje.to_json }
    end
  end

  def existParamIdClient?
    params.has_key?(:idc) ? (return true) : (return false)
  end

  def getDataDateRange?
    (params[:opcion].to_i == 2) ? (return true) : (return false)
  end
end
