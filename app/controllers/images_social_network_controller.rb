class ImagesSocialNetworkController < ApplicationController
  before_filter :authenticate_user!
  before_filter :has_admin_credentials?

  def new
    image = ImagesSocialNetwork.new(params[:images])
    image.start_date = params[:images][:start_date]
    image.end_date = params[:images][:end_date]
    if image.save
      mensaje = "La imagen se guardo satisfactoriamente!"
    else
      mensaje = "La imagen no se pudo almacenar!<br><br> Errores:<br><br>".html_safe 
      image.errors.each do |type, error|
        mensaje = mensaje + type.to_s + ": " + error.to_s + "<br>".html_safe
      end
    end
    respond_to do | format |
      format.html {redirect_to request.referer, notice: mensaje}
    end
  end

  def update_comment
    image = ImagesSocialNetwork.find(params[:id_image].to_i)
    image.comment = params[:comment].to_s
    image.save! ? (msg = "Comentario Actualizado!") : (msg = "El comentario no se pudo actualizar!")
    respond_to do | format |
      format.json { render json: msg.to_json }
    end
  end

  def update
    image = ImagesSocialNetwork.find(params[:id].to_i)
    message = "La imagen no se ha podido actualizar!"
    image.attachment = params[:attachment]
    if image.save!
      message = "La imagen ha sido actualizada exitosamente!"
    end
    respond_to do | format |
      format.html {redirect_to request.referer, notice: message}
    end
  end

  def destroy
    image = ImagesSocialNetwork.find(params[:id])
    image.destroy ? (msg = "La imagen se elimino correctamente!") : (msg = "La imagen no se pudo eliminar!")
    respond_to do | format |
      format.html { redirect_to request.referer, notice: msg }
    end
  end

end

