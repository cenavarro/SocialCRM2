class LinkedinDataController < ApplicationController
  before_filter :authenticate_user!

  def createChartData
    @dates = @linkedin_data.collect { |ld| "'" + ld.start_date.mday().to_s + "-" + ld.end_date.mday().to_s + " " + ld.end_date.strftime('%B') + "'" }.join(', ')
    @new_followers = @linkedin_data.collect(&:new_followers).join(', ')
    @total_followers = @linkedin_data.collect(&:total_followers).join(', ')
    @summary = @linkedin_data.collect(&:summary).join(', ')
    @employment = @linkedin_data.collect(&:employment).join(', ')
    @products_services = @linkedin_data.collect(&:products_services).join(', ')
    @prints = @linkedin_data.collect(&:prints).join(', ')
    @clics = @linkedin_data.collect(&:clics).join(', ')
    @recommendation = @linkedin_data.collect(&:recommendation).join(', ')
    @shared = @linkedin_data.collect(&:shared).join(', ')
    @interest = @linkedin_data.collect(&:interest).join(', ')
  end

  def index
    if existParamIdClient?
      if !getDataDateRange?
        @linkedin_data = LinkedinDatum.order("start_date ASC")
      else
        fechaInicio = params[:start_date].to_date
        fechaFinal = params[:end_date].to_date
        @linkedin_data = LinkedinDatum.where(['start_date >= ? and end_date <= ? AND client_id = ?', fechaInicio,fechaFinal,params[:idc].to_i]).order("start_date ASC")
      end

      createChartData

      respond_to do |format|
        format.html
        format.json { render json: @linkedin_data }
      end
    else
      redirect_to :controller => 'home', :action => 'index'
    end
  end

  def new
    @linkedin_datum = LinkedinDatum.new

    respond_to do |format|
      format.html
      format.json { render json: @linkedin_datum }
    end
  end

  def edit
    @linkedin_datum = LinkedinDatum.find(params[:id])
  end

  def create
    @linkedin_datum = LinkedinDatum.new(params[:linkedin_datum])
    @linkedin_datum.total_followers = LinkedinDatum.get_total_followers(@linkedin_datum)
    respond_to do |format|
      if @linkedin_datum.save
        format.html { redirect_to %{/linkedin_data/#{@linkedin_datum.client_id}/1}, notice: 'La informacion se ha ingresado exitosamente.' }
        format.json { render json: @linkedin_datum, status: :created, location: @linkedin_datum }
      else
        format.html { render action: "new" }
        format.json { render json: @linkedin_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @linkedin_datum = LinkedinDatum.find(params[:id])
    @linkedin_datum.total_followers = LinkedinDatum.get_total_followers(@linkedin_datum)

    respond_to do |format|
      if @linkedin_datum.update_attributes(params[:linkedin_datum])
        format.html { redirect_to %{/linkedin_data/#{@twitter_datum.client_id}/1}, notice: 'La informacion ha sido actualizada exitosamente.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @linkedin_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @linkedin_datum = LinkedinDatum.find(params[:id])
    client_id = @linkedin_datum.client_id
    @linkedin_datum.destroy

    respond_to do |format|
      format.html { redirect_to %{/linkedin_data/#{client_id}/1}, notice: 'La informacion ha sido borrada exitosamente.' }
      format.json { head :ok }
    end
  end

  def save_comment
    comment = LinkedinComment.where(:social_network_id => params[:social_network].to_i)[0]
    case params[:id_comment].to_i
      when 1
        comment.table = params[:comment]
      when 2
        comment.comunity = params[:comment]
      when 3
        comment.interaction = params[:comment]
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
