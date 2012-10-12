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

end
