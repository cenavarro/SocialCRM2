class TuentiDataController < ApplicationController
  before_filter :authenticate_user!

  def index
    if !has_comments_table?(TuentiComment, params[:id_social])
      TuentiComment.create!(:social_network_id => params[:id_social])
    end
    if !getDataDateRange?(params)
      @tuenti_datum = TuentiDatum.where('social_network_id = ?', params[:id_social]).order("start_date ASC")
    else
      fechaInicio = params[:start_date].to_date
      fechaFinal = params[:end_date].to_date
      @tuenti_datum = TuentiDatum.where('social_network_id = ? and start_date >= ? and end_date <= ?',params[:id_social], fechaInicio, fechaFinal).order("start_date ASC")
    end

    create_chart_data

    respond_to do |format|
      format.html
    end
  end


  def new
    @tuenti_datum = TuentiDatum.new

    respond_to do |format|
      format.html
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
      else
        format.html { render action: "new" }
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
      else
        format.html { render action: "edit" }
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
    end
  end


  def save_comment
    comment = TuentiComment.where(:social_network_id => params[:social_network].to_i)[0]
    message = (t 'comments.fail')
    if comment.update_attributes({params[:id_comment] => params[:comment]})
      message = (t 'comments.success')
    end
    render :json => message.to_json
  end

  def create_chart_data
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

end
