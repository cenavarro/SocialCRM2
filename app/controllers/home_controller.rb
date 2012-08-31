class HomeController < ApplicationController
  before_filter :prepare_login_form

  def index
    if !user_signed_in?
      redirect_to "/users/sign_in"
    else
      if isUserClient?
        redirect_to "/clients/social_networks?id="
      else
        @clients = Client.all
        respond_to do |format|
          format.html
          format.json
        end
      end
    end
  end

  def isUserClient?
    if current_user.rol_id == 2
      return true
    end
    return false
  end

  def prepare_login_form
    unless user_signed_in?
      @login_resource = User.new
    end
  end
end
