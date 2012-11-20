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
      @tumblr_datum = TumblrDatum.where('social_network_id = ? and start_date >= ? and end_date <= ?',
                                        params[:id_social], params[:start_date].to_date, params[:end_date].to_date).order("start_date ASC")
    end

    @tumblr = select_chart_data
  end

  def new
    @tumblr_datum = TumblrDatum.new
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

  def select_chart_data
    chart_data = {
      "dates" => @tumblr_datum.collect {|td| "#{td.start_date.strftime('%d %b')} - #{td.end_date.strftime('%d %b')}"},
      "new_followers" => @tumblr_datum.map(&:new_followers),
      "total_followers" => @tumblr_datum.map(&:total_followers),
      "likes" => @tumblr_datum.map(&:likes),
      "reblogged" => @tumblr_datum.map(&:reblogged),
      "total_investment" => @tumblr_datum.collect{ |td| TumblrDatum.get_total_investment(td)}
    }
  end

end
