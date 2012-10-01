class TuentiDataController < ApplicationController
  before_filter :authenticate_user!

  def createChartData
    @dates = @tuenti_datum.collect { |td| "'" + td.start_date.strftime('%d %b') + "-" + td.end_date.strftime('%d %b') + "'" }.join(', ')
    @new_fans = @tuenti_datum.collect(&:new_fans).join(', ')
    @real_fans = @tuenti_datum.collect(&:real_fans).join(', ')
    @goal_fans = @tuenti_datum.collect(&:goal_fans).join(', ')
    @unique_users = @tuenti_datum.collect(&:unique_total_users).join(', ')
    @clics = @tuenti_datum.collect(&:clics).join(', ')
    @downloads = @tuenti_datum.collect(&:downloads).join(', ')
    @comment = @tuenti_datum.collect(&:comments).join(', ')
    @photos = @tuenti_datum.collect(&:upload_photos).join(', ')
    @page_prints = @tuenti_datum.collect(&:page_prints).join(', ')
    @agency_investment = @tuenti_datum.collect(&:investment_agency).join(', ')
    @actions_investment = @tuenti_datum.collect(&:investment_actions).join(', ')
    @ads_investment = @tuenti_datum.collect(&:investment_ads).join(', ')
    @total_investment = @tuenti_datum.collect{ |td| TuentiDatum.get_total_investment(td) }.join(', ')
    @fan_cost = @tuenti_datum.collect(&:cost_fan).join(', ')
  end

  def index
    if existParamIdClient?
      if !getDataDateRange?
        @tuenti_datum = TuentiDatum.where('social_network_id = ?', params[:id_social]).order("start_date ASC")
      else
        fechaInicio = params[:start_date].to_date
        fechaFinal = params[:end_date].to_date
        @tuenti_datum = TuentiDatum.where('social_network_id = ? and start_date >= ? and end_date <= ?',params[:id_social], fechaInicio, fechaFinal).order("start_date ASC")
      end

      createChartData

      respond_to do |format|
        format.html 
        format.json { render json: @tuenti_datum }
      end
    else
      redirect_to root2_path
    end
  end


  def new
    @tuenti_datum = TuentiDatum.new

    respond_to do |format|
      format.html
      format.json { render json: @tuenti_datum }
    end
  end

  def edit
    @tuenti_datum = TuentiDatum.find(params[:id])
  end

  def create
    @tuenti_datum = TuentiDatum.new(params[:tuenti_datum])

    respond_to do |format|
      if @tuenti_datum.save
        @tuenti_datum.new_fans = TuentiDatum.get_new_fans(@tuenti_datum)
        @tuenti_datum.cost_fan = TuentiDatum.get_cost_fan(@tuenti_datum)
        @tuenti_datum.save!
        format.html { redirect_to tuenti_index_path(@tuenti_datum.client_id,1,@tuenti_datum.social_network_id), notice: 'La informacion se ha ingresado exitosamente.' }
        format.json { render json: @tuenti_datum, status: :created, location: @tuenti_datum }
      else
        format.html { render action: "new" }
        format.json { render json: @tuenti_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @tuenti_datum = TuentiDatum.find(params[:id])

    respond_to do |format|
      if @tuenti_datum.update_attributes(params[:tuenti_datum])
        @tuenti_datum.new_fans = TuentiDatum.get_new_fans(@tuenti_datum)
        @tuenti_datum.cost_fan = TuentiDatum.get_cost_fan(@tuenti_datum)
        @tuenti_datum.save!
        format.html { redirect_to tuenti_index_path(@tuenti_datum.client_id,1,@tuenti_datum.social_network_id), notice: 'La informacion se ha actualizada exitosamente.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @tuenti_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @tuenti_datum = TuentiDatum.find(params[:id])
    client_id = @tuenti_datum.client_id
    social_id = @tuenti_datum.social_network_id
    @tuenti_datum.destroy

    respond_to do |format|
      format.html { redirect_to tuenti_index_path(client_id,1,social_id), notice: 'La informacion ha sido borrada exitosamente.' }
      format.json { head :ok }
    end
  end


  def save_comment
    comment = TuentiComment.where(:social_network_id => params[:social_network].to_i)[0]
    case params[:id_comment].to_i
      when 1
        comment.table = params[:comment]
      when 2
        comment.fans = params[:comment]
      when 3
        comment.interaction = params[:comment]
      when 4
        comment.reach = params[:comment]
      when 5
        comment.investment = params[:comment]
      when 6
        comment.cost = params[:comment]
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
