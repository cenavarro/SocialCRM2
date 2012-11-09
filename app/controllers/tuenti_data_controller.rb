class TuentiDataController < ApplicationController
  before_filter :authenticate_user!
  before_filter :has_admin_credentials?, :except => [:index]

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
    @tuenti = select_chart_data
  end


  def new
    @tuenti_datum = TuentiDatum.new
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

  def select_chart_data
    chart_data = {}
    chart_data['dates'] = @tuenti_datum.collect{|td| "#{td.start_date.strftime('%d %b')} - #{td.end_date.strftime('%d %b')}"}
    tuenti_keys.each do |key|
      chart_data[key] = @tuenti_datum.map(&:"#{key}")
    end
    chart_data['total_investment'] = @tuenti_datum.collect{|td| TuentiDatum.get_total_investment(td)}
    return chart_data
  end

  def tuenti_keys
    ['new_fans',
      'real_fans',
      'goal_fans',
      'unique_total_users',
      'clics',
      'downloads',
      'comments',
      'upload_photos',
      'page_prints',
      'investment_agency',
      'investment_actions',
      'investment_ads',
      'cost_fan'
    ]
  end

end
