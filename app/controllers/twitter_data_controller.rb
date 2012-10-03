class TwitterDataController < ApplicationController
  before_filter :authenticate_user!


  def createChartData
    @dates = @twitter_data.collect { |td| "'" + td.start_date.mday().to_s + " " + td.start_date.strftime('%b') + "-" + td.end_date.mday().to_s + " " + td.end_date.strftime('%b') + "'" }.join(', ')
    @new_followers = @twitter_data.collect(&:new_followers).join(', ')
    @total_followers = @twitter_data.collect(&:total_followers).join(', ')
    @goal_followers = @twitter_data.collect(&:goal_followers).join(', ')
    @mentions = @twitter_data.collect(&:total_mentions).join(', ')
    @retweets = @twitter_data.collect(&:ret_tweets).join(', ')
    @clics = @twitter_data.collect(&:total_clicks).join(', ')
    @interactions_ads = @twitter_data.collect(&:interactions_ads).join(', ')
    @total_interactions = @twitter_data.collect(&:total_interactions).join(', ')
    @total_investment = @twitter_data.collect { |td| TwitterDatum.get_total_investment(td)}.join(', ')
    @cost_per_engagement = @twitter_data.collect(&:cost_twitter_ads).join(', ')
    @cost_follower = @twitter_data.collect {|td| TwitterDatum.get_cost_follower(td)}.join(', ')
    @cost_prints = @twitter_data.collect {|td| TwitterDatum.get_cost_per_prints(td)}.join(', ')
    @cost_interactions = @twitter_data.collect {|td| TwitterDatum.get_cost_per_interaction(td)}.join(', ')
  end

  def index
    if existParamIdClient?
      if !getDataDateRange?
        @twitter_data = TwitterDatum.where('social_network_id = ?', params[:id_social]).order("start_date ASC")
      else
        fechaInicio = params[:start_date].to_date
        fechaFinal = params[:end_date].to_date
        @twitter_data = TwitterDatum.where(['start_date >= ? and end_date <= ? and social_network_id = ?', fechaInicio,fechaFinal,params[:id_social]]).order("start_date ASC")
      end

      createChartData

      respond_to do |format|
        format.html
        format.json { render json: @twitter_data }
      end
    else
      redirect_to root2_path 
    end
  end

  def new
    @twitter_datum = TwitterDatum.new
    respond_to do |format|
      format.html
      format.json { render json: @twitter_datum }
    end
  end

  def edit
    @twitter_datum = TwitterDatum.find(params[:id])
  end

  def create
    @twitter_datum = TwitterDatum.new(params[:twitter_datum])
    @twitter_datum.new_followers = TwitterDatum.get_new_followers(@twitter_datum)
    @twitter_datum.total_interactions = TwitterDatum.get_total_interactions(@twitter_datum)
    @twitter_datum.cost_follower = TwitterDatum.get_cost_follower(@twitter_datum)

    respond_to do |format|
      if @twitter_datum.save
        format.html { redirect_to twitter_index_path(@twitter_datum.client_id, 1, @twitter_datum.social_network_id), notice: 'La informacion se ha ingresado exitosamente.'}
        format.json { render json: @twitter_datum, status: :created, location: @twitter_datum }
      else
        format.html { render action: "new" }
        format.json { render json: @twitter_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @twitter_datum = TwitterDatum.find(params[:id])

    respond_to do |format|
      if @twitter_datum.update_attributes(params[:twitter_datum])
        @twitter_datum.new_followers = TwitterDatum.get_new_followers(@twitter_datum)
        @twitter_datum.total_interactions = TwitterDatum.get_total_interactions(@twitter_datum)
        @twitter_datum.cost_follower = TwitterDatum.get_cost_follower(@twitter_datum)
        @twitter_datum.save!
        format.html { redirect_to twitter_index_path(@twitter_datum.client_id, 1, @twitter_datum.social_network_id), notice: 'La informacion ha sido actualizada exitosamente.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @twitter_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @twitter_datum = TwitterDatum.find(params[:id])
    client_id = @twitter_datum.client_id
    social_id = @twitter_datum.social_network_id
    @twitter_datum.destroy

    respond_to do |format|
      format.html { redirect_to twitter_index_path(client_id, 1, social_id), notice: 'La informacion ha sido borrada exitosamente.' }
      format.json { head :ok }
    end
  end

  def save_comment
    comment = TwitterComment.where(:social_network_id => params[:social_network].to_i)[0]
    case params[:id_comment].to_i
      when 1
        comment.table = params[:comment]
      when 2
        comment.comunity = params[:comment]
      when 3
        comment.interaction = params[:comment]
      when 4
        comment.investment = params[:comment]
      when 5
        comment.cost = params[:comment]
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
    if params.has_key?(:idc)
      return true
    end
    return false
  end  

  def getDataFromTwitter?
    if params[:opcion].to_i == 1
      return true
    end
    return false
  end

  def getDataDateRange?
    if params[:opcion].to_i == 2
      return true
    end
    return false
  end

end
