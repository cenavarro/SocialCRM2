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

  def edit
    @social_network = SocialNetwork.find(params[:id])
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
end
