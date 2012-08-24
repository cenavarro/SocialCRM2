class ClientsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @clients = Client.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @clients }
    end
  end

  def edit
    @client = Client.find(params[:id])
  end

  def update
    @client = Client.find(params[:id])
    @user = User.find(User.select(:id).where(:client_id => @client.id))
    @user.name = @client.name
    @user.save

    respond_to do |format|
      if @client.update_attributes(params[:client])
        format.html { redirect_to clients_path, notice: 'El Cliente fue actualizado correctamente.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @client = Client.find(params[:id])
    @user = User.find(User.select(:id).where(:client_id => @client.id))
    @user.destroy
    @client.destroy

    respond_to do |format|
      format.html { redirect_to clients_url, notice: 'Cliente se elimino correctamente.'}
      format.json { head :ok }
    end
  end

  def social_networks
    if params.has_key?(:idc)
      @client = Client.find(params[:idc])
      respond_to do|format|
        format.html
        format.json { render json: @client }
      end
    else
      redirect_to :controller => 'home', :action => 'index'
    end
  end

end
