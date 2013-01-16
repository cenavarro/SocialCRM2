# encoding: utf-8
class ReportGenerators::MonitoringReport < ReportGenerators::Base
  def self.can_process? type
    type == Monitoring
  end

  def add_to(document)
    if !is_empty? && !themes.first.monitoring_data.empty? 
      params = {themes: themes, channels: channels, start_date: start_date, end_date: end_date, datum: monitoring_datum}
      @report_data = create_report_data(params)
      set_headers_and_footers
      create_report(document)
      append_headers_and_footers
    end
  end

  private

  def is_empty?
    themes.empty? && channels.empty? 
  end

  def themes
    social_network.monitoring.where('isTheme = ?', true).order("name ASC")
  end

  def channels
    social_network.monitoring.where('isTheme = ?', false).order("name ASC")
  end

  def monitoring_datum
    social_network.monitoring.first.monitoring_data.where('start_date >= ? and end_date <= ?',
                     start_date.to_date, end_date.to_date).order('start_date ASC')
  end

  def create_report(document)
    set_workbook_and_worksheet(document)
    create_report_styles(@report_data['size'])
    append_rows_to_report 6
    @worksheet.add_row ['', "PÁGINA DE MONITORING"], :style => 3
    @row = 7
    add_table_monitoring
    append_rows_to_report(41 - @row)
    append_charts_to_report
    append_rows_to_report 14
    add_images_monitoring_report(125)
    @worksheet.column_widths 4, 27, 9, 9, 9, 9, 9, 9
  end

  def create_report_data(params ={})
    datum = monitoring_datum
    monitoring_data = monitoring_hash
    monitoring_data['dates'] = datum.collect{|data| "#{data.start_date.strftime('%d %b')}-#{data.end_date.strftime('%d %b')}"}
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
      themes_datum = social_network.monitoring.where("isTheme = ? and id = ?", true, theme.id).first.monitoring_data.where("start_date >= ? and end_date <= ?", start_date.to_date, end_date.to_date)
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
      channels_datum = social_network.monitoring.where("isTheme = ? and id = ?", false,channel.id).first.monitoring_data.where("start_date >= ? and end_date <= ?", start_date.to_date, end_date.to_date)
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

  def add_table_monitoring
    append_rows_to_report 1
    @report_data['dates'].unshift('').unshift('')
    @worksheet.add_row @report_data['dates'], :style => @styles['dates'], :height => height_cell
    @worksheet.add_row @report_data['theme_header'], :style => @styles['header'], :height => 13
    @report_data['theme_datum'].each do |datum|
      @worksheet.add_row datum[:data].unshift(datum[:name]).unshift(''), :style => @styles['basic'], :height => 13 
      @row = @row + 1
    end
    @worksheet.add_row @report_data['theme_total_comment'], :style => @styles['basic'], :height => 13
    @worksheet.add_row @report_data['distribution_header'], :style => @styles['header'], :height => 13
    @report_data['channel_datum'].each do |datum|
      @worksheet.add_row datum[:data].unshift(datum[:name]).unshift(''), :style => @styles['basic'], :height => 13 
      @row = @row + 1
    end
    @worksheet.add_row @report_data['channel_total_comment'], :style => @styles['basic'], :height => 13 
    for i in (3..@report_data['channel_total_comment'].size-1) do
      previous_data = @report_data['channel_total_comment'][i-1]
      actual_data = @report_data['channel_total_comment'][i]
      result = ((actual_data - previous_data).to_f/previous_data)*100
      @report_data['change_volume_comments'][i] = result.round(2)
    end
    for i in (2..@report_data['channel_total_comment'].size-1)
      @report_data['daily_average'][i] = (@report_data['channel_total_comment'][i] / @report_data['total_days'][2]).round(2)
    end
    @worksheet.add_row @report_data['change_volume_comments'], :style => @styles['basic'], :height => 13 
    @worksheet.add_row @report_data['daily_average'], :style => @styles['basic'], :height => 13
    append_rows_to_report 1
    @worksheet.add_row ["", "Comentario del consultor"], :style => 3
    append_rows_to_report 1
    @worksheet.add_row ["", history_comment_for(1).content] if !history_comment_for(1).nil?
    @row = @row + 14 
  end

  def add_images_monitoring_report(position)
    last_period_image = ImagesSocialNetwork.where(:social_network_id => social_network.id).order('start_date DESC').order('end_date DESC').first
    start_date_last_period = last_period_image.start_date if !last_period_image.nil?
    end_date_last_period = last_period_image.end_date if !last_period_image.nil?
    images = ImagesSocialNetwork.where('social_network_id = ? and start_date = ? and end_date = ?', social_network.id, start_date_last_period, end_date_last_period)
    images.each do |image|
      @headers << position
      position = position + 10
      @worksheet.add_row ["",image.title], :style => @styles['title'][1]
      img = File.expand_path(image.attachment.path, __FILE__)
      @worksheet.add_image(:image_src => img) do |sheet_image|
        sheet_image.width = 600
        sheet_image.height = 400
        sheet_image.start_at 1, position
      end
      append_rows_to_report 26
      @worksheet.add_row ["", "Comentario"], :style => 3
      append_rows_to_report 1
      @worksheet.add_row ["", image.comment]
      position = position + 32
      @footers << (position - 1)
      append_rows_to_report 12
    end
  end

  def append_charts_to_report
    append_rows_to_report 9
    @worksheet.add_row ["","GRÁFICOS MONITORING"], :style => 3
    append_rows_to_report 2
    append_themes_chart
    append_rows_to_report 13
    append_channels_chart
  end

  def append_themes_chart
    chart = create_chart(51, "Distribución de los comentarios en canales", 8)
    @report_data['dates'].shift
    @report_data['dates'].shift
    @report_data['theme_datum'].each do |datum|
      datum[:data].shift
      datum[:data].shift
      add_serie(chart, datum[:data], @report_data['dates'], datum[:name])
    end
    add_serie(chart, [], @report_data['dates'], '') if @report_data['theme_datum'].size == 1
    append_rows_to_report 24
    @worksheet.add_row ["", "Comentario"], :style => 3
    append_rows_to_report 1
    @worksheet.add_row ["", history_comment_for(2).content] if !history_comment_for(2).nil?
  end

  def append_channels_chart
    chart = create_chart(90, "Tipología de comentarios", 8)
    @report_data['channel_datum'].each do |datum|
      datum[:data].shift
      datum[:data].shift
      add_serie(chart, datum[:data], @report_data['dates'], datum[:name])
    end
    add_serie(chart, [], @report_data['dates'], '') if @report_data['channel_datum'].size == 1
    append_rows_to_report 24
    @worksheet.add_row ["", "Comentario"], :style => 3
    append_rows_to_report 1
    @worksheet.add_row ["", history_comment_for(3).content] if !history_comment_for(3).nil?
  end

  def monitoring_hash
    {
      "total_days" => ['',''],
      "theme_datum" => [],
      "channel_datum" => [],
      "change_volume_comments" => ['',' % Cambio volumen total comentarios', '0'],
      "daily_average" => ['','Promedio diario'],
      "theme_total_comment" => ['','Total comentarios'],
      "channel_total_comment" => ['', 'Total comentarios'],
      "theme_header" => ['','Temas'],
      "distribution_header" => ['','Distribución de canales'],
      "widths" => [1, 11]
    }
  end

  def set_headers_and_footers
    @headers ||= [0, 41, 83]
    @footers ||= [40, 83, 124]
  end
end
