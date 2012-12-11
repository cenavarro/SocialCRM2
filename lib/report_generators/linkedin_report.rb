class ReportGenerators::LinkedinReport < ReportGenerators::Base

  def self.can_process? type
    type == LinkedinDatum
  end

  def add_to(document)
    if !linkedin_datum.empty?
      @comments = social_network.linkedin_comment.where("social_network_id = ?", social_network.id).first
      @report_data = select_report_data
      set_headers_and_footers
      create_report(document)
      append_headers_and_footers
    end
  end

  private

  def linkedin_datum
    social_network.linkedin_data.where('start_date >= ? and end_date <= ?', start_date.to_date, end_date.to_date).order("start_date ASC")
  end

  def create_report(document)
    set_workbook_and_worksheet(document)
    create_report_styles(linkedin_datum.size+1)
    append_rows_to_report(8)
    @worksheet.add_row ["","PAGINA DE LINKEDIN"], :style => 3
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
    @worksheet.add_row ["","GRAFICOS LINKEDIN"], :style => 3
    append_rows_to_report(2)
    append_followers_chart(83)
    append_interactivity_chart(122)
    append_views_pages_chart(164)
  end

  def table_rows
    {
      'dates' => ['',''], 'actions' => ['','Acciones durante periodo'], 'community_header' => ['','Comunidad'], 
      'new_followers' => ['','# nuevos seguidores'], 'total_followers' => ['','# seguidores reales'], 
      'growth_followers' => ['', '% crecimiento seguidores'], 'interactions_header' => ['', 'Interactividad'], 
      'summary' => ['', 'Resumen'], 'employment' => ['', 'Empleo'], 'products_services' => ['','Productos y Servicios'], 
      'views_pages' => ['', '# Visualizaciones de paginas(total)'], 'prints' => ['','Impresiones'],
      'clics' => ['','Clicks'], 'interest' => ['','% de interes'], 'recommendation' => ['','Recomendacion'],
      'investment_header' => ['','Inversion'], 'investment_agency' => ['', 'Inversion Agencia'], 
      'investment_actions' => ['','Inversion nuevas acciones'],
      'investment_anno' => ['','Inversion anuncios'], 'total_investment' => ['','Inversion Total']
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
    add_serie(chart, @report_data['new_followers'], @report_data['dates'], '# nuevos seguidores')
    add_serie(chart, @report_data['total_followers'], @report_data['dates'], '# seguidores reales')
    append_rows_to_report(24)
    @worksheet.add_row ["", "Comentario"], :style => 3
    append_rows_to_report(1)
    @worksheet.add_row ["", @comments.comunity]
  end

  def append_interactivity_chart position
    chart = create_chart(position, "Interactividad")
    add_serie(chart, @report_data['prints'], @report_data['dates'], 'Impresiones')
    add_serie(chart, @report_data['clics'], @report_data['dates'], 'Clicks')
    add_serie(chart, @report_data['interest'], @report_data['dates'], '% interest')
    add_serie(chart, @report_data['recommendation'], @report_data['dates'], 'Recomendacion')
    append_rows_to_report(36)
    @worksheet.add_row ["", "Comentario"], :style => 3
    append_rows_to_report
    @worksheet.add_row ["", @comments.interaction]
  end

  def append_views_pages_chart position
    chart = create_chart(position, "Visualizaciones de paginas")
    add_serie(chart, @report_data['views_pages'], @report_data['dates'], '# Visualizaciones de paginas')
    add_serie(chart, [], @report_data['dates'], '')
    append_rows_to_report(39)
    @worksheet.add_row ["", "Comentario"], :style => 3
    append_rows_to_report
    @worksheet.add_row ["", @comments.pages_views]
  end

  def set_headers_and_footers
    @headers ||= [0, 73, 115, 157]
    @footers ||= [72, 114, 156, 198]
  end

end
