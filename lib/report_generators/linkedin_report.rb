class ReportGenerators::LinkedinReport < ReportGenerators::Base

  def self.can_process? type
    type == LinkedinDatum
  end

  def add_to(document)
    linkedin_datum = social_network.linkedin_data.where('start_date >= ? and end_date <= ?', start_date.to_date, end_date.to_date).order("start_date ASC")
    if !linkedin_datum.empty?
	    document.workbook do | wb |
	      wb.add_worksheet(:name => "Linkedin", :page_margins => margins, :page_setup => page_setup) do |sheet|
	      	@comments = social_network.linkedin_comment.where("social_network_id = ?", social_network.id).first
	        report_data = select_report_data(linkedin_datum)
	        styles = create_report_styles(wb, report_data['size'])
          add_rows_report(sheet, 8)
          sheet.add_row ["","PAGINA DE LINKEDIN"], :style => 3
          add_table(sheet, report_data, styles)
          add_charts(sheet, report_data['size'])
          add_rows_report(sheet, 15)
          add_images_report(sheet, 157, social_network.id, styles)
          header(sheet, 0)
          footer(sheet, 72)
          sheet.column_widths 4, 31, 9, 9, 9, 9, 9, 9
	      end
	    end
	end
  end

  private

  def select_report_data(linkedin_datum)
    data = table_rows
    data['widths'] = [1, 32]
    data['size'] = (linkedin_datum.size+1)
    create_data_table(data, linkedin_datum)
    return data
  end

  def add_charts(sheet, size)
    @end_letter = (65 + size).chr
    @labels = sheet["C12:#{@end_letter}12"]
    add_rows_report(sheet, 45)
    sheet.add_row ["","GRAFICOS LINKEDIN"], :style => 3
    add_rows_report(sheet, 2)
    insert_followers_chart(sheet)
    insert_interactivity_chart(sheet)
    header(sheet, 73)
    footer(sheet, 114)
    header(sheet, 115)
    footer(sheet, 156)
  end

  def table_rows
    {
      'table' => {
        'dates' => ['',''], 'community_header' => ['','Comunidad'], 'new_followers' => ['','# Nuevos Followers'], 'total_followers' => ['','# Followers'], 
        'growth_followers' => ['', '% Crecimiento'], 'interactions_header' => ['', 'Interactividad'], 
        'views_pages' => ['', '# Visualizaciones de paginas'], 'summary' => ['', 'Resumen'],
        'employment' => ['', 'Empleo'], 'products_services' => ['','Productos y Servicios'], 'prints' => ['','Impresiones'],
        'clics' => ['','Clicks'], 'interest' => ['','% de interes'], 'recommendation' => ['','Recomendacion'], 'shared' => ['','Compartidos'],
        'investment_header' => ['','Inversion'], 'investment_agency' => ['', 'Inversion Agencia'], 'investment_actions' => ['','Inversion nuevas acciones'],
        'investment_anno' => ['','Inversion anuncios'], 'total_investment' => ['','Inversion Total']
      }
    }
  end

  def create_data_table(data, linkedin_datum)
    linkedin_datum.each do |datum|
      linkedin_keys.each do |key|
        key.include?("header") ? (value = nil) : (value = datum[key])
        data['table'][key] << value
      end
      data['table']['dates'] << "#{datum.start_date.strftime('%d %b')} - #{datum.end_date.strftime('%d %b')}"
      data['table']['new_followers'] << datum.new_followers
      data['table']['growth_followers'] << datum.get_percentage_difference_from_previous_total_followers.round(3)
      data['table']['views_pages'] << datum.views_page
      data['table']['total_investment'] << datum.total_investment.round(2)
      data['widths'] << 9
    end
  end

  def linkedin_keys
    ['community_header', 'total_followers', 'interactions_header', 'summary', 'employment', 'products_services', 
      'prints', 'clics', 'interest', 'recommendation', 'shared', 'investment_header', 'investment_agency', 'investment_actions',
        'investment_anno']
  end

  def insert_followers_chart(sheet)
    chart = create_chart(sheet, 83, "Seguidores")
    add_serie(chart, sheet["C14:#{@end_letter}14"], @labels, '# Nuevos Followers')
    add_serie(chart, sheet["C15:#{@end_letter}15"], @labels, '# Followers')
    add_rows_report(sheet, 24)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.comunity]
  end

  def insert_interactivity_chart(sheet)
    chart = create_chart(sheet, 122, "Interactividad")
    add_serie(chart, sheet["C19:#{@end_letter}19"], @labels, 'Resumen')
    add_serie(chart, sheet["C20:#{@end_letter}20"], @labels, 'Empleo')
    add_serie(chart, sheet["C21:#{@end_letter}21"], @labels, 'Productos y Servicios')
    add_serie(chart, sheet["C22:#{@end_letter}22"], @labels, 'Impresiones')
    add_serie(chart, sheet["C23:#{@end_letter}23"], @labels, 'Clicks')
    add_serie(chart, sheet["C24:#{@end_letter}24"], @labels, '% interest')
    add_serie(chart, sheet["C25:#{@end_letter}25"], @labels, 'Recomendacion')
    add_serie(chart, sheet["C26:#{@end_letter}26"], @labels, 'Compartidos')
    add_rows_report(sheet, 36)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.interaction]
  end

end
