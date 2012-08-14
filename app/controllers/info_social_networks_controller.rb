class InfoSocialNetworksController < ApplicationController
  before_filter :authenticate_user!
  # GET /info_social_networks
  # GET /info_social_networks.json
  def index
    @info_social_networks = InfoSocialNetwork.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @info_social_networks }
    end
  end

  # GET /info_social_networks/1
  # GET /info_social_networks/1.json
  def show
    @info_social_network = InfoSocialNetwork.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @info_social_network }
    end
  end

  # GET /info_social_networks/new
  # GET /info_social_networks/new.json
  def new
    @info_social_network = InfoSocialNetwork.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @info_social_network }
    end
  end

  # GET /info_social_networks/1/edit
  def edit
    @info_social_network = InfoSocialNetwork.find(params[:id])
  end

  # POST /info_social_networks
  # POST /info_social_networks.json
  def create
    @info_social_network = InfoSocialNetwork.new(params[:info_social_network])

    respond_to do |format|
      if @info_social_network.save
        format.html { redirect_to @info_social_network, notice: 'Info social network was successfully created.' }
        format.json { render json: @info_social_network, status: :created, location: @info_social_network }
      else
        format.html { render action: "new" }
        format.json { render json: @info_social_network.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /info_social_networks/1
  # PUT /info_social_networks/1.json
  def update
    @info_social_network = InfoSocialNetwork.find(params[:id])

    respond_to do |format|
      if @info_social_network.update_attributes(params[:info_social_network])
        format.html { redirect_to info_social_networks_url, notice: 'La Inforacion de la Red Social se actualizo correctamente.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @info_social_network.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /info_social_networks/1
  # DELETE /info_social_networks/1.json
  def destroy
    @info_social_network = InfoSocialNetwork.find(params[:id])
    @info_social_network.destroy

    respond_to do |format|
      format.html { redirect_to info_social_networks_url }
      format.json { head :ok }
    end
  end
end
