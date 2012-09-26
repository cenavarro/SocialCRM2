class YoutubeDataController < ApplicationController
  before_filter :authenticate_user!

  def createChartData
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

  def index
    if existParamIdClient?
      if !getDataDateRange?
        @youtube_datum = YoutubeDatum.where('social_network_id = ?', params[:id_social]).order("start_date ASC")
      else
        fechaInicio = params[:start_date].to_date
        fechaFinal = params[:end_date].to_date
        @youtube_datum = YoutubeDatum.where('social_network_id = ? and start_date >= ? and end_date <= ?',params[:id_social], fechaInicio, fechaFinal).order("start_date ASC")
      end

      createChartData

      respond_to do |format|
        format.html 
        format.json { render json: @youtube_datum }
      end
    else
      redirect_to root2_path
    end
  end

  def new
    @youtube_datum = YoutubeDatum.new

    respond_to do |format|
      format.html
      format.json { render json: @youtube_datum }
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
        format.json { render json: @youtube_datum, status: :created, location: @youtube_datum }
      else
        format.html { render action: "new" }
        format.json { render json: @youtube_datum.errors, status: :unprocessable_entity }
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
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @youtube_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @youtube_datum = YoutubeDatum.find(params[:id])
    client_id = @youtube_datum.client_id
    social_id = @youtube_datum.social_network_id
    @youtube_datum.destroy

    respond_to do |format|
      format.html { redirect_to youtube_index_path(@youtube_datum.client_id,1,social_id), notice: 'La informacion ha sido borrada exitosamente.' }
      format.json { head :ok }
    end
  end

  def save_comment
    comment = YoutubeComment.where(:social_network_id => params[:social_network].to_i)[0]
    case params[:id_comment].to_i
      when 1
        comment.table = params[:comment]
      when 2
        comment.community = params[:comment]
      when 3
        comment.interaction = params[:comment]
    end
    if comment.save
        mensaje =  "Comentario Guardado!"
    else
        mensaje =  "El comentario no se pudo almacenar!"
    end
    respond_to do | format |
      format.json { render json: mensaje.to_json }
    end
  end

  def existParamIdClient?
    return true if params.has_key?(:idc)
    return false
  end  

  def getDataDateRange?
    return true if params[:opcion].to_i == 2
    return false
  end

end
