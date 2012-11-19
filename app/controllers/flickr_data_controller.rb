class FlickrDataController < ApplicationController
  before_filter :authenticate_user!
  before_filter :has_admin_credentials?, :except => [:index]

  def index
    if !has_comments_table?(FlickrComment, params[:id_social])
      FlickrComment.create!(:social_network_id => params[:id_social])
    end
    if !getDataDateRange?(params)
      @flickr_datum = FlickrDatum.where('social_network_id = ?', params[:id_social]).order("start_date ASC")
    else
      @flickr_datum = FlickrDatum.where('social_network_id = ? and start_date >= ? and end_date <= ?',params[:id_social], 
         params[:start_date].to_date, params[:end_date].to_date).order("start_date ASC")
    end
    @flickr = select_chart_data
  end

  def new
    @flickr_datum = FlickrDatum.new
  end

  def edit
    @flickr_datum = FlickrDatum.find(params[:id])
  end

  def create
    @flickr_datum = FlickrDatum.new(params[:flickr_datum])
    @flickr_datum.new_contacts = FlickrDatum.get_new_contacts(@flickr_datum)
    respond_to do |format|
      if @flickr_datum.save
        format.html { redirect_to flickr_index_path(@flickr_datum.client_id,1,@flickr_datum.social_network_id), notice: 'La informacion se ha ingresado exitosamente.' }
        format.json { render json: @flickr_datum, status: :created, location: @flickr_datum }
      else
        format.html { render action: "new" }
        format.json { render json: @flickr_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @flickr_datum = FlickrDatum.find(params[:id])

    respond_to do |format|
      if @flickr_datum.update_attributes(params[:flickr_datum])
        @flickr_datum.new_contacts = FlickrDatum.get_new_contacts(@flickr_datum)
        @flickr_datum.save!
        format.html { redirect_to flickr_index_path(@flickr_datum.client_id,1,@flickr_datum.social_network_id), notice: 'La informacion ha sido actualizada exitosamente.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @flickr_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @flickr_datum = FlickrDatum.find(params[:id])
    client_id = @flickr_datum.client_id
    social_id = @flickr_datum.social_network_id
    @flickr_datum.destroy

    respond_to do |format|
      format.html { redirect_to flickr_index_path(client_id,1,social_id), notice: 'La informacion ha sido borrada exitosamente.' }
      format.json { head :ok }
    end
  end

  def save_comment
    comment = FlickrComment.find_by_social_network_id(params[:social_network].to_i)
    message = (t 'comments.fail')
    if comment.update_attributes({params[:id_comment] => params[:comment]})
      message = (t 'comments.success')
    end
    render :json => message.to_json
  end

  private

  def select_chart_data
    chart_data = {}
    flickr_keys.each do |key|
      chart_data[key] = @flickr_datum.map(&:"#{key}")
    end
    chart_data['dates'] = @flickr_datum.collect {|fd| "#{fd.start_date.strftime('%d %b')} - #{fd.end_date.strftime('%d %b')}"}
    chart_data['total_investment'] = @flickr_datum.collect{ |fd| FlickrDatum.get_total_investment(fd)}
    return chart_data
  end

  def flickr_keys
    ['new_contacts',
      'total_contacts',
      'visits',
      'comments',
      'favorites'
    ]
  end

end
