class SummariesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :has_admin_credentials?, :except => [:index]

  def index
    if Summary.find_by_social_network_id(params[:id_social]).nil?
      Summary.create!(social_network_id: params[:id_social], client_id: params[:idc])
    end
    summary = Summary.find_by_social_network_id(params[:id_social])
    @summary_comments = summary.summary_comments
  end

  def new
    @summary_comment = SummaryComment.new
  end

  def edit
    @summary_comment = SummaryComment.find(params[:id])
  end

  def create
    @summary = Summary.find_by_social_network_id(params[:id_social])
    @summary.summary_comments.new(params[:summary_comment])

    respond_to do |format|
      if @summary.save
        format.html { redirect_to summary_index_path(params[:idc], 1, params[:id_social]), notice: 'La informacion se ha ingresado exitosamente!' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @summary_comment = SummaryComment.find(params[:id])

    respond_to do |format|
      if @summary_comment.update_attributes(params[:summary_comment])
        format.html { redirect_to summary_index_path(params[:idc], 1, params[:id_social]), notice: 'La informacion ha sido actualizada exitosamente!' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @summary_comment = SummaryComment.find(params[:id])
    @summary_comment.destroy

    respond_to do |format|
      format.html { redirect_to summary_index_path(params[:idc], 1 , params[:id_social]), notice: "La informacion ha sido eliminada exitosamente!"}
    end
  end
end
