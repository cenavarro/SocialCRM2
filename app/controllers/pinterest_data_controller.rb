class PinterestDataController < ApplicationController
  before_filter :authenticate_user!

  def createChartData
    @dates = @pinterest_datum.collect { |ld| "'" + ld.start_date.mday().to_s + "-" + ld.end_date.mday().to_s + " " + ld.end_date.strftime('%B') + "'" }.join(', ')
    @new_followers = @pinterest_datum.collect(&:new_followers).join(', ')
    @total_followers = @pinterest_datum.collect(&:total_followers).join(', ')
    @boards = @pinterest_datum.collect(&:boards).join(', ')
    @pins = @pinterest_datum.collect(&:pins).join(', ')
    @liked = @pinterest_datum.collect(&:liked).join(', ')
    @repin = @pinterest_datum.collect(&:repin).join(', ')
    @comment = @pinterest_datum.collect(&:comments).join(', ')
    @community_boards = @pinterest_datum.collect(&:community_boards).join(', ')
    @total_investment = @pinterest_datum.collect{ |pd| PinterestDatum.get_total_investment(pd) }.join(', ')
  end

  def index
    if existParamIdClient?
      if !getDataDateRange?
        @pinterest_datum = PinterestDatum.where('social_network_id = ?', params[:id_social]).order("start_date ASC")
      else
        fechaInicio = params[:start_date].to_date
        fechaFinal = params[:end_date].to_date
        @pinterest_datum = PinterestDatum.where('social_network_id = ? and start_date >= ? and end_date <= ?',params[:id_social], fechaInicio, fechaFinal).order("start_date ASC")
      end

      createChartData

      respond_to do |format|
        format.html 
        format.json { render json: @pinterest_datum }
      end
    else
      redirect_to root2_path
    end
  end

  def new
    @pinterest_datum = PinterestDatum.new

    respond_to do |format|
      format.html
      format.json { render json: @pinterest_datum }
    end
  end

  def edit
    @pinterest_datum = PinterestDatum.find(params[:id])
  end

  def create
    @pinterest_datum = PinterestDatum.new(params[:pinterest_datum])
    @pinterest_datum.new_followers = PinterestDatum.get_new_followers(@pinterest_datum)
    respond_to do |format|
      if @pinterest_datum.save
        format.html { redirect_to pinterest_index_path(@pinterest_datum.client_id,1,@pinterest_datum.social_network_id), notice: 'La informacion se ha ingresado exitosamente.' }
        format.json { render json: @pinterest_datum, status: :created, location: @pinterest_datum }
      else
        format.html { render action: "new" }
        format.json { render json: @pinterest_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @pinterest_datum = PinterestDatum.find(params[:id])

    respond_to do |format|
      if @pinterest_datum.update_attributes(params[:pinterest_datum])
        @pinterest_datum.new_followers = PinterestDatum.get_new_followers(@pinterest_datum)
        @pinterest_datum.save!
        format.html { redirect_to pinterest_index_path(@pinterest_datum.client_id,1,@pinterest_datum.social_network_id), notice: 'La informacion se ha ingresado exitosamente.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @pinterest_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @pinterest_datum = PinterestDatum.find(params[:id])
    client_id = @pinterest_datum.client_id
    social_id = @pinterest_datum.social_network_id
    @pinterest_datum.destroy

    respond_to do |format|
      format.html { redirect_to pinterest_index_path(@pinterest_datum.client_id,1,social_id), notice: 'La informacion ha sido borrada exitosamente.' }
      format.json { head :ok }
    end
  end

  def save_comment
    comment = PinterestComment.where(:social_network_id => params[:social_network].to_i)[0]
    case params[:id_comment].to_i
      when 1
        comment.table = params[:comment]
      when 2
        comment.comunity = params[:comment]
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
