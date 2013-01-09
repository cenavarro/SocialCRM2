class BlogDataController < ApplicationController
  before_filter :authenticate_user!
  before_filter :has_admin_credentials?, :except => [:index]

  def index
    if !has_comments_table?(BlogComment, params[:id_social])
      BlogComment.create!(:social_network_id => params[:id_social])
    end
    if !getDataDateRange?(params)
      @blog_datum = BlogDatum.where('social_network_id = ?', params[:id_social]).order("start_date ASC")
    else
      @blog_datum = BlogDatum.where('social_network_id = ? and start_date >= ? and end_date <= ?',params[:id_social], 
        params[:start_date].to_date, params[:end_date].to_date).order("start_date ASC")
    end
    create_chart_data
  end

  def new
    @blog_datum = BlogDatum.new
  end

  def edit
    @blog_datum = BlogDatum.find(params[:id])
  end

  def create
    @blog_datum = BlogDatum.new(params[:blog_datum])
    respond_to do |format|
      if @blog_datum.save
        format.html { redirect_to blog_index_path(@blog_datum.client_id,1,@blog_datum.social_network_id), notice: 'La informacion se ha ingresado exitosamente.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @blog_datum = BlogDatum.find(params[:id])
    respond_to do |format|
      if @blog_datum.update_attributes(params[:blog_datum])
        format.html { redirect_to blog_index_path(@blog_datum.client_id,1,@blog_datum.social_network_id), notice: 'La informacion ha sido actualizada exitosamente.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @blog_datum = BlogDatum.find(params[:id])
    client_id = @blog_datum.client_id
    social_id = @blog_datum.social_network_id
    @blog_datum.destroy

    respond_to do |format|
      format.html { redirect_to blog_index_path(client_id,1,social_id), notice: 'La informacion ha sido borrada exitosamente.' }
    end
  end

  private

  def create_chart_data
    @dates = @blog_datum.collect {|ld| "'" + ld.start_date.strftime('%d %b') + "-" + ld.end_date.strftime('%d %b') + "'"}.join(', ')
    @unique_visits = @blog_datum.collect(&:unique_visits).join(', ')
    @view_pages = @blog_datum.collect(&:view_pages).join(', ')
    @rebound_percent = @blog_datum.collect(&:rebound_percent).join(', ')
  end

end
