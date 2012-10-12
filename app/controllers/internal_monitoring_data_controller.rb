class InternalMonitoringDataController < ApplicationController

  def index
    if !has_comments_table?(InternalMonitoringComment, params[:id_social])
      InternalMonitoringComment.create!(:social_network_id => params[:id_social])
    end
    @channels = InternalMonitoringChannel.where('social_network_id = ?', params[:id_social]).order("channel_number ASC")
    if !getDataDateRange?(params)
      @internal_monitoring_data = InternalMonitoringDatum.where('social_network_id = ?', params[:id_social]).order("start_date ASC")
    else
      start_date = params[:start_date].to_date
      end_date = params[:end_date].to_date
      @internal_monitoring_data = InternalMonitoringDatum.where('social_network_id = ? and start_date >= ? and end_date <= ?',params[:id_social], start_date, end_date).order("start_date ASC")
    end
    create_chart_data
    respond_to do |format|
      format.html
    end
  end

  def new
    @internal_monitoring_data = InternalMonitoringDatum.new
    @channels = InternalMonitoringChannel.where("social_network_id = ?", params[:id_social]).order("channel_number ASC")

    respond_to do |format|
      format.html
    end
  end

  def edit
    @internal_monitoring_data = InternalMonitoringDatum.find(params[:id])
    @channels = InternalMonitoringChannel.where("social_network_id = ?", @internal_monitoring_data.social_network_id).order("channel_number ASC")
  end

  def create
    @internal_monitoring_datum = InternalMonitoringDatum.new(params[:internal_monitoring_datum])

    respond_to do |format|
      if @internal_monitoring_datum.save
        format.html { redirect_to internal_monitoring_index_path(@internal_monitoring_datum.client_id,1,@internal_monitoring_datum.social_network_id), notice: 'La informacion se ha ingresado exitosamente.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @internal_monitoring_datum = InternalMonitoringDatum.find(params[:id])

    respond_to do |format|
      if @internal_monitoring_datum.update_attributes(params[:internal_monitoring_datum])
        format.html { redirect_to internal_monitoring_index_path(@internal_monitoring_datum.client_id,1,@internal_monitoring_datum.social_network_id), notice: 'La informacion ha sido actualizada exitosamente.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @internal_monitoring_datum = InternalMonitoringDatum.find(params[:id])
    client_id = @internal_monitoring_datum.client_id
    social_network_id = @internal_monitoring_datum.social_network_id
    @internal_monitoring_datum.destroy

    respond_to do |format|
      format.html { redirect_to internal_monitoring_index_path(client_id, 1, social_network_id), notice: 'La informacion ha sido eliminada exitosamente.' }
    end
  end

  def save_comment
    comment = InternalMonitoringComment.where(:social_network_id => params[:social_network].to_i)[0]
    message = (t 'comments.fail')
    if comment.update_attributes({params[:id_comment] => params[:comment]})
      message = (t 'comments.success')
    end
    render :json => message.to_json
  end

  private

  def create_chart_data
    @dates = @internal_monitoring_data.collect {|ld| "'" + ld.start_date.strftime('%d %b') + "-" + ld.end_date.strftime('%d %b') + "'"}.join(', ')
    @complaints = @internal_monitoring_data.map(&:complaints)
    @client_att = @internal_monitoring_data.map(&:client_att)
    @lead = @internal_monitoring_data.map(&:lead)
    @engaged = @internal_monitoring_data.map(&:engaged)
    @curiosities = @internal_monitoring_data.map(&:curiosities)
    @mentions = @internal_monitoring_data.map(&:mentions)
    @feedback = @internal_monitoring_data.map(&:feedback)
  end

end
