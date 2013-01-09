# encoding: utf-8
class ReportGenerators::TuentiReport < ReportGenerators::Base

  def self.can_process? type
    type == TuentiDatum
  end

  def add_to(document)
    if !tuenti_datum.empty?
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
      'dates' => ['',''], 'actions' => ['', 'Acciones durante periodo'], 'fans_header' => ['','Fans'], 'new_fans' => ['','Nuevos fans'], 
      'real_fans' => ['','Fans totales'], 'goal_fans' => ['', 'Objetivo fans'], 'growth_fans' => ['', '% crecimiento fans'],
      'page_header' => ['','Página de la empresa'], 'page_prints' => ['', 'Impresiones de la página'],
      'unique_total_users' => ['', 'Total de usuario únicos'], 'external_clics' => ['','Clics externos'],
      'clics' => ['','Clicks'], 'downloads' => ['','Descargars'], 'comments' => ['','Número de comentarios'],
      'ctr_external_clics' => ['','CTR % clic externos'], 'upload_photos' => ['','Fotos subidas'],
      'investment_header' => ['','Inversión'], 'investment_agency' => ['', 'Inversión agencia'], 'investment_actions' => ['','Inversión nuevas acciones'],
      'investment_ads' => ['','Inversión anuncios'], 'total_investment' => ['','Inversión total'],
      'costs_header' => ['', 'Coste fan'], 'cost_fan' => ['','Coste fan']
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
    add_serie(chart, @report_data['new_fans'], @report_data['dates'], 'Nuevos fans')
    add_serie(chart, @report_data['total_fans'], @report_data['dates'], 'Fans totales')
    add_serie(chart, @report_data['goal_fans'], @report_data['dates'], 'Objetivos fans')
    append_rows_to_report 24
    @worksheet.add_row ["", "Comentario"], :style => 3
    append_rows_to_report 1
    @worksheet.add_row ["", history_comment_for(2).content] if !history_comment_for(2).nil?
  end

  def append_interactivity_chart
    chart = create_chart(121, "Interacciones")
    add_serie(chart, @report_data['unique_total_users'], @report_data['dates'], 'Total usuarios únicos')
    add_serie(chart, @report_data['clics'], @report_data['dates'], 'Clicks')
    add_serie(chart, @report_data['downloads'], @report_data['dates'], 'Descargas')
    add_serie(chart, @report_data['comments'], @report_data['dates'], 'Numero comentarios')
    add_serie(chart, @report_data['upload_photos'], @report_data['dates'], 'Fotos subidas')
    append_rows_to_report 37
    @worksheet.add_row ["", "Comentario"], :style => 3
    append_rows_to_report 1
    @worksheet.add_row ["", history_comment_for(3).content] if !history_comment_for(3).nil?
  end

  def append_reach_chart
    chart = create_chart(163, "Alcance")
    add_serie(chart, @report_data['page_prints'], @report_data['dates'], 'Impresiones de la página')
    add_serie(chart, [], @report_data['dates'], '')
    append_rows_to_report 39
    @worksheet.add_row ["", "Comentario"], :style => 3
    append_rows_to_report 
    @worksheet.add_row ["", history_comment_for(4).content] if !history_comment_for(4).nil?
  end

  def append_investment_chart
    chart = create_chart(205, "Inversión")
    add_serie(chart, @report_data['investment_agency'], @report_data['dates'], 'Inversión agencia')
    add_serie(chart, @report_data['investment_actions'], @report_data['dates'], 'Inversión nuevas acciones')
    add_serie(chart, @report_data['investment_ads'], @report_data['dates'], 'Inversión anuncios')
    add_serie(chart, @report_data['total_investment'], @report_data['dates'], 'Inversión total')
    append_rows_to_report 39
    @worksheet.add_row ["", "Comentario"], :style => 3
    append_rows_to_report
    @worksheet.add_row ["", history_comment_for(5).content] if !history_comment_for(5).nil?
  end

  def append_cost_chart
    chart = create_chart(247, "Costes")
    add_serie(chart, @report_data['cost_fan'], @report_data['dates'], 'Coste fan')
    add_serie(chart, [], @report_data['dates'], '')
    append_rows_to_report 39
    @worksheet.add_row ["", "Comentario"], :style => 3
    append_rows_to_report
    @worksheet.add_row ["", history_comment_for(6).content] if !history_comment_for(6).nil?
  end

  def set_headers_and_footers
    @headers ||= [0, 72, 114, 156, 198, 240]
    @footers ||= [71, 113, 155, 197, 239, 281]
  end

end
