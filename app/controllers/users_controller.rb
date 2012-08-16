class UsersController < ApplicationController
  before_filter :authenticate_user!

  	def delete
  		@users = User.all
  		respond_to do |format|
  			format.html
  			format.json { render json: @users }
  		end
  	end

	def show
	  @user = User.find(params[:id])
	end

	def destroy
	  @user = User.find(params[:id])
	  if @user.id != 1
	  	@user.destroy
	  end
	  respond_to do |format|
	  	format.html { redirect_to users_delete_path, notice: 'El usuario "'+@user.name+'" se ha eliminado correctamente.'}
	  	format.json {head :ok}
	  end
	end

	def new
		respond_to do |format|
	  	format.html
	  	format.json {head :ok}
	  end
	end

	def create
		if params[:user_type].to_i == 2
		  @client = Client.new(:name => params[:name],:description => params[:description], :image => params[:image])
		  if @client.save
		  	add_user(@client.id)
		  else
		  	respond_to do |format|
			  	format.html { redirect_to "/users/new?option=2", notice: 'El Cliente "'+@client.name+'" no se pudo ingresar correctamente.'}
		  	  format.json {head :ok}
	  	  end
		  end
		else
			add_user(nil)
		end
		#@user = User.new(:email => params[:email], :password=> , :password_confirm=>, :name=>, :rol_id =>, :client_id =>)
	end

	def add_user(client_id)
		@user = User.new
		@user.name = params[:name].to_s
		@user.email = params[:email]['address'].to_s
		@user.password = params[:password].to_s
		@user.password_confirmation = params[:password_confirmation].to_s
		@user.rol_id = params[:user_type].to_i
		@user.client_id = client_id.to_i if client_id != nil
  	if @user.save
  		@mensaje = 'El Usuario "'+@user.name+'" se ha ingresado correctamente.'
  	else
  		@client.destroy if client_id != nil
  		@mensaje = 'El Usuario "'+@user.name+'" NO se ha ingresado correctamente. Error: ' + @user.errors.full_messages.first.to_s
  	end
  	respond_to do |format|
	  	format.html { redirect_to "/users/new?option="+params[:user_type], notice: @mensaje }
  	  format.json {head :ok}
	  end
	end
end
