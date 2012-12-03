class NotificationsController < ApplicationController
  def index
  end

  require 'digest'

  def create
    user = User.find_by_email(params[:email])
    if !user.nil?
      token = Digest::SHA1.hexdigest([Time.now, rand].join)
      user.reset_password_token = token
      user.save
      email = Notifier.gmail_message(user,token)
      email.deliver
      flash[:notice] = "Su correo ha sido enviado."
      redirect_to root2_path
    else
      flash[:notice] = "No existe cuenta asociada con este correo."
      redirect_to notification_index_path
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
