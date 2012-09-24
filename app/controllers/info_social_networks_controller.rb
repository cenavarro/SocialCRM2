class InfoSocialNetworksController < ApplicationController
  before_filter :authenticate_user!

  def index
    @info_social_networks = InfoSocialNetwork.all

    respond_to do |format|
      format.html
      format.json { render json: @info_social_networks }
    end
  end

  def new
    @info_social_network = InfoSocialNetwork.new

    respond_to do |format|
      format.html
      format.json { render json: @info_social_networks }
    end
  end

  def create
    info_social_network = InfoSocialNetwork.new(params[:info_social_network])
    if info_social_network.save!
      respond_to do | format |
        format.html {redirect_to info_social_network_path, notice: "La red se creo satisfactoriamente!"}
        format.json { head :ok }
      end
    else
      format.html { render action: "new" }
      format.json { render json: @info_social_network.errors, status: :unprocessable_entity }
    end
  end


  def edit
    @info_social_network = InfoSocialNetwork.find(params[:id])
  end

  def update
    @info_social_network = InfoSocialNetwork.find(params[:id])

    respond_to do |format|
      if @info_social_network.update_attributes(params[:info_social_network])
        format.html { redirect_to info_social_networks_url, notice: 'La Informacion de la Red Social se actualizo correctamente.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @info_social_network.errors, status: :unprocessable_entity }
      end
    end
  end
end
