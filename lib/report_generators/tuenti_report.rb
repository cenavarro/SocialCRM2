# encoding: utf-8
class ReportGenerators::TuentiReport < ReportGenerators::Base

  def self.can_process? type
    type == TuentiDatum
  end

  def add_to(document)
    if !tuenti_datum.empty?
      add_information_to document
    end
  end

  private

  def tuenti_datum
		social_network.tuenti_data.where('start_date >= ? and end_date <= ?', start_date.to_date, end_date.to_date).order("start_date ASC").limit(6)
  end

  def add_information_to document
    initialize_variables document
    append_rows 6
    append_row_with ["PÁGINA DE TUENTI"], @styles['title']
    append_table 3
    append_charts
    append_images 224
    @worksheet.column_widths *columns_widths
    append_headers_and_footers
  end

  def append_charts
    remove_table_legends
    append_rows (69 - current_row)
		append_row_with ["GRÁFICOS TUENTI"], @styles['title']
		append_followers_chart
		append_interactivity_chart
		append_reach_chart
		append_investment_chart
		append_cost_chart
  end

  def append_followers_chart
    append_rows (71 - current_row)
    create_chart(current_row, "Comunidad")
    add_serie(@report_data['new_fans'], 'Nuevos fans')
    add_serie(@report_data['real_fans'], 'Fans totales')
    add_serie(@report_data['goal_fans'], 'Objetivos fans')
    append_rows (86 - current_row)
    append_comment_chart_for 2
  end

  def append_interactivity_chart
    append_rows (101 - current_row)
    create_chart(current_row, "Interacciones")
    add_serie(@report_data['unique_total_users'], 'Total usuarios únicos')
    add_serie(@report_data['downloads'], 'Descargas')
    add_serie(@report_data['comments'], 'Numero comentarios')
    append_rows (116 - current_row)
    append_comment_chart_for 3
  end

  def append_reach_chart
    append_rows (133 - current_row)
    create_chart(current_row, "Alcance")
    add_serie(@report_data['page_prints'], 'Impresiones de la página')
    add_serie([0], '')
    append_rows (148 - current_row)
    append_comment_chart_for 4
  end

  def append_investment_chart
    append_rows (165 - current_row)
    create_chart(current_row, "Inversión")
    add_serie(@report_data['investment_agency'], 'Inversión agencia')
    add_serie(@report_data['investment_actions'], 'Inversión nuevas acciones')
    add_serie(@report_data['investment_ads'], 'Inversión anuncios')
    add_serie(@report_data['total_investment'], 'Inversión total')
    append_rows (180 - current_row)
    append_comment_chart_for 5
  end

  def append_cost_chart
    append_rows (197 - current_row)
    create_chart(current_row, "Costes")
    add_serie(@report_data['cost_fan'], 'Coste fan')
    add_serie([0], '')
    append_rows (212 - current_row)
    append_comment_chart_for 6
  end

  def select_report_data
    table = table_rows
    tuenti_datum.each do |datum|
      tuenti_keys.each do |key|
        is_header_or_dates_row?(key)  ? table[key] << nil : ( value = (datum[key].nil? ? datum.send(key.to_sym) : datum[key]))
        table[key] << value if !is_header_or_dates_row?(key)
      end
      table['dates'] << "#{datum.start_date.strftime('%d %b')} - #{datum.end_date.strftime('%d %b')}"
    end
    table
  end

  def tuenti_keys
    keys = table_rows
    keys.shift
    keys.collect { |key, vale| key  }
  end

  def set_headers_and_footers
    @headers ||= [0, 64, 96, 128, 160, 192]
    @footers ||= [63, 95, 127, 159, 191, 223]
  end

  def table_rows
    {
      'dates' => [''],
      'actions' => ['Acciones durante periodo'],
      'fans_header' => ['Fans'],
      'new_fans' => ['Nuevos fans'], 
      'real_fans' => ['Fans totales'],
      'goal_fans' => ['Objetivo fans'],
      'get_percentage_difference_from_previous_real_fans' => ['% crecimiento fans'],
      'page_header' => ['Página de la empresa'],
      'page_prints' => ['Impresiones de la página'],
      'unique_total_users' => ['Total de usuario únicos'],
      'external_clics' => ['Clics externos'],
      'downloads' => ['Descargars'],
      'comments' => ['Número de comentarios'],
      'ctr_external_clics' => ['CTR % clic externos'],
      'investment_header' => ['Inversión'],
      'investment_agency' => ['Inversión agencia'],
      'investment_actions' => ['Inversión nuevas acciones'],
      'investment_ads' => ['Inversión anuncios'],
      'total_investment' => ['Inversión total'],
      'costs_header' => ['Coste'], 
      'cost_fan' => ['Coste fan']
    }
  end

end
