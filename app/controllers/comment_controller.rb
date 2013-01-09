class CommentController < ApplicationController
  before_filter :authenticate_user!
  before_filter :has_admin_credentials?, :except => [:index]

  def index
    first_comment = Comment.where("social_network_id = ?", params[:id_social]).order("start_date DESC").order("end_date DESC").first
    start_date = end_date = nil
    if !first_comment.nil?
      start_date = first_comment.start_date
      end_date = first_comment.end_date
    end
    @comments = Comment.where("social_network_id = ? and start_date = ? and end_date = ?", params[:id_social], start_date, end_date).order("start_date DESC").order("end_date DESC")
    @old_comments = Comment.where("social_network_id = ? and start_date < ?", params[:id_social], start_date).order("start_date DESC").order("end_date DESC")
  end

  def edit
    @comment = Comment.find(params[:id])
  end

  def update
    @comment = Comment.find(params[:id])
    @comment.start_date = params[:start_date]
    @comment.end_date = params[:end_date]
    @comment.social_network_name = params[:social_network_name]
    @comment.comment_type = params[:comment_type]
    respond_to do |format|
      if @comment.save!
        update_list_comments
        format.html { redirect_to comment_index_path(params[:client_id], 1, params[:social_network_id]), notice: 'La informacion se ha actualizado exitosamente.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def create
    comment = Comment.new(client_id: params[:client_id], social_network_id: params[:social_network_id], comment_type: params[:comment_type], 
                          start_date: params[:start_date], end_date: params[:end_date], social_network_name: params[:social_network_name])
    respond_to do |format|
      if comment.save!
        create_list_comments(comment)
        format.html { redirect_to comment_index_path(params[:client_id], 1, params[:social_network_id]), notice: 'La informacion se ha ingresado exitosamente.' }
      else
        format.html { render action: "new" } 
      end
    end
  end

  def destroy
    comment = Comment.find(params[:id])
    client_id = comment.client_id
    social_id = comment.social_network_id
    comment.destroy
    respond_to do |format|
      format.html { redirect_to comment_index_path(client_id, 1, social_id), notice: 'La informacion ha sido borrada exitosamente.' }
    end
  end

  private

  def create_list_comments(comment)
    params.each do |param|
      if param[0].start_with?("comment") and not param[0] == "comment_type"
        id = param[0][8..param[0].size]
        comment.list_comments.create(comment_id: comment.id, content: param[1], link: params["link_#{id}".to_sym])
      end
    end
  end

  def update_list_comments
    params.each do |param|
      if param[0].start_with?("comment") and not param[0] == "comment_type"
        id = param[0][8..param[0].size]
        list_comment = ListComment.find(id)
        list_comment.content = param[1]
        list_comment.link = params["link_#{id}".to_sym]
        list_comment.save!
      end
    end
  end
end
