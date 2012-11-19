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
    new_chart = (document.add_chart(Axlsx::Line3DChart, :start_at => [1, y_pos], :end_at => [chart_width, y_pos+height_chart], :title => title, :rotX => 0, :rotY => 0))
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

  def add_images_report(document, y_pos, social_id, styles)
    images = ImagesSocialNetwork.where(:social_network_id => social_id)
    images.each do |image|
      document.add_row ["",image.title], :style => styles['title'][1]
      img = File.expand_path(image.attachment.path, __FILE__)
      document.add_image(:image_src => img) do |sheet_image|
        sheet_image.width = 600
        sheet_image.height = 400
        sheet_image.start_at 1, y_pos
      end
      add_rows_report(document, 26)
      document.add_row ["", "Comentario"], :style => 3
      add_rows_report(document, 1)
      document.add_row ["", image.comment]
      add_rows_report(document, 12)
      y_pos = y_pos + 42
    end
  end

  def create_report_styles(workbook, size)
    styles = workbook.styles
    title_style = styles.add_style(:b => true, :sz => 14, :font_name => "Calibri")
    cell_header = styles.add_style(:bg_color => "FF0000", :border => {:style => :thin, :color => "FFFF0000"}, :font_name => "Calibri")
    dates_style = styles.add_style(:b => true, :bg_color => "000000", :fg_color => "FFFFFF", 
                                   :border => {:style => :thin, :color => "#FF000000"}, :sz => 9, :font_name => "Calibri")
    basic_style = styles.add_style(:border => {:style => :thin, :color => "#00000000"}, :sz => 11, :font_name => "Calibri")
    none_style = styles.add_style()
    styles_hash = {"title"=> [none_style], "header"=> [none_style], "dates"=> [none_style], "basic"=> [none_style]}
    for i in (1..size) do
      styles_hash['title'] << title_style
      styles_hash['header'] << cell_header
      styles_hash['dates'] << dates_style
      styles_hash['basic'] << basic_style
    end
    return styles_hash
  end

  def margins
    {:left => 0, :top => 0, :right => 0, :bottom => 0}
  end

  def page_setup
    {:orientation => :landscape, :paper_size => 9}
  end

  def height_cell
    return 20
  end

  def add_table(sheet, report_data, styles)
    add_rows_report(sheet, 2)
    report_data['table'].each do |key, data|
      if key.include?("header") || (key=="actions")
        sheet.add_row data, :style => styles['header'], :height => height_cell, :widths => report_data['widths']
      elsif key.include?("dates")
        sheet.add_row data, :style => styles['dates'], :height => height_cell
      else
        sheet.add_row data, :style => styles['basic'], :height => height_cell
      end
    end
    add_rows_report(sheet, 1)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.table]
  end

end
