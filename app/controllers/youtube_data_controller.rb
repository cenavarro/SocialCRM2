class YoutubeDataController < ApplicationController
  before_filter :authenticate_user!

  def index
    if !has_comments_table?(YoutubeComment, params[:id_social])
      YoutubeComment.create!(:social_network_id => params[:id_social])
    end
    if !getDataDateRange?(params)
      @youtube_datum = YoutubeDatum.where('social_network_id = ?', params[:id_social]).order("start_date ASC")
    else
      fechaInicio = params[:start_date].to_date
      fechaFinal = params[:end_date].to_date
      @youtube_datum = YoutubeDatum.where('social_network_id = ? and start_date >= ? and end_date <= ?',params[:id_social], fechaInicio, fechaFinal).order("start_date ASC")
    end

    create_chart_data

    respond_to do |format|
      format.html 
    end
  end

  def new
    @youtube_datum = YoutubeDatum.new

    respond_to do |format|
      format.html
    end
  end

  def edit
    @youtube_datum = YoutubeDatum.find(params[:id])
  end

  def create
    @youtube_datum = YoutubeDatum.new(params[:youtube_datum])

    respond_to do |format|
      if @youtube_datum.save
        @youtube_datum.new_subscriber = YoutubeDatum.get_new_subscribers(@youtube_datum)
        @youtube_datum.save!
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
        @youtube_datum.new_subscriber = YoutubeDatum.get_new_subscribers(@youtube_datum)
        @youtube_datum.save!
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

  def save_comment
    comment = YoutubeComment.where(:social_network_id => params[:social_network].to_i)[0]
    message = (t 'comments.fail')
    if comment.update_attributes({params[:id_comment] => params[:comment]})
      message = (t 'comments.success')
    end
    render :json => message.to_json
  end

  private

  def create_chart_data
    @dates = @youtube_datum.collect { |ld| "'" + ld.start_date.mday().to_s + " " + ld.start_date.strftime('%b') + "-" + ld.end_date.mday().to_s + " " + ld.end_date.strftime('%b') + "'" }.join(', ')
    @new_subscribers = @youtube_datum.collect(&:new_subscriber).join(', ')
    @total_subscribers = @youtube_datum.collect(&:total_subscriber).join(', ')
    @total_views = @youtube_datum.collect(&:total_video_views).join(', ')
    @inserted_player = @youtube_datum.collect(&:inserted_player).join(', ')
    @mobile = @youtube_datum.collect(&:mobile_devise).join(', ')
    @youtube_search = @youtube_datum.collect(&:youtube_search).join(', ')
    @youtube_suggest = @youtube_datum.collect(&:youtube_suggestion).join(', ')
    @canal_page = @youtube_datum.collect(&:youtube_page).join(', ')
    @external_site = @youtube_datum.collect(&:external_web_site).join(', ')
    @google_search = @youtube_datum.collect(&:google_search).join(', ')
    @others = @youtube_datum.collect(&:youtube_others).join(', ')
    @subscriptions = @youtube_datum.collect(&:youtube_subscriptions).join(', ')
    @youtube_ads = @youtube_datum.collect(&:youtube_ads).join(', ')
  end

end
