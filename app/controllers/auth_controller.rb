class AuthController < Devise::OmniauthCallbacksController 

  def google_oauth2
    auth = request.env["omniauth.auth"].info
    @user = User.find_by_email(auth.email)
    if !@user.nil?
      logger.info "Login con google: #{@user.email}"
      sign_in @user
      redirect_to root2_path 
    else
      logger.info "El login con google fallo porque el usuario no esta registrado en el sistema: #{auth}"
      flash[:notice] = "El usuario no tiene cuenta en el sitio."
      redirect_to new_user_session_url 
    end
  end


  def facebook
    auth = request.env["omniauth.auth"].info
    @user = User.find_by_email(auth.email)
    if !@user.nil?
      logger.info "Login con facebook: #{@user.email}"
      sign_in @user
      redirect_to root2_path 
    else
      logger.info "El login con facebook fallo porque el usuario no esta registrado en el sistema: #{auth}"
      flash[:notice] = "El usuario no tiene cuenta en el sitio."
      redirect_to new_user_session_url 
    end

  end
end
