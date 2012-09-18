class HomeController < ApplicationController

  require 'open-uri'

  def index
    p "Idioma:" + I18n.locale.to_s
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
