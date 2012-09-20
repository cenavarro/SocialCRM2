class AuthController < Devise::OmniauthCallbacksController 
  def google_oauth2
    auth = request.env["omniauth.auth"].info
    @user = User.find_by_email(auth.email)
    if !@user.nil?
      sign_in @user
      redirect_to root2_path 
    else
      flash[:notice] = "El usuario no tiene cuenta en el sitio."
      redirect_to new_user_session_url 
    end
  end


  def facebook
    auth = request.env["omniauth.auth"].info
    @user = User.find_by_email(auth.email)
    if !@user.nil?
      sign_in @user
      redirect_to root2_path 
    else
      flash[:notice] = "El usuario no tiene cuenta en el sitio."
      redirect_to new_user_session_url 
    end

  end
end
