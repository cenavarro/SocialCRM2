class ReportGenerators::MonitoringReport < ReportGenerators::Base
  def self.can_process? type
    type == Monitoring
  end

  def add_to(document)
    themes = social_network.monitoring.where('isTheme = ?', true).order("name ASC")
    if !themes.empty?
      @comments = social_network.monitoring_comment.first
      datum = get_monitoring_data(themes.first.id, start_date, end_date)
      channels = Monitoring.where('social_network_id = ? and isTheme = ?', social_network.id, false).order("name ASC")
      params = {themes: themes, channels: channels, start_date: start_date, end_date: end_date, datum: datum}
      document.workbook do | wb |
        wb.add_worksheet(:name => "Monitoring Interno-Externo", :page_margins => margins, :page_setup => page_setup) do |sheet|
          @report_data = create_report_data(params)
          styles = create_report_styles(wb, @report_data['size'])
          add_rows_report(sheet, 2)
          sheet.add_row ['', "PAGINA DE MONITORING"], :style => 3
          add_table_monitoring(sheet, styles)
          add_rows_report(sheet, 12)
          add_charts(sheet)
          add_rows_report(sheet, 14)
          add_images_monitoring_report(sheet, 123, styles)
        end
      end
    end 
  end

  private

  def get_monitoring_data(id, start_date, end_date)
      MonitoringData.where('start_date >= ? and end_date <= ? and monitoring_id = ?', 
                     start_date.to_date, end_date.to_date, id).order('start_date ASC')
  end

  def create_report_data(params ={})
    monitoring_data = monitoring_hash
    monitoring_data['dates'] = params[:datum].collect{|data| "'#{data.start_date.strftime('%d %b')}-#{data.end_date.strftime('%d %b')}'"}
    params[:datum].each do |data|
      monitoring_data['total_days'] << ((data.end_date - data.start_date).to_i + 1)
    end
    monitoring_data = create_theme_datum(params, monitoring_data)
    monitoring_data = create_channel_datum(params, monitoring_data)
    monitoring_data['size'] = monitoring_data['dates'].size + 1
    monitoring_data['dates'].each do
      monitoring_data['theme_header'] << ''
      monitoring_data['distribution_header'] << ''
      monitoring_data['widths'] << 11
    end
    monitoring_data
  end

  def create_theme_datum(params, monitoring_data)
    params[:themes].each do |theme|
      themes_datum = get_monitoring_data(theme.id, params[:start_date], params[:end_date])
      data = []
      index = 2
      themes_datum.each do |datum|
        data << datum.value
        monitoring_data['theme_total_comment'][index].nil? ? 
          (monitoring_data['theme_total_comment'][index] = datum.value) : 
          (monitoring_data['theme_total_comment'][index] = monitoring_data['theme_total_comment'][index] + datum.value)  
        index  = index + 1
      end
      monitoring_data['theme_datum'] << {:name => theme.name, :data => data}
    end
    monitoring_data
  end

  def create_channel_datum(params, monitoring_data)
    params[:channels].each do |channel|
      channels_datum = get_monitoring_data(channel.id, params[:start_date], params[:end_date])
      data = []
      index = 2
      channels_datum.each do |datum|
        data << datum.value
        if monitoring_data['channel_total_comment'][index].nil? 
          monitoring_data['channel_total_comment'][index] = datum.value
        else
          monitoring_data['channel_total_comment'][index] = monitoring_data['channel_total_comment'][index] + datum.value
        end
        index  = index + 1
      end
      monitoring_data['channel_datum'] << {:name => channel.name, :data => data}
    end
    monitoring_data
  end

  def add_table_monitoring(sheet, styles)
    add_rows_report(sheet, 2)
    @report_data['dates'].unshift('').unshift('')
    sheet.add_row @report_data['dates'], :style => styles['dates'], :height => height_cell, :widths => @report_data['widths']
    sheet.add_row @report_data['theme_header'], :style => styles['header'], :height => height_cell
    @report_data['theme_datum'].each do |datum|
      sheet.add_row datum[:data].unshift(datum[:name]).unshift(''), :style => styles['basic'], :height => height_cell
    end
    sheet.add_row @report_data['theme_total_comment'], :style => styles['basic'], :height => height_cell
    sheet.add_row @report_data['distribution_header'], :style => styles['header'], :height => height_cell
    @report_data['channel_datum'].each do |datum|
      sheet.add_row datum[:data].unshift(datum[:name]).unshift(''), :style => styles['basic'], :height => height_cell
    end
    sheet.add_row @report_data['channel_total_comment'], :style => styles['basic'], :height => height_cell
    for i in (3..@report_data['channel_total_comment'].size-1) do
      previous_data = @report_data['channel_total_comment'][i-1]
      actual_data = @report_data['channel_total_comment'][i]
      result = ((actual_data - previous_data).to_f/previous_data)*100
      @report_data['change_volume_comments'][i] = result.round(2)
    end
    for i in (2..@report_data['channel_total_comment'].size-1)
      @report_data['daily_average'][i] = (@report_data['channel_total_comment'][i] / @report_data['total_days'][i]).round(2)
    end
    sheet.add_row @report_data['change_volume_comments'], :style => styles['basic'], :height => height_cell
    sheet.add_row @report_data['daily_average'], :style => styles['basic'], :height => height_cell
    add_rows_report(sheet, 1)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.table]
  end

  def add_images_monitoring_report(document, y_pos, styles)
    images = ImagesSocialNetwork.where(:social_network_id => social_network.id)
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

  def add_charts(sheet)
    sheet.add_row ["","GRAFICOS MONITORING"], :style => 3
    add_rows_report(sheet, 2)
    insert_themes_chart(sheet)
    add_rows_report(sheet, 13)
    insert_channels_chart(sheet)
  end

  def insert_themes_chart(sheet)
    chart = create_chart(sheet, 39, "Distribucion de los comentarios en canales", @report_data['widths'].size)
    @report_data['dates'].shift
    @report_data['dates'].shift
    @report_data['theme_datum'].each do |datum|
      datum[:data].shift
      datum[:data].shift
      add_serie(chart, datum[:data], @report_data['dates'], datum[:name])
    end
    add_rows_report(sheet, 24)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.distributions]
  end

  def insert_channels_chart(sheet)
    chart = create_chart(sheet, 79, "Tipologia de comentarios", @report_data['widths'].size)
    @report_data['channel_datum'].each do |datum|
      datum[:data].shift
      datum[:data].shift
      add_serie(chart, datum[:data], @report_data['dates'], datum[:name])
    end
    add_rows_report(sheet, 24)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.typology]
  end

  def monitoring_hash
    {
      "total_days" => ['',''],
      "theme_datum" => [],
      "channel_datum" => [],
      "change_volume_comments" => ['',' % cambio volumen total comentarios', '0'],
      "daily_average" => ['','Promedio Diario'],
      "theme_total_comment" => ['','Total Comentarios'],
      "channel_total_comment" => ['', 'Total Comentarios'],
      "theme_header" => ['','Temas'],
      "distribution_header" => ['','Distribucion de canales'],
      "widths" => [1, 11]
    }
  end
end
