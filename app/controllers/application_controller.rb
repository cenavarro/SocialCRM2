class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_locale, :except => [:change_language]

  def set_locale
    I18n.locale = params[:locale] if params.include?('locale')
  end 

  def default_url_options
    {:locale => I18n.locale}
  end

end
