class HomeController < ApplicationController

  require 'open-uri'

  def index
    if !user_signed_in?
      redirect_to new_user_session_path
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
    (current_user.rol_id == 2) ? (return true) : (return false)
  end

end
