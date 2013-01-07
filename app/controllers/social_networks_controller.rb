# encoding: utf-8
class SocialNetworksController < ApplicationController
  before_filter :authenticate_user!
  before_filter :has_admin_credentials?

  def index
    @social_networks = SocialNetwork.all

    respond_to do |format|
      format.html
      format.json { render json: @social_networks }
    end
  end

  def new
    @social_network = SocialNetwork.new

    respond_to do |format|
      format.html
      format.json { render json: @social_network }
    end
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
      CampaignComment.new(:social_network_id => campaign.id).save!
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
    if benchmark.save!
      BenchmarkComment.new(:social_network_id => benchmark.id).save!
      competitors_list = params[:competitors]
      competitors_list.each do |competitor|
        BenchmarkCompetitor.new(:social_network_id => benchmark.id, :name => competitor).save!
      end
      respond_to do |format|
        format.html { redirect_to social_networks_path, notice: "Benchmark se ha creado exitosamente!"}
      end
    else
      respond_to do |format|
        format.html { redirect_to request.referer, notice: "Benchmark no se pudo crear!"}
      end
    end
  end

  def add_image
    image = ImagesSocialNetwork.new(params[:images])
    image.start_date = params[:images][:start_date]
    image.end_date = params[:images][:end_date]
    if image.save
      mensaje = "La imagen se guardo satisfactoriamente!"
    else
      mensaje = "La imagen no se pudo almacenar!<br><br> Errores:<br><br>".html_safe 
      image.errors.each do |type, error|
        mensaje = mensaje + type.to_s + ": " + error.to_s + "<br>".html_safe
      end
    end
    respond_to do | format |
      format.html {redirect_to request.referer, notice: mensaje}
    end
  end

  def update_comment_image
    image = ImagesSocialNetwork.find(params[:id_image].to_i)
    image.comment = params[:comment].to_s
    image.save! ? (msg = "Comentario Actualizado!") : (msg = "El comentario no se pudo actualizar!")

    respond_to do | format |
      format.json { render json: msg.to_json }
    end
  end

  def change_image
    image = ImagesSocialNetwork.find(params[:id].to_i)
    message = "La imagen no se ha podido actualizar!"
    image.attachment = params[:attachment]
    if image.save!
      message = "La imagen ha sido actualizada exitosamente!"
    end
    respond_to do | format |
      format.html {redirect_to request.referer, notice: message}
    end
  end

  def destroy_image
    image = ImagesSocialNetwork.find(params[:id])
    image.destroy ? (msg = "La imagen se elimino correctamente!") : (msg = "La imagen no se pudo eliminar!")
    respond_to do | format |
      format.html { redirect_to request.referer, notice: msg }
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
