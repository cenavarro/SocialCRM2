class NotificationsController < ApplicationController
  def index
  end


  require 'base64'

  def create
    p "Parametros:" + params.to_json
    user = User.find_by_email(params[:email])
    if !user.nil?
      token = Base64::encode64(user.email.to_s)
      user.reset_password_token = token
      user.save
      email = Notifier.gmail_message(user,token)
      p email
      email.deliver
      flash[:notice] = "Su correo ha sido enviado."
      redirect_to root_path
    else
      flash[:notice] = "No existe cuenta asociada con este correo."
      redirect_to '/notifications/index'
    end

  end

  def reset_password
    @user = User.find_by_reset_password_token(params[:token])
    if !@user.nil?
      @user.reset_password_token = nil
      @user.save
    end
    respond_to do | format |
      format.html
      format.json
    end
  end

end
