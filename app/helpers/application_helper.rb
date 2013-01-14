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
    {delimiter: units_delimiter, separator: decimal_separator, precision: 0}
  end

  def decimal_format
    {delimiter: units_delimiter, separator: decimal_separator, precision: decimal_precision}
  end

  def date_with_format(date)
    date.strftime("%d-%m-%Y")
  end

  def history_comment_for type
    comments_history = HistoryComment.where(social_network_id: @social_network.id)
    comments_history.where(comment_id: type).order("start_date DESC").order("end_date DESC")
  end

  def number_with_precision number, options
    (!number.nil? and ((number % 1) == 0.0)) ? (options = {delimiter: units_delimiter, separator: decimal_separator, precision: 0}) : nil
    super
  end

end
