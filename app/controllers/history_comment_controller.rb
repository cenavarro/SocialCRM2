class HistoryCommentController < ApplicationController
  before_filter :authenticate_user!
  before_filter :has_admin_credentials?

  def new
    comment = HistoryComment.new(params[:history_comment])
    comment.save! ? message = "El comentario se ha agregado exitosamente!" : message = "El comentario NO se ha podido guardar! Error: #{comment.errors.full_messages}"
    @social_network = SocialNetwork.find(params[:history_comment][:social_network_id])
    render :json => {
      html: render_to_string(:partial => 'layouts/comment_social_network', :locals => {:comment_id => params[:history_comment][:comment_id], :id_div => params[:id_div]}),
      id_div: params[:id_div],
      message: message
    }
  end

  def destroy
    comment = HistoryComment.find(params[:id])
    comment.destroy ? message = "El comentario se ha eliminado exitosamente!" : "El comentario NO se ha podido eliminar! Error: #{comment.errors.full_messages}" 
    respond_to do |format|
      format.html {redirect_to request.referer, notice: message}
    end
  end

end
