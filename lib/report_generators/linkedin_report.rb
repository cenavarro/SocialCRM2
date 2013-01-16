# encoding: utf-8
class ReportGenerators::LinkedinReport < ReportGenerators::Base

  def self.can_process? type
    type == LinkedinDatum
  end

  def add_to(document)
    if !linkedin_datum.empty?
      @report_data = select_report_data
      set_headers_and_footers
      create_report(document)
      append_headers_and_footers
    end
  end

  private

  def linkedin_datum
    social_network.linkedin_data.where('start_date >= ? and end_date <= ?', start_date.to_date, end_date.to_date).order("start_date ASC").limit(6)
  end

  def create_report(document)
    set_workbook_and_worksheet(document)
    create_report_styles(linkedin_datum.size+1)
    append_rows_to_report(8)
    @worksheet.add_row ["","PÁGINA DE LINKEDIN"], :style => 3
    append_rows_to_report
    add_table_to_report
    append_charts_to_report
    append_rows_to_report(15)
    add_images_report(199)
    @worksheet.column_widths 4, 31, 9, 9, 9, 9, 9, 9
  end

  def append_charts_to_report
    remove_cells_report_table
    append_rows_to_report(44)
    @worksheet.add_row ["","GRÁFICOS LINKEDIN"], :style => 3
    append_rows_to_report(2)
    append_followers_chart(83)
    append_interactivity_chart(122)
    append_views_pages_chart(164)
  end

  def table_rows
    {
      'dates' => ['',''], 'actions' => ['','Acciones durante periodo'], 'community_header' => ['','Comunidad'], 
      'new_followers' => ['','Nuevos seguidores'], 'total_followers' => ['','Seguidores totales'], 
      'growth_followers' => ['', '% Crecimiento seguidores'], 'interactions_header' => ['', 'Interactividad'], 
      'views_pages' => ['', 'Número de visualizaciones de páginas'], 
      'summary' => ['', 'Resumen'], 'employment' => ['', 'Empleo'], 'products_services' => ['','Productos y servicios'], 
      'prints' => ['','Impresiones'],
      'clics' => ['','Clicks'], 'interest' => ['','% Interés'], 'recommendation' => ['','Recomendación'],
      'investment_header' => ['','Inversión'], 'investment_agency' => ['', 'Inversión agencia'], 
      'investment_actions' => ['','Inversión nuevas acciones'],
      'investment_anno' => ['','Inversión anuncios'], 'total_investment' => ['','Inversión total']
    }
  end

  def select_report_data
    table = table_rows
    linkedin_datum.each do |datum|
      linkedin_keys.each do |key|
        key.include?("header") ? (value = nil) : (value = datum[key])
        table[key] << value
      end
      table['dates'] << "#{datum.start_date.strftime('%d %b')} - #{datum.end_date.strftime('%d %b')}"
      table['new_followers'] << datum.new_followers
      table['growth_followers'] << datum.get_percentage_difference_from_previous_total_followers.round(3)
      table['views_pages'] << datum.views_page
      table['total_investment'] << datum.total_investment.round(2)
    end
    table
  end

  def linkedin_keys
    ['community_header', 'total_followers', 'interactions_header', 'summary', 'employment', 'products_services', 
      'prints', 'clics', 'interest', 'recommendation', 'investment_header', 'investment_agency', 'investment_actions',
        'investment_anno', 'actions']
  end

  def append_followers_chart position
    chart = create_chart(position, "Seguidores")
    add_serie(chart, @report_data['new_followers'], @report_data['dates'], 'Nuevos seguidores')
    add_serie(chart, @report_data['total_followers'], @report_data['dates'], 'Seguidores totales')
    append_rows_to_report(24)
    @worksheet.add_row ["", "Comentario"], :style => 3
    append_rows_to_report(1)
    @worksheet.add_row ["", history_comment_for(2).content] if !history_comment_for(2).nil?
  end

  def append_interactivity_chart position
    chart = create_chart(position, "Interactividad")
    add_serie(chart, @report_data['prints'], @report_data['dates'], 'Impresiones')
    add_serie(chart, @report_data['clics'], @report_data['dates'], 'Clicks')
    add_serie(chart, @report_data['interest'], @report_data['dates'], '% Interés')
    add_serie(chart, @report_data['recommendation'], @report_data['dates'], 'Recomendación')
    append_rows_to_report(36)
    @worksheet.add_row ["", "Comentario"], :style => 3
    append_rows_to_report
    @worksheet.add_row ["", history_comment_for(3).content] if !history_comment_for(3).nil?
  end

  def append_views_pages_chart position
    chart = create_chart(position, "Visualizaciones de paginas")
    add_serie(chart, @report_data['views_pages'], @report_data['dates'], 'Número de visualizaciones de páginas')
    add_serie(chart, [], @report_data['dates'], '')
    append_rows_to_report(39)
    @worksheet.add_row ["", "Comentario"], :style => 3
    append_rows_to_report
    @worksheet.add_row ["", history_comment_for(4).content] if !history_comment_for(4).nil?
  end

  def set_headers_and_footers
    @headers ||= [0, 73, 115, 157]
    @footers ||= [72, 114, 156, 198]
  end

end
