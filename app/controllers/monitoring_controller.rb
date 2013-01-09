class MonitoringController < ApplicationController
  before_filter :authenticate_user!
  before_filter :has_admin_credentials?, :except => [:index]


  def index
    if !has_comments_table?(MonitoringComment, params[:id_social])
      MonitoringComment.create!(:social_network_id => params[:id_social])
    end
    themes = Monitoring.where('social_network_id = ? and isTheme = ?', params[:id_social], true).order("name ASC")
    channels = Monitoring.where('social_network_id = ? and isTheme = ?', params[:id_social], false).order("name ASC")
    if getDataDateRange?(params)
      @datum = MonitoringData.where('start_date = ? and end_date = ? and monitoring_id = ?', 
                                    params[:start_date].to_date, params[:end_date].to_date, themes.first.id).order('start_date ASC')
    else
      @datum = MonitoringData.where('monitoring_id = ?', themes.first.id).order('start_date ASC')
    end
    create_all_data(themes, channels)
  end

  def new
    @themes = Monitoring.where('social_network_id = ? and isTheme = ?', params[:id_social], true).order("name ASC")
    @channels = Monitoring.where('social_network_id = ? and isTheme = ?', params[:id_social], false).order("name ASC")
  end

  def create
    monitoring_data = params[:monitoring]
    monitoring_data.each do |id, value|
      MonitoringData.create!({value: value, monitoring_id: id, start_date: params[:start_date], end_date: params[:end_date]})
    end
    respond_to do |format|
      format.html { redirect_to monitoring_index_path(params[:idc], 1, params[:id_social]), notice: "La informacion ha sido ingresada correctamente!" }
    end
  end

  def edit
    @themes = Monitoring.where('social_network_id = ? and isTheme = ?', params[:id_social], true).order("name ASC")
    @channels = Monitoring.where('social_network_id = ? and isTheme = ?', params[:id_social], false).order("name ASC")
  end

  def update
    monitoring_data = params[:monitoring]
    monitoring_data.each do |id , value|
      data = MonitoringData.find(id)
      data.update_attributes({start_date: params[:start_date], end_date: params[:end_date], value: value})
    end
    respond_to do |format|
      format.html { redirect_to monitoring_index_path(params[:client_id], 1, params[:social_network_id]), notice: "La informacion ha sido actualizada correctamente!" }
    end
  end

  def destroy
    data = MonitoringData.find(params[:id])
    datum = MonitoringData.where('start_date = ? and end_date =?', data.start_date, data.end_date)
    datum.delete_all
    respond_to do |format|
      format.html { redirect_to monitoring_index_path(params[:idc], 1, params[:id_social]), notice: "La informacion ha sido eliminada satisfactoriamente!" }
    end
  end

  private

  def create_all_data(themes, channels)
    @monitoring_data = {
      "total_days" => [],
      "theme_datum" => [],
      "channel_datum" => [],
      "change_volume_comments" => [],
      "daily_average" => [],
      "theme_total_comment" => [],
      "channel_total_comment" => []
    }
    @monitoring_data['dates'] = @datum.collect{|data| "#{data.start_date.strftime('%d %b')}-#{data.end_date.strftime('%d %b')}"}
    @datum.each do |data|
      @monitoring_data['total_days'] << ((data.end_date - data.start_date).to_i + 1)
    end
    create_theme_datum(themes)
    create_channel_datum(channels)
  end

  def create_theme_datum(themes)
    themes.each do |theme|
      @themes_datum = get_monitoring_data(theme.id)
      data = []
      index = 0
      @themes_datum.each do |datum|
        data << datum.value
        @monitoring_data['theme_total_comment'][index].nil? ? 
          (@monitoring_data['theme_total_comment'][index] = datum.value) : (@monitoring_data['theme_total_comment'][index] = @monitoring_data['theme_total_comment'][index] + datum.value)  
        index  = index + 1
      end
      @monitoring_data['theme_datum'] << {:name => theme.name, :data => data}
    end
  end

  def create_channel_datum(channels)
    channels.each do |channel|
      @channels_datum = get_monitoring_data(channel.id)
      data = []
      index = 0
      @channels_datum.each do |datum|
        data << datum.value
        if @monitoring_data['channel_total_comment'][index].nil? 
          @monitoring_data['channel_total_comment'][index] = datum.value
        else
          @monitoring_data['channel_total_comment'][index] = @monitoring_data['channel_total_comment'][index] + datum.value
        end
        index  = index + 1
      end
      @monitoring_data['channel_datum'] << {:name => channel.name, :data => data}
    end
  end

  def get_monitoring_data(id)
      if getDataDateRange?(params)
        MonitoringData.where('start_date >= ? and end_date <= ? and monitoring_id = ?', 
                                               params[:start_date].to_date, params[:end_date].to_date, id).order('start_date ASC')
      else
        MonitoringData.where('monitoring_id = ?', id).order('start_date ASC')
      end
  end

end
