# encoding: utf-8
class SocialNetworksController < ApplicationController
  before_filter :authenticate_user!
  before_filter :has_admin_credentials?

  def index
    @social_networks = SocialNetwork.all
  end

  def new
    @social_network = SocialNetwork.new
  end

  def edit
    @social_network = SocialNetwork.find(params[:id])
    params[:isn] = @social_network.info_social_network_id
  end

  def create
    @social_network = SocialNetwork.new(params[:social_network])

    respond_to do |format|
      if @social_network.save
        format.html { redirect_to social_networks_path, notice: 'La Red Social se creo satisfactoriamente.' }
      else
        format.html { render action: "new" }
        format.json { render json: @social_network.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @social_network = SocialNetwork.find(params[:id])

    respond_to do |format|
      if @social_network.update_attributes(params[:social_network])
        format.html { redirect_to social_networks_path, notice: 'La Red Social se actualizo correctamente.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @social_network.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @social_network = SocialNetwork.find(params[:id])
    @social_network.destroy

    respond_to do |format|
      format.html { redirect_to social_networks_url, notice: 'La Red Social fue eliminada correctamente.' }
      format.json { head :ok }
    end
  end

  def create_campaign
    campaign = SocialNetwork.new(:name => params[:name], :client_id => params[:id_client], :info_social_network_id => InfoSocialNetwork.find_by_id_name('campaign').id)
    campaign.image = params[:image] if !params[:image].nil?
    if campaign.save!
      list = params[:criteria]
      list.each do |item|
        RowsCampaign.new(:name => item, :social_network_id => campaign.id).save!
      end
      respond_to do |format|
        format.html { redirect_to social_networks_path, notice: "La Campaña se ha creada exitosamente!"}
      end
    else
      respond_to do |format|
        format.html { redirect_to request.referer, notice: "La Campaña no se pudo crear!"}
      end
    end
  end

  def edit_campaign
    @campaign = SocialNetwork.find(params[:id])
  end

  def update_campaign
    @campaign = SocialNetwork.find(params[:id])
    @campaign.name = params[:name]
    @campaign.client_id = params[:id_client]
    rows_to_delete = RowsCampaign.where("id not in (?) and social_network_id = ?", params[:old].collect{|id,v| id}, @campaign.id)
    rows_to_delete.delete_all
    params[:old].each do |id, value|
      row_campaign = RowsCampaign.find(id)
      row_campaign.name = value
      row_campaign.save!
    end if !params[:old].nil?
    params[:new].each do |id, value|
      RowsCampaign.create(name: value, social_network_id: @campaign.id)
    end if !params[:new].nil?
    respond_to do |format|
      format.html { redirect_to social_networks_path, notice: "La Campaña se ha actualizado exitosamente!"}
    end
  end

  def create_monitoring
    monitoring = SocialNetwork.new(:name => params[:name], :client_id => params[:id_client], :info_social_network_id => InfoSocialNetwork.find_by_id_name('monitoring').id)
    monitoring.image = params[:image] if !params[:image].nil?
    if monitoring.save!
      themes = params[:themes]
      themes.each do |theme|
        Monitoring.new(social_network_id: monitoring.id, name: theme, isTheme: true).save!
      end
      channels = params[:channels]
      channels.each do |channel|
        Monitoring.new(social_network_id: monitoring.id, name: channel, isTheme: false).save!
      end
      respond_to do |format|
        format.html { redirect_to social_networks_path, notice: "El Monitoring se ha creado exitosamente!"}
      end
    else
      respond_to do |format|
        format.html { redirect_to request.referer, notice: "El Monitoring no se pudo crear!"}
      end
    end
  end

  def create_benchmark
    benchmark = SocialNetwork.new(params)
    benchmark.info_social_network_id = InfoSocialNetwork.find_by_id_name('benchmark').id
    params[:columns].split(/\r\n/)[0..7].each do |column|
      benchmark.benchmark_columns << BenchmarkColumn.new(name: column)
    end
    params[:rows].split(/\r\n/)[0..10].each do |row|
      benchmark.benchmark_competitor << BenchmarkCompetitor.new(name: row)
    end
    respond_to do |format|
      if benchmark.save!
        format.html { redirect_to social_networks_path, notice: "Benchmark se ha creado exitosamente!"}
      else
        format.html { redirect_to request.referer, notice: "Benchmark no se pudo crear!"}
      end
    end
  end

  def redirect
    option = params[:social_network]
    case option
      when 'facebook'
        redirect_url = "#{request.protocol}#{request.host_with_port}/#{params[:locale]}/clients/facebook/"
        app_id = SOCIAL_NETWORKS_CONFIG['facebook']['client_id'].to_s
        url = "https://www.facebook.com/dialog/oauth?client_id="+app_id+"&redirect_uri="+redirect_url+"&response_type=code&display=page&scope=email,manage_pages,read_insights,ads_management";
      when 'monitoring'
        url = social_networks_new_monitoring_path
      when 'campaign'
        url = social_networks_new_campaign_path
      when 'benchmark'
        url = social_networks_new_benchmark_path
      else
        url = social_networks_new_path(InfoSocialNetwork.find_by_id_name(option).id)
    end
    respond_to do |format|
      format.html { redirect_to url }
    end
  end

end
