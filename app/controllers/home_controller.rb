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
    if current_user.rol_id == 2
      return true
    end
    return false
  end

  def change_language(language)
    if language == 'en'
      I18n.locale = 'en'
    else
      I18n.locale = 'es'
    end
    respond_to do | format |
      format.html { redirect_to request.referer}
    end
  end

end
