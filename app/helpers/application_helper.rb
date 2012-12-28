module ApplicationHelper
  def get_start_date
    Time.now.strftime('%d-%m-%Y')
  end

  def get_end_date
    Time.now.strftime('%d-%m-%Y')
  end

  def admin_user?
    (current_user.rol_id == 1) ? (return true) : (return false)
  end

  def has_admin_credentials?
    admin_user? ? (return true) : (redirect_to root_path, notice: "No tiene los permisos necesarios para realizar esta accion!")
  end

  def units_delimiter
    '.'
  end

  def decimal_separator
    ','
  end

  def decimal_precision
    2
  end

  def integer_format
    {delimiter: units_delimiter}
  end

  def decimal_format
    {delimiter: units_delimiter, separator: decimal_separator, precision: decimal_precision}
  end

end
