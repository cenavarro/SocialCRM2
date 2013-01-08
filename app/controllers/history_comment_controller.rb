class HistoryCommentController < ApplicationController
  before_filter :authenticate_user!
  before_filter :has_admin_credentials?

  def new
    comment = HistoryComment.new(params[:history_comment])
    respond_to do |format|
      if comment.save!
        format.html {redirect_to request.referer, notice: "El comentario se ha agregado exitosamente!"} 
      else
        format.html {redirect_to request.referer, notice: "El comentario NO se ha podido guardar! Error: #{comment.errors.full_messages}"} 
      end
    end
  end

  def destroy
    comment = HistoryComment.find(params[:id])
    respond_to do |format|
      if comment.destroy
        format.html {redirect_to request.referer, notice: "El comentario se ha eliminado exitosamente!"} 
      else
        format.html {redirect_to request.referer, notice: "El comentario NO se ha podido eliminar! Error: #{comment.errors.full_messages}"} 
      end
    end
  end

end
