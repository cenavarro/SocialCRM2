class ReportGenerators::TuentiReport < ReportGenerators::Base

  def self.can_process? type
    type == TuentiDatum
  end

  def add_to(document)
    if !tuenti_datum.empty?
      @comments = social_network.tuenti_comment.where("social_network_id = ?", social_network.id).first
      @report_data = select_report_data
      set_headers_and_footers
      create_report(document)
      append_headers_and_footers
    end
  end

  private

  def tuenti_datum
		social_network.tuenti_data.where('start_date >= ? and end_date <= ?', start_date.to_date, end_date.to_date).order("start_date ASC").limit(6)
  end

  def create_report(document)
    set_workbook_and_worksheet(document)
    create_report_styles(tuenti_datum.size + 1)
    append_rows_to_report 7
    @worksheet.add_row ["","PAGINA DE TUENTI"], :style => 3
    add_table_to_report
    append_rows_to_report 41
    append_charts_to_report
    append_rows_to_report 15
    add_images_report 282
    @worksheet.column_widths 4, 31, 9, 9, 9, 9, 9, 9
  end

  def append_charts_to_report
    remove_cells_report_table
		@worksheet.add_row ["","GRAFICOS TUENTI"], :style => 3
    append_rows_to_report 2
		append_followers_chart
		append_interactivity_chart
		append_reach_chart
		append_investment_chart
		append_cost_chart
  end

  def table_rows
    {
      'dates' => ['',''], 'actions' => ['', 'Acciones Periodo'], 'fans_header' => ['','Fans'], 'new_fans' => ['','# nuevos fans'], 
      'real_fans' => ['','# fans reales'], 'goal_fans' => ['', '# Objetivo Fans'], 'growth_fans' => ['', 'Porcentaje crecimiento fans'],
      'page_header' => ['','Pagina de la empresa'], 'page_prints' => ['', 'Impresiones de la pagina'],
      'unique_total_users' => ['', 'Total de usuario unicos'], 'external_clics' => ['','Clics externos'],
      'clics' => ['','Clicks'], 'downloads' => ['','Descargars'], 'comments' => ['','Numero de comentarios'],
      'ctr_external_clics' => ['','CTR % clic externos'], 'upload_photos' => ['','Fotos subidas'],
      'investment_header' => ['','Inversion'], 'investment_agency' => ['', 'Inversion Agencia'], 'investment_actions' => ['','Inversion nuevas acciones'],
      'investment_ads' => ['','Inversion anuncios'], 'total_investment' => ['','Inversion Total'],
      'costs_header' => ['', 'Coste Fan'], 'cost_fan' => ['','Coste Fan']
    }
  end

  def select_report_data
    table = table_rows
    tuenti_datum.each do |datum|
      tuenti_keys.each do |key|
        key.include?("header") ? (value = nil) : ((key == 'cost_fan') ? (value = datum[key].round(2)) : (value = datum[key]))
        table[key] << value
      end
      table['dates'] << "#{datum.start_date.strftime('%d %b')} - #{datum.end_date.strftime('%d %b')}"
      table['growth_fans'] << datum.get_percentage_difference_from_previous_real_fans.round(3)
      table['total_investment'] << datum.total_investment.round(2)
      table['new_fans'] << datum.new_fans
      table['cost_fan'] << datum.cost_fan.round(2)
    end
    table
  end

  def tuenti_keys
    ['actions', 'fans_header', 'real_fans', 'goal_fans', 'page_header', 'page_prints', 'unique_total_users', 
      'external_clics', 'clics', 'downloads', 'comments', 'ctr_external_clics', 'upload_photos', 'investment_header', 
      'investment_agency', 'investment_actions', 'investment_ads','costs_header']
  end

  def append_followers_chart
    chart = create_chart(81, "Comunidad")
    add_serie(chart, @report_data['new_fans'], @report_data['dates'], '# nuevos fans')
    add_serie(chart, @report_data['total_fans'], @report_data['dates'], '# Fans Reales')
    add_serie(chart, @report_data['goal_fans'], @report_data['dates'], 'Objetivos Fans')
    append_rows_to_report 24
    @worksheet.add_row ["", "Comentario"], :style => 3
    append_rows_to_report 1
    @worksheet.add_row ["", @comments.fans]
  end

  def append_interactivity_chart
    chart = create_chart(121, "Interacciones")
    add_serie(chart, @report_data['unique_total_users'], @report_data['dates'], 'Total usuarios unicos')
    add_serie(chart, @report_data['clics'], @report_data['dates'], 'Clicks')
    add_serie(chart, @report_data['downloads'], @report_data['dates'], 'Descargas')
    add_serie(chart, @report_data['comments'], @report_data['dates'], 'Numero Comentarios')
    add_serie(chart, @report_data['upload_photos'], @report_data['dates'], 'Fotos subidas')
    append_rows_to_report 37
    @worksheet.add_row ["", "Comentario"], :style => 3
    append_rows_to_report 1
    @worksheet.add_row ["", @comments.interaction]
  end

  def append_reach_chart
    chart = create_chart(163, "Alcance")
    add_serie(chart, @report_data['page_prints'], @report_data['dates'], 'Impresiones de la pagina')
    add_serie(chart, [], @report_data['dates'], '')
    append_rows_to_report 39
    @worksheet.add_row ["", "Comentario"], :style => 3
    append_rows_to_report 
    @worksheet.add_row ["", @comments.reach]
  end

  def append_investment_chart
    chart = create_chart(205, "Inversion")
    add_serie(chart, @report_data['investment_agency'], @report_data['dates'], 'Inversion agencia')
    add_serie(chart, @report_data['investment_actions'], @report_data['dates'], 'Inversion nuevas acciones')
    add_serie(chart, @report_data['investment_ads'], @report_data['dates'], 'Inversion anuncios')
    add_serie(chart, @report_data['total_investment'], @report_data['dates'], 'Inversion Total')
    append_rows_to_report 39
    @worksheet.add_row ["", "Comentario"], :style => 3
    append_rows_to_report
    @worksheet.add_row ["", @comments.investment]
  end

  def append_cost_chart
    chart = create_chart(247, "Costes")
    add_serie(chart, @report_data['cost_fan'], @report_data['dates'], 'Coste Fan')
    add_serie(chart, [], @report_data['dates'], '')
    append_rows_to_report 39
    @worksheet.add_row ["", "Comentario"], :style => 3
    append_rows_to_report
    @worksheet.add_row ["", @comments.cost]
  end

  def set_headers_and_footers
    @headers ||= [0, 72, 114, 156, 198, 240]
    @footers ||= [71, 113, 155, 197, 239, 281]
  end

end
