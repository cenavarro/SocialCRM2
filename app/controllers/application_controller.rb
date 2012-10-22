class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_locale

  def set_locale
    I18n.locale = params[:locale] if params.include?('locale')
  end 

  def default_url_options
    {:locale => I18n.locale}
  end

  def has_comments_table?(model, social_network_id)
    model.find_by_social_network_id(social_network_id)
  end

  def getDataDateRange?(parameters)
    (parameters[:opcion].to_i == 2) ? (return true) : (return false)
  end

  def admin_user?
    (current_user.rol_id == 1) ? (return true) : (return false)
  end

  def has_admin_credentials?
    admin_user? ? (return true) : (redirect_to root_path, notice: "No tiene los permisos necesarios para realizar esta accion!")
  end
end
