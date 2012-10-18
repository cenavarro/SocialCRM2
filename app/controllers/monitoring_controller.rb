class MonitoringController < ApplicationController
  before_filter :authenticate_user!


  def index
    if !has_comments_table?(MonitoringComment, params[:id_social])
      MonitoringComment.create!(:social_network_id => params[:id_social])
    end
    @themes = Monitoring.where('social_network_id = ? and isTheme = ?', params[:id_social], true).order("name ASC")
    @channels = Monitoring.where('social_network_id = ? and isTheme = ?', params[:id_social], false).order("name ASC")
    if getDataDateRange?(params)
      @datum = MonitoringData.where('start_date = ? and end_date = ? and monitoring_id = ?', params[:start_date].to_date, params[:end_date].to_date, @themes.first.id).order('start_date ASC')
    else
      @datum = MonitoringData.where('monitoring_id = ?', @themes.first.id).order('start_date ASC')
    end
    create_chart_data
    respond_to do |format|
      format.html
    end
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

  def save_comment
    comment = MonitoringComment.find_by_social_network_id(params[:social_network])
    message = (t 'comments.fail')
    if comment.update_attributes({params[:id_comment] => params[:comment]})
      message = (t 'comments.success')
    end
    render :json => message.to_json
  end

  private

  def create_chart_data
    @dates = @datum.collect{|data| "'#{data.start_date.strftime('%d %b')}-#{data.end_date.strftime('%d %b')}'"}.join(', ')
  end

end
