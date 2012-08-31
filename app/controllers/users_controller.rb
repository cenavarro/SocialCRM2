class UsersController < ApplicationController
  before_filter :authenticate_user!

	def delete
		@users = User.all
		respond_to do |format|
			format.html
			format.json { render json: @users }
		end
	end

	def destroy
	  @user = User.find(params[:id])
	  if @user.id != current_user.id
	  	@user.destroy
	  end
	  respond_to do |format|
	  	format.html { redirect_to users_delete_path, notice: 'El usuario se ha eliminado correctamente.'}
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
		  if params[:name] != ""
		    @client = Client.new(:name => params[:name],:description => params[:description], :image => params[:image])
		    @client.save
		  	add_user(@client.id)
		  else
		  	respond_to do |format|
			  	format.html { redirect_to "/users/new/2", notice: 'El Cliente NO se pudo ingresar correctamente.'}
		  	  format.json {head :ok}
	  	    end
		  end
		else
			add_user(nil)
		end
	end

	def add_user(client_id)
		@user = User.new
		@user.name = params[:name].to_s
		@user.email = params[:email].to_s
		@user.password = params[:password].to_s
		@user.password_confirmation = params[:password_confirmation].to_s
		@user.rol_id = params[:user_type].to_i
		@user.client_id = client_id.to_i if client_id != nil
  	if @user.save
  		if client_id == nil
  		  @mensaje = 'El Usuario se ha ingresado correctamente.'
  		else
  			@mensaje = 'El Cliente se ha ingresado correctamente.'
  		end
  	else
  		@client.destroy if client_id != nil
  		if client_id == nil
  		  @mensaje = 'El Usuario NO se ha ingresado correctamente. Error: ' + @user.errors.full_messages.first.to_s
  		else
  			@mensaje = 'El Cliente NO se ha ingresado correctamente. Error: ' + @user.errors.full_messages.first.to_s
  	  end
  	end
  	respond_to do |format|
	  	format.html { redirect_to %{/users/new/#{params[:user_type]}}, notice: @mensaje }
  	  format.json {head :ok}
	  end
	end
end
