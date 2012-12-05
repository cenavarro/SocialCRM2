class FoursquareDataController < ApplicationController
  before_filter :authenticate_user!
  before_filter :has_admin_credentials?, :except => [:index]

  def index
    if !has_comments_table?(FoursquareComment, params[:id_social])
      FoursquareComment.new(:social_network_id => params[:id_social].to_i).save! 
    end
    if !getDataDateRange?(params)
      @foursquare_datum = FoursquareDatum.where('social_network_id = ?', params[:id_social]).order("start_date ASC")
    else
      @foursquare_datum = FoursquareDatum.where('social_network_id = ? and start_date >= ? and end_date <= ?',params[:id_social], params[:start_date].to_date, params[:end_date].to_date).order("start_date ASC")
    end
    @foursquare = select_chart_data
  end

  def new
    @foursquare_datum = FoursquareDatum.new
  end

  def edit
    @foursquare_datum = FoursquareDatum.find(params[:id])
  end

  def create
    @foursquare_datum = FoursquareDatum.new(params[:foursquare_datum])

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

  def select_chart_data
    chart_data = {}
    chart_data['dates'] = @foursquare_datum.collect {|fd| "#{fd.start_date.strftime('%d %b')} - #{fd.end_date.strftime('%d %b')}"}
    chart_data['new_followers'] = @foursquare_datum.collect { |fd| fd.new_followers }
    foursquare_keys.each do |key|
      chart_data[key] = @foursquare_datum.map(&:"#{key}")
    end
    return chart_data
  end

  def foursquare_keys
    [ 'total_followers',
      'clients',
      'checkins',
      'likes',
      'total_unlocks',
      'total_visits'
    ]
  end

end
