class LinkedinDataController < ApplicationController
  before_filter :authenticate_user!
  before_filter :has_admin_credentials?, :except => [:index]

  def index
    if !has_comments_table?(LinkedinComment, params[:id_social])
      LinkedinComment.create!(:social_network_id => params[:id_social])
    end
    if !getDataDateRange?(params)
      @linkedin_data = LinkedinDatum.where('social_network_id = ?', params[:id_social]).order("start_date ASC")
    else
      fechaInicio = params[:start_date].to_date
      fechaFinal = params[:end_date].to_date
      @linkedin_data = LinkedinDatum.where('social_network_id = ? and start_date >= ? and end_date <= ?',params[:id_social], fechaInicio, fechaFinal).order("start_date ASC")
    end
    @linkedin = select_chart_data
  end

  def new
    @linkedin_data = LinkedinDatum.new
  end

  def edit
    @linkedin_data = LinkedinDatum.find(params[:id])
  end

  def create
    @linkedin_data = LinkedinDatum.new(params[:linkedin_datum])
    respond_to do |format|
      if @linkedin_data.save
        format.html { redirect_to linkedin_index_path(@linkedin_data.client_id,1,@linkedin_data.social_network_id), notice: 'La informacion se ha ingresado exitosamente.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @linkedin_data = LinkedinDatum.find(params[:id])
    respond_to do |format|
      if @linkedin_data.update_attributes(params[:linkedin_datum])
        format.html { redirect_to linkedin_index_path(@linkedin_data.client_id,1,@linkedin_data.social_network_id), notice: 'La informacion ha sido actualizada exitosamente.' }
      else
        format.html { render action: "edit" }
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
    end
  end

  def save_comment
    comment = LinkedinComment.where(:social_network_id => params[:social_network].to_i)[0]
    message = (t 'comments.fail')
    if comment.update_attributes({params[:id_comment] => params[:comment]})
      message = (t 'comments.success')
    end
    render :json => message.to_json
  end

  private

  def select_chart_data
    chart_data = {}
    chart_data['dates'] = @linkedin_data.collect {|ld| "#{ld.start_date.strftime('%d %b')} - #{ld.end_date.strftime('%d %b')}"}
    chart_data['new_followers'] = @linkedin_data.collect {|ld| ld.new_followers }
    chart_data['total_views'] = @linkedin_data.collect {|ld| ld.views_page }
    linkedin_keys.each do |key|
      chart_data[key] = @linkedin_data.map(&:"#{key}")
    end
    return chart_data
  end

  def linkedin_keys
    [ 'total_followers',
      'prints',
      'clics',
      'interest',
      'recommendation'
    ]
  end

end
