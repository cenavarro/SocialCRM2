class TumblrDataController < ApplicationController
  before_filter :authenticate_user!
  before_filter :has_admin_credentials?, :except => [:index]

  def index
    if !has_comments_table?(TumblrComment, params[:id_social])
      TumblrComment.create!(:social_network_id => params[:id_social])
    end
    if !getDataDateRange?(params)
      @tumblr_datum = TumblrDatum.where('social_network_id = ?', params[:id_social]).order("start_date ASC")
    else
      fechaInicio = params[:start_date].to_date
      fechaFinal = params[:end_date].to_date
      @tumblr_datum = TumblrDatum.where('social_network_id = ? and start_date >= ? and end_date <= ?',params[:id_social], fechaInicio, fechaFinal).order("start_date ASC")
    end

    create_chart_data

    respond_to do |format|
      format.html
    end
  end

  def new
    @tumblr_datum = TumblrDatum.new

    respond_to do |format|
      format.html
    end
  end

  def edit
    @tumblr_datum = TumblrDatum.find(params[:id])
  end

  def create
    @tumblr_datum = TumblrDatum.new(params[:tumblr_datum])
    @tumblr_datum.new_followers = TumblrDatum.get_new_followers(@tumblr_datum)

    respond_to do |format|
      if @tumblr_datum.save
        format.html { redirect_to tumblr_index_path(@tumblr_datum.client_id, 1, @tumblr_datum.social_network_id), notice: 'La informacion se ha ingresado exitosamente.'}
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @tumblr_datum = TumblrDatum.find(params[:id])

    respond_to do |format|
      if @tumblr_datum.update_attributes(params[:tumblr_datum])
        @tumblr_datum.new_followers = TumblrDatum.get_new_followers(@tumblr_datum)
        @tumblr_datum.save!
        format.html { redirect_to tumblr_index_path(@tumblr_datum.client_id, 1, @tumblr_datum.social_network_id), notice: 'La informacion ha sido actualizada exitosamente.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @tumblr_datum = TumblrDatum.find(params[:id])
    client_id = @tumblr_datum.client_id
    social_id = @tumblr_datum.social_network_id
    @tumblr_datum.destroy

    respond_to do |format|
      format.html { redirect_to tumblr_index_path(client_id, 1, social_id), notice: 'La informacion ha sido borrada exitosamente.' }
    end
  end

  def save_comment
    comment = TumblrComment.find_by_social_network_id(params[:social_network].to_i)
    message = (t 'comments.fail')
    if comment.update_attributes({params[:id_comment] => params[:comment]})
      message = (t 'comments.success')
    end
    render :json => message.to_json
  end

  private

  def create_chart_data
    @dates = @tumblr_datum.collect {|ld| "'" + ld.start_date.strftime('%d %b') + "-" + ld.end_date.strftime('%d %b') + "'"}.join(', ')
    @new_followers = @tumblr_datum.collect(&:new_followers).join(', ')
    @total_followers = @tumblr_datum.collect(&:total_followers).join(', ')
    @likes = @tumblr_datum.collect(&:likes).join(', ')
    @reblogged = @tumblr_datum.collect(&:reblogged).join(', ')
    @total_investment = @tumblr_datum.collect{ |fd| TumblrDatum.get_total_investment(fd)}.join(', ')
  end

end
