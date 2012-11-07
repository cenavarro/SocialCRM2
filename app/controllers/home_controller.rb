class HomeController < ApplicationController

  def index
    if !user_signed_in?
      redirect_to new_user_session_path
    else
      if current_user.rol_id == 2 
        session[:client_id] = get_client_id(current_user.id)
        redirect_to clients_social_networks_path(session[:client_id].to_i)
      else
        @clients = Client.all
        respond_to do |format|
          format.html
          format.json
        end
      end
    end
  end

  private

    def get_client_id(user_id)
      return User.find(user_id).client_id
    end

end
