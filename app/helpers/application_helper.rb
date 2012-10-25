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

  def create_chart(document, y_pos,title, chart_width = 7, height_chart = 23)
    new_chart = (document.add_chart(Axlsx::Line3DChart, :start_at => [0, y_pos], :end_at => [chart_width, y_pos+height_chart], :title => title, :rotX => 10, :rotY => 10))
    new_chart.catAxis.gridlines = false
    new_chart.serAxis.delete = true
    return new_chart
  end

  def add_serie(chart, data, labels, title, style = nil)
    chart.add_series :data => data, :labels => labels, :title => title, :style => style
  end

  def add_rows_report(document, amount)
    for i in (1..amount)
      document.add_row
    end
  end

  def add_images_report(document, y_pos, social_id, style)
    images = ImagesSocialNetwork.where(:social_network_id => social_id)
    images.each do |image|
      document.add_row [image.title], :style => style
      img = File.expand_path(image.attachment.path, __FILE__)
      document.add_image(:image_src => img) do |sheet_image|
        sheet_image.width = 600 
        sheet_image.height = 400
        sheet_image.start_at 0, y_pos 
        add_rows_report(document, 28)
        y_pos = y_pos + 29
      end
    end
  end

  def create_report_styles(workbook)
    styles = workbook.styles
    title_style = styles.add_style(:b => true, :sz => 14)
    cell_header = styles.add_style(:bg_color => "FF0000", :border => {:style => :thin, :color => "FFFF0000"})
    dates_style = styles.add_style(:b => true, :bg_color => "000000", :fg_color => "FFFFFF", :border => {:style => :thin, :color => "#FF000000"})
    basic_style = styles.add_style(:border => {:style => :thin, :color => "#00000000"})
    styles_hash = {:title => title_style, :cell_header => cell_header, :dates => dates_style, :basic => basic_style}
    return styles_hash
  end
end
