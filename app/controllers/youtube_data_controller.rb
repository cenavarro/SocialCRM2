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
    @report = Axlsx::Package.new
    start_date = "01-01-2012"
    end_date = "31-12-2012"
    FacebookDatum.generate_excel(@report, 2, start_date, end_date)
    BlogDatum.generate_excel(@report, 4, start_date, end_date)
    FlickrDatum.generate_excel(@report, 1, start_date, end_date)
    FoursquareDatum.generate_excel(@report, 6, start_date, end_date)
    GooglePlusDatum.generate_excel(@report, 7, start_date, end_date)
    LinkedinDatum.generate_excel(@report, 8, start_date, "08-11-2012")
    PinterestDatum.generate_excel(@report, 10, start_date, end_date)
    TuentiDatum.generate_excel(@report, 11, start_date, end_date)
    TumblrDatum.generate_excel(@report, 12, start_date, end_date)
    TwitterDatum.generate_excel(@report, 13, start_date, end_date)
    YoutubeDatum.generate_excel(@report, 14, start_date, end_date)
    @report.serialize('reporte.xlsx')
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

  def select_chart_data
    chart_data = {}
    chart_data['dates'] = @youtube_datum.collect{|yd| "#{yd.start_date.strftime('%d %b')} - #{yd.end_date.strftime('%d %b')}"}
    youtube_keys.each do |key|
      chart_data[key] = @youtube_datum.map(&:"#{key}")
    end
    return chart_data
  end

  def youtube_keys
    ['new_subscriber',
      'total_subscriber',
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
      'youtube_ads'
    ]
  end

end
