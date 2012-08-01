class HomeController < ApplicationController
  before_filter :prepare_login_form
  
  def index
    @clients = Client.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @revisions }
    end
  end

  def prepare_login_form
    unless user_signed_in?
      @login_resource = User.new
    end
  end

end
