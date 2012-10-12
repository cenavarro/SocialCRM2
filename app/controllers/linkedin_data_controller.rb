class LinkedinDataController < ApplicationController
  before_filter :authenticate_user!

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

    create_chart_data

    respond_to do |format|
      format.html
    end
  end

  def new
    @linkedin_data = LinkedinDatum.new

    respond_to do |format|
      format.html
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
      else
        format.html { render action: "new" }
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

  def create_chart_data
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

end
