class HomeController < ApplicationController

  require 'open-uri'

  def index
    if !user_signed_in?
      redirect_to "/users/sign_in"
    else
      if isUserClient?
        redirect_to "/clients/social_networks?id="
      else
        p session.to_s
        p user_signed_in?
        p current_user
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

end
