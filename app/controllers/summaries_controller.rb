class SummariesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :has_admin_credentials?, :except => [:index]

  def index
    summary = Summary.find_by_social_network_id(params[:id_social])
    @summary_comments = summary.summary_comments
  end

  def new
    @summary = Summary.new
  end

  def edit
    @summary = Summary.find(params[:id])
  end

  def create
    @summary = Summary.new(params[:summary])

    respond_to do |format|
      if @summary.save
        format.html { redirect_to @summary, notice: 'Summary was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @summary = Summary.find(params[:id])

    respond_to do |format|
      if @summary.update_attributes(params[:summary])
        format.html { redirect_to @summary, notice: 'Summary was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @summary = Summary.find(params[:id])
    @summary.destroy

    respond_to do |format|
      format.html { redirect_to summaries_url }
    end
  end
end
