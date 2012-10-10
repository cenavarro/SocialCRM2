# encoding: utf-8
class SocialNetworksController < ApplicationController
  before_filter :authenticate_user!

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

  def new_campaign
    respond_to do | format |
      format.html
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
        id_name = InfoSocialNetwork.find(@social_network.info_social_network_id).id_name
        case id_name 
          when 'facebook'
            comments = FacebookComment.new(:social_network_id => @social_network.id)
          when 'twitter'
            comments = TwitterComment.new(:social_network_id => @social_network.id)
          when 'linkedin'
            comments = LinkedinComment.new(:social_network_id => @social_network.id)
          when 'pinterest'
            comments = PinterestComment.new(:social_network_id => @social_network.id)
          when 'youtube'
            comments = YoutubeComment.new(:social_network_id => @social_network.id)
          when 'tuenti'
            comments = TuentiComment.new(:social_network_id => @social_network.id)
          when 'flickr'
            comments = FlickrComment.new(:social_network_id => @social_network.id)
          when 'google_plus'
            comments = GooglePlusComment.new(:social_network_id => @social_network.id)
          when 'blog'
            comments = BlogComment.new(:social_network_id => @social_network.id)
          when 'tumblr'
            comments = TumblrComment.new(:social_network_id => @social_network.id)
          when 'internal_monitoring'
            comments = InternalMonitoringComment.new(:social_network_id => @social_network.id)
        end
        comments.save if !comments.nil?
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
    campaign = SocialNetwork.new
    campaign.name = params[:name]
    campaign.client_id = params[:id_client]
    campaign.info_social_network_id = InfoSocialNetwork.find_by_id_name('campaign').id
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

  def create_internal_monitoring
    p "Parametros: #{params.to_json}"
    internal_monitoring = SocialNetwork.new
    internal_monitoring.name = params[:name]
    internal_monitoring.client_id = params[:id_client]
    internal_monitoring.info_social_network_id = InfoSocialNetwork.find_by_id_name('internal_monitoring').id
    if internal_monitoring.save!
      InternalMonitoringComment.new(:social_network_id => internal_monitoring.id).save!
      channel_list = params[:channels]
      channel_number = 1
      channel_list.each do |item|
        InternalMonitoringChannel.new(:social_network_id => internal_monitoring.id, :channel_number => channel_number, :title => item).save!
        channel_number = channel_number + 1
      end
      respond_to do |format|
        format.html { redirect_to social_networks_path, notice: "El Monitoreo Interno se ha creado exitosamente!"}
      end
    else
      respond_to do |format|
        format.html { redirect_to request.referer, notice: "El Monitoreo Interno NO se pudo crear!"}
      end
    end
  end

  def add_image
    image = ImagesSocialNetwork.new(params[:images])
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
      format.json {head :ok}
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

  def destroy_image
    image = ImagesSocialNetwork.find(params[:id])
    image.destroy ? (msg = "La imagen se elimino correctamente!") : (msg = "La imagen no se pudo eliminar!")
    respond_to do | format |
      format.html { redirect_to request.referer, notice: msg }
    end
  end
end
