class YoutubeDataController < ApplicationController
  before_filter :authenticate_user!
  before_filter :has_admin_credentials?, :except => [:index]

  def index
    if !has_comments_table?(YoutubeComment, params[:id_social])
      YoutubeComment.create!(:social_network_id => params[:id_social])
    end
    if !getDataDateRange?(params)
      @youtube_datum = YoutubeDatum.where('social_network_id = ?', params[:id_social]).order("start_date ASC")
    else 
      @youtube_datum = YoutubeDatum.where('social_network_id = ? and start_date >= ? and end_date <= ?',
        params[:id_social], params[:start_date].to_date, params[:end_date].to_date).order("start_date ASC")
    end
    @youtube = select_chart_data
  end

  def new
    @youtube_datum = YoutubeDatum.new
  end

  def edit
    @youtube_datum = YoutubeDatum.find(params[:id])
  end

  def create
    @youtube_datum = YoutubeDatum.new(params[:youtube_datum])

    respond_to do |format|
      if @youtube_datum.save
        format.html { redirect_to youtube_index_path(@youtube_datum.client_id,1,@youtube_datum.social_network_id), notice: 'La informacion se ha ingresado exitosamente.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @youtube_datum = YoutubeDatum.find(params[:id])

    respond_to do |format|
      if @youtube_datum.update_attributes(params[:youtube_datum])
        format.html { redirect_to youtube_index_path(@youtube_datum.client_id,1,@youtube_datum.social_network_id), notice: 'La informacion se ha actualizada exitosamente.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @youtube_datum = YoutubeDatum.find(params[:id])
    client_id = @youtube_datum.client_id
    social_id = @youtube_datum.social_network_id
    @youtube_datum.destroy

    respond_to do |format|
      format.html { redirect_to youtube_index_path(client_id,1,social_id), notice: 'La informacion ha sido borrada exitosamente.' }
    end
  end

  private

  def select_chart_data
    chart_data = {}
    chart_data['dates'] = @youtube_datum.collect{|yd| "#{yd.start_date.strftime('%d %b')} - #{yd.end_date.strftime('%d %b')}"}
    chart_data['new_subscribers'] = @youtube_datum.collect{|yd| yd.new_subscribers }
    chart_data['total_investment'] = @youtube_datum.collect{|yd| yd.total_investment }
    youtube_keys.each do |key|
      chart_data[key] = @youtube_datum.map(&:"#{key}")
    end
    return chart_data
  end

  def youtube_keys
    [ 'total_subscriber',
      'total_video_views',
      'inserted_player',
      'mobile_devise',
      'youtube_search',
      'youtube_suggestion',
      'youtube_page',
      'external_web_site',
      'google_search',
      'youtube_others',
      'youtube_subscriptions',
      'youtube_ads',
      'likes',
      'no_likes',
      'favorite',
      'comments',
      'shared'
    ]
  end

end
