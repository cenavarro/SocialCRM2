class TuentiDataController < ApplicationController
  before_filter :authenticate_user!
  before_filter :has_admin_credentials?, :except => [:index]

  def index
    if !get_data_from_range_date?
      @tuenti_datum = TuentiDatum.where('social_network_id = ?', params[:id_social]).order("start_date ASC")
    else
      @tuenti_datum = TuentiDatum.where('social_network_id = ? and start_date >= ? and end_date <= ?',
                                        params[:id_social], params[:start_date].to_date, params[:end_date].to_date).order("start_date ASC")
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

  private

  def select_chart_data
    chart_data = {}
    chart_data['dates'] = @tuenti_datum.collect{|td| "#{td.start_date.strftime('%d %b')} - #{td.end_date.strftime('%d %b')}"}
    chart_data['new_fans'] = @tuenti_datum.collect{|td| td.new_fans }
    chart_data['cost_fan'] = @tuenti_datum.collect{|td| td.cost_fan.round(3) }
    chart_data['total_investment'] = @tuenti_datum.collect{|td| td.total_investment.round(3) }
    tuenti_keys.each do |key|
      chart_data[key] = @tuenti_datum.map(&:"#{key}")
    end
    return chart_data
  end

  def tuenti_keys
    [ 'real_fans',
      'goal_fans',
      'unique_total_users',
      'clics',
      'downloads',
      'comments',
      'upload_photos',
      'page_prints',
      'investment_agency',
      'investment_actions',
      'investment_ads'
    ]
  end

end
