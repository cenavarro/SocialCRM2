class TumblrDataController < ApplicationController
  before_filter :authenticate_user!
  before_filter :has_admin_credentials?, :except => [:index]

  def index
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

  private

  def select_chart_data
    chart_data = {
      "dates" => @tumblr_datum.collect {|td| "#{td.start_date.strftime('%d %b')} - #{td.end_date.strftime('%d %b')}"},
      "new_followers" => @tumblr_datum.collect{ |td| td.new_followers },
      "total_followers" => @tumblr_datum.map(&:total_followers),
      "likes" => @tumblr_datum.map(&:likes),
      "reblogged" => @tumblr_datum.map(&:reblogged),
      "total_investment" => @tumblr_datum.collect{ |td| td.total_investment.round(3) }
    }
  end

end
