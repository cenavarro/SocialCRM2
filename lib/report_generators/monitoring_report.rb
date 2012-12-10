class ReportGenerators::MonitoringReport < ReportGenerators::Base
  def self.can_process? type
    type == Monitoring
  end

  def is_empty?
    themes.empty? && channels.empty? 
  end

  def themes
    social_network.monitoring.where('isTheme = ?', true).order("name ASC")
  end

  def channels
    social_network.monitoring.where('isTheme = ?', false).order("name ASC")
  end

  def add_to(document)
    if !is_empty? && !themes.first.monitoring_data.empty? 
      @comments = social_network.monitoring_comment.first
      params = {themes: themes, channels: channels, start_date: start_date, end_date: end_date, datum: monitoring_datum}
      document.workbook do | wb |
        wb.add_worksheet(:name => social_network.name, :page_margins => margins, :page_setup => page_setup) do |sheet|
          @report_data = create_report_data(params)
          styles = create_report_styles(wb, @report_data['size'])
          add_rows_report(sheet, 6)
          sheet.add_row ['', "PAGINA DE MONITORING"], :style => 3
          @row = 7
          add_table_monitoring(sheet, styles)
          add_rows_report(sheet, 41-@row)
          add_charts(sheet)
          add_rows_report(sheet, 14)
          add_images_monitoring_report(sheet, 125, styles)
          sheet.column_widths 4, 27, 9, 9, 9, 9, 9, 9
          header(sheet, 0)
          footer(sheet, 40)
        end
      end
    end 
  end

  private

  def monitoring_datum
    social_network.monitoring.first.monitoring_data.where('start_date >= ? and end_date <= ?',
                     start_date.to_date, end_date.to_date).order('start_date ASC')
  end

  def create_report_data(params ={})
    datum = monitoring_datum
    monitoring_data = monitoring_hash
    monitoring_data['dates'] = datum.collect{|data| "'#{data.start_date.strftime('%d %b')}-#{data.end_date.strftime('%d %b')}'"}
    datum.each do |data|
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
    themes.each do |theme|
      themes_datum = social_network.monitoring.where("isTheme = ? and id = ?", true, theme.id).first.monitoring_data
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
    channels.each do |channel|
      channels_datum = social_network.monitoring.where("isTheme = ? and id = ?", false,channel.id).first.monitoring_data
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
    add_rows_report(sheet, 1)
    @report_data['dates'].unshift('').unshift('')
    sheet.add_row @report_data['dates'], :style => styles['dates'], :height => height_cell, :widths => @report_data['widths']
    sheet.add_row @report_data['theme_header'], :style => styles['header'], :height => 13
    @report_data['theme_datum'].each do |datum|
      sheet.add_row datum[:data].unshift(datum[:name]).unshift(''), :style => styles['basic'], :height => 13 
      @row = @row + 1
    end
    sheet.add_row @report_data['theme_total_comment'], :style => styles['basic'], :height => 13
    sheet.add_row @report_data['distribution_header'], :style => styles['header'], :height => 13
    @report_data['channel_datum'].each do |datum|
      sheet.add_row datum[:data].unshift(datum[:name]).unshift(''), :style => styles['basic'], :height => 13 
      @row = @row + 1
    end
    sheet.add_row @report_data['channel_total_comment'], :style => styles['basic'], :height => 13 
    for i in (3..@report_data['channel_total_comment'].size-1) do
      previous_data = @report_data['channel_total_comment'][i-1]
      actual_data = @report_data['channel_total_comment'][i]
      result = ((actual_data - previous_data).to_f/previous_data)*100
      @report_data['change_volume_comments'][i] = result.round(2)
    end
    for i in (2..@report_data['channel_total_comment'].size-1)
      @report_data['daily_average'][i] = (@report_data['channel_total_comment'][i] / @report_data['total_days'][i]).round(2)
    end
    sheet.add_row @report_data['change_volume_comments'], :style => styles['basic'], :height => 13 
    sheet.add_row @report_data['daily_average'], :style => styles['basic'], :height => 13
    add_rows_report(sheet, 1)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.table]
    @row = @row + 14 
  end

  def add_images_monitoring_report(document, y_pos, styles)
    images = ImagesSocialNetwork.where(:social_network_id => social_network.id)
    images.each do |image|
      header(document, y_pos)
      y_pos = y_pos + 10 
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
      y_pos = y_pos + 31
      footer(document, y_pos)
      add_rows_report(document, 12)
      y_pos = y_pos + 1
    end
  end

  def add_charts(sheet)
    add_rows_report(sheet, 9)
    sheet.add_row ["","GRAFICOS MONITORING"], :style => 3
    add_rows_report(sheet, 2)
    insert_themes_chart(sheet)
    add_rows_report(sheet, 13)
    insert_channels_chart(sheet)
    header(sheet, 41)
    footer(sheet, 82)
    header(sheet, 83)
    footer(sheet, 124)
  end

  def insert_themes_chart(sheet)
    chart = create_chart(sheet, 51, "Distribucion de los comentarios en canales", 8)
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
    chart = create_chart(sheet, 90, "Tipologia de comentarios", 8)
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
