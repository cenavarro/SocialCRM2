# encoding: utf-8
class ReportGenerators::MonitoringReport < ReportGenerators::Base
  def self.can_process? type
    type == Monitoring
  end

  def add_to(document)
    if !is_empty? && !themes.first.monitoring_data.empty? 
      add_information_to document
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
                     start_date.to_date, end_date.to_date).order('start_date ASC').limit(6)
  end

  def add_information_to document
    @current_row = 0
    @workbook = document.workbook
    @workbook.sheet_by_name(social_network.name[0..30]).nil? ? name = social_network.name[0..30] : name = "#{social_network.name[0..25]}-#{Random.rand(1000)}"
    @worksheet = @workbook.add_worksheet(:name => name, :page_margins => margins, :page_setup => page_setup)
    create_report_styles
    params = {themes: themes, channels: channels, start_date: start_date, end_date: end_date, datum: monitoring_datum}
    @report_data = create_report_data(params)
    append_rows 4
    append_row_with ["PÁGINA DE MONITORING"], @styles['title']
    add_table_monitoring
    append_charts
    append_images (page_size * 4)
    @worksheet.column_widths *columns_widths
    set_headers_and_footers 2, 4
    append_headers_and_footers
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
      themes_datum = social_network.monitoring.where("isTheme = ? and id = ?", true, theme.id).first.monitoring_data.where("start_date >= ? and end_date <= ?", start_date.to_date, end_date.to_date).order('start_date ASC').limit(6)
      data = []
      index = 1
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
      channels_datum = social_network.monitoring.where("isTheme = ? and id = ?", false,channel.id).first.monitoring_data.where("start_date >= ? and end_date <= ?", start_date.to_date, end_date.to_date).order('start_date ASC').limit(6)
      data = []
      index = 1
      channels_datum.each do |datum|
        data << datum.value
        if index == 1
          aux =  social_network.monitoring.where("isTheme = ? and id = ?", false, channel.id).first.monitoring_data.where("end_date < ?", start_date.to_date)
          unless aux.empty?
            if monitoring_data['channel_total_comment'][index].nil?
              monitoring_data['channel_total_comment'][index] = aux.first.value
            else
              monitoring_data['channel_total_comment'][index] = monitoring_data['channel_total_comment'][index] + aux.first.value
            end
          else
            monitoring_data['channel_total_comment'][index] = 0
          end
          index = index + 1
        end
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
    append_rows 1
    @report_data['dates'].unshift('')
    append_row_with @report_data['dates'], @styles['dates']
    append_row_with @report_data['theme_header'], @styles['header']
    @report_data['theme_datum'].each do |datum|
      values = datum[:data].unshift(datum[:name])
      append_row_with values,  @styles['basic']
    end
    append_row_with @report_data['theme_total_comment'], @styles['basic']
    append_row_with @report_data['distribution_header'], @styles['header']
    @report_data['channel_datum'].each do |datum|
      values = datum[:data].unshift(datum[:name])
      append_row_with values, @styles['basic']
    end
    for i in (2..@report_data['channel_total_comment'].size-1) do
      previous_data = @report_data['channel_total_comment'][i-1].to_i
      actual_data = @report_data['channel_total_comment'][i].to_i
      result = ((actual_data - previous_data).to_f/previous_data)*100
      @report_data['change_volume_comments'][i] = result
    end
    for i in (1..@report_data['channel_total_comment'].size-1)
      result = (@report_data['channel_total_comment'][i] / @report_data['total_days'][1]).round(2)
      @report_data['daily_average'][i] = result
    end
    @report_data['channel_total_comment'].delete_at(1)
    append_row_with @report_data['channel_total_comment'], @styles['basic']
    @report_data['change_volume_comments'].delete_at(1)
    text = @report_data['change_volume_comments'].shift
    correct_format_for_percent @report_data['change_volume_comments']
    @report_data['change_volume_comments'].unshift(text)
    append_row_with @report_data['change_volume_comments'], @styles['normal_percent']
    @report_data['daily_average'].delete_at(1)
    append_row_with @report_data['daily_average'], @styles['basic']
    append_rows ((page_size + 2) - current_row)
    append_row_with ["Comentario del consultor"], @styles['title']
    append_rows 1
    append_comment(history_comment_for(1).content) if !history_comment_for(1).nil?
  end

  def append_charts
    append_rows (((page_size * 2) + 5) - current_row)
    append_row_with ["GRÁFICOS MONITORING"], @styles['title']
    append_themes_chart
    append_channels_chart
  end

  def append_themes_chart
    append_rows (((page_size * 2) + 7) - current_row)
    create_chart(current_row, "Tipología de comentarios")
    @report_data['dates'].shift
    @report_data['theme_datum'].each do |datum|
      datum[:data].shift
      add_serie(datum[:data],  datum[:name])
    end
    add_serie([0], '') if @report_data['theme_datum'].size == 1
    append_rows 15
    append_comment_chart_for 3
  end

  def append_channels_chart
    append_rows (((page_size * 3) + 5) - current_row)
    create_chart(current_row, "Distribución de los comentarios en canales")
    @report_data['channel_datum'].each do |datum|
      datum[:data].shift
      add_serie(datum[:data], datum[:name])
    end
    add_serie([0], '') if @report_data['channel_datum'].size == 1
    append_rows 15
    append_comment_chart_for 2
  end

  def monitoring_hash
    {
      "total_days" => [''],
      "theme_datum" => [],
      "channel_datum" => [],
      "change_volume_comments" => [' % Cambio volumen total comentarios'],
      "daily_average" => ['Promedio diario'],
      "theme_total_comment" => ['Total comentarios'],
      "channel_total_comment" => ['Total comentarios'],
      "theme_header" => ['Temas'],
      "distribution_header" => ['Distribución de canales'],
      "widths" => [11]
    }
  end

end
