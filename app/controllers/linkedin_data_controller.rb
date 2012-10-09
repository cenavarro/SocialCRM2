class LinkedinDataController < ApplicationController
  before_filter :authenticate_user!

  def createChartData
    @dates = @linkedin_data.collect {|ld| "'" + ld.start_date.strftime('%d %b') + "-" + ld.end_date.strftime('%d %b') + "'"}.join(', ')
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
        @linkedin_data = LinkedinDatum.where('social_network_id = ?', params[:id_social]).order("start_date ASC")
      else
        fechaInicio = params[:start_date].to_date
        fechaFinal = params[:end_date].to_date
        @linkedin_data = LinkedinDatum.where('social_network_id = ? and start_date >= ? and end_date <= ?',params[:id_social], fechaInicio, fechaFinal).order("start_date ASC")
      end

      createChartData

      respond_to do |format|
        format.html
        format.json { render json: @linkedin_data }
      end
    else
      redirect_to root2_path
    end
  end

  def new
    @linkedin_data = LinkedinDatum.new

    respond_to do |format|
      format.html
      format.json { render json: @linkedin_data }
    end
  end

  def edit
    @linkedin_data = LinkedinDatum.find(params[:id])
  end

  def create
    @linkedin_data = LinkedinDatum.new(params[:linkedin_datum])
    @linkedin_data.new_followers = LinkedinDatum.get_new_followers(@linkedin_data)
    respond_to do |format|
      if @linkedin_data.save
        format.html { redirect_to linkedin_index_path(@linkedin_data.client_id,1,@linkedin_data.social_network_id), notice: 'La informacion se ha ingresado exitosamente.' }
        format.json { render json: @linkedin_data, status: :created, location: @linkedin_data }
      else
        format.html { render action: "new" }
        format.json { render json: @linkedin_data.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @linkedin_data = LinkedinDatum.find(params[:id])
    respond_to do |format|
      if @linkedin_data.update_attributes(params[:linkedin_datum])
        @linkedin_data.new_followers = LinkedinDatum.get_new_followers(@linkedin_data)
        @linkedin_data.save!
        format.html { redirect_to linkedin_index_path(@linkedin_data.client_id,1,@linkedin_data.social_network_id), notice: 'La informacion ha sido actualizada exitosamente.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @linkedin_data.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @linkedin_data = LinkedinDatum.find(params[:id])
    client_id = @linkedin_data.client_id
    social_id = @linkedin_data.social_network_id
    @linkedin_data.destroy

    respond_to do |format|
      format.html { redirect_to linkedin_index_path(client_id,1,social_id), notice: 'La informacion ha sido borrada exitosamente.' }
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
