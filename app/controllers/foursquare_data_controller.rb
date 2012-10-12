class FoursquareDataController < ApplicationController
  before_filter :authenticate_user!

  def index
    if !has_comments_table?(FoursquareComment, params[:id_social])
      FoursquareComment.new(:social_network_id => params[:id_social].to_i).save! 
    end
    if !getDataDateRange?(params)
      @foursquare_datum = FoursquareDatum.where('social_network_id = ?', params[:id_social]).order("start_date ASC")
    else
      fechaInicio = params[:start_date].to_date
      fechaFinal = params[:end_date].to_date
      @foursquare_datum = FoursquareDatum.where('social_network_id = ? and start_date >= ? and end_date <= ?',params[:id_social], fechaInicio, fechaFinal).order("start_date ASC")
    end
    create_chart_data
    respond_to do |format|
      format.html
    end
  end

  def new
    @foursquare_datum = FoursquareDatum.new
    respond_to do |format|
      format.html
    end
  end

  def edit
    @foursquare_datum = FoursquareDatum.find(params[:id])
  end

  def create
    @foursquare_datum = FoursquareDatum.new(params[:foursquare_datum])
    @foursquare_datum.new_followers = FoursquareDatum.get_new_followers(@foursquare_datum)

    respond_to do |format|
      if @foursquare_datum.save
        format.html { redirect_to foursquare_index_path(@foursquare_datum.client_id, 1, @foursquare_datum.social_network_id), notice: 'La informacion se ha ingresado exitosamente.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @foursquare_datum = FoursquareDatum.find(params[:id])

    respond_to do |format|
      if @foursquare_datum.update_attributes(params[:foursquare_datum])
        @foursquare_datum.new_followers = FoursquareDatum.get_new_followers(@foursquare_datum)
        @foursquare_datum.save!
        format.html { redirect_to foursquare_index_path(@foursquare_datum.client_id, 1, @foursquare_datum.social_network_id), notice: 'La informacion ha sido actualizada exitosamente.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    foursquare_datum = FoursquareDatum.find(params[:id])
    client_id = foursquare_datum.client_id
    social_id = foursquare_datum.social_network_id
    foursquare_datum.destroy

    respond_to do |format|
      format.html { redirect_to foursquare_index_path(client_id, 1, social_id), notice: 'La informacion ha sido borrada exitosamente.' }
    end
  end

  def save_comment
    comment = FoursquareComment.find_by_social_network_id(params[:social_network].to_i)
    message = (t 'comments.fail')
    if comment.update_attributes({params[:id_comment] => params[:comment]})
      message = (t 'comments.success')
    end
    render :json => message.to_json
  end

  private

  def create_chart_data
    @dates = @foursquare_datum.collect {|ld| "'" + ld.start_date.strftime('%d %b') + "-" + ld.end_date.strftime('%d %b') + "'"}.join(', ')
    @followers = @foursquare_datum.collect(&:new_followers).join(', ')
    @total_followers = @foursquare_datum.collect(&:total_followers).join(', ')
    @unlocks = @foursquare_datum.collect(&:total_unlocks).join(', ')
    @visits = @foursquare_datum.collect(&:total_visits).join(', ')
  end

end
