class TwitterDataController < ApplicationController
  before_filter :authenticate_user!
  before_filter :has_admin_credentials?, :except => [:index]

  def index
    if !getDataDateRange?(params)
      @twitter_data = TwitterDatum.where('social_network_id = ?', params[:id_social]).order("start_date ASC")
    else 
      @twitter_data = TwitterDatum.where(['start_date >= ? and end_date <= ? and social_network_id = ?', 
                                         params[:start_date].to_date,params[:end_date].to_date,params[:id_social]]).order("start_date ASC")
    end
    @twitter = select_chart_data
  end

  def new
    @twitter_datum = TwitterDatum.new
  end

  def edit
    @twitter_datum = TwitterDatum.find(params[:id])
  end

  def create
    @twitter_datum = TwitterDatum.new(params[:twitter_datum])

    respond_to do |format|
      if @twitter_datum.save
        format.html { redirect_to twitter_index_path(@twitter_datum.client_id, 1, @twitter_datum.social_network_id), notice: 'La informacion se ha ingresado exitosamente.'}
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @twitter_datum = TwitterDatum.find(params[:id])

    respond_to do |format|
      if @twitter_datum.update_attributes(params[:twitter_datum])
        format.html { redirect_to twitter_index_path(@twitter_datum.client_id, 1, @twitter_datum.social_network_id), notice: 'La informacion ha sido actualizada exitosamente.' }
      else
        format.html { render action: "edit" }
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
    end
  end

  private

  def select_chart_data
    chart_data = {}
    chart_data['dates'] = @twitter_data.collect{|td| "#{td.start_date.strftime('%d %b')} - #{td.end_date.strftime('%d %b')}"}
    chart_data['total_investment'] = @twitter_data.collect { |td| td.total_investment }
    chart_data['cost_follower'] = @twitter_data.collect {|td| td.cost_follower }
    chart_data['cost_prints'] = @twitter_data.collect {|td| td.cost_per_prints }
    chart_data['cost_interactions'] = @twitter_data.collect {|td| td.cost_per_interaction }
    chart_data['new_followers'] = @twitter_data.collect {|td| td.new_followers }
    chart_data['total_interactions'] = @twitter_data.collect {|td| td.total_interactions }
    twitter_keys.each do |key|
      chart_data[key] = @twitter_data.map(&:"#{key}")
    end
    return chart_data
  end

  def getDataFromTwitter?
    (params[:opcion].to_i == 1) ? (return true) : (return false)
  end

  def twitter_keys
    [ 'total_followers',
      'goal_followers',
      'total_mentions',
      'ret_tweets',
      'total_clicks',
      'interactions_ads',
      'cost_twitter_ads'
    ]
  end

end
