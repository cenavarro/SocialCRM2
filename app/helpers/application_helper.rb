module ApplicationHelper
  def get_start_date
    Date.new(Time.now.strftime('%Y').to_i,Time.now.strftime('%m').to_i,1).strftime('%d-%m-%Y')
  end

  def get_end_date
    Date.new(Time.now.strftime('%Y').to_i,Time.now.strftime('%m').to_i,1).strftime('%d-%m-%Y')
  end

  def admin_user?
    (current_user.rol_id == 1) ? (return true) : (return false)
  end

  def has_admin_credentials?
    admin_user? ? (return true) : (redirect_to root_path, notice: "No tiene los permisos necesarios para realizar esta accion!")
  end

end
