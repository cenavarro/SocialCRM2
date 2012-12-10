class ReportGenerators::PinterestReport < ReportGenerators::Base

  def self.can_process? type
    type == PinterestDatum
  end

  def add_to(document)
    pinterest_datum = social_network.pinterest_data.where('start_date >= ? and end_date <= ?', start_date.to_date, end_date.to_date).order("start_date ASC")
  	if !pinterest_datum.empty?
	    document.workbook do | wb |
	      wb.add_worksheet(:name => social_network.name, :page_margins => margins, :page_setup => page_setup) do |sheet|
	        @comments = social_network.pinterest_comment.where("social_network_id = ?", social_network.id).first
	        report_data = select_report_data(pinterest_datum)
	        styles = create_report_styles(wb, report_data['size'])
	        add_rows_report(sheet, 7)
	        sheet.add_row ["","PAGINA DE PINTEREST"], :style => 3
	        add_table(sheet, report_data, styles)
	        add_rows_report(sheet, 10)
	        add_charts(sheet, report_data['size'])
	        add_rows_report(sheet, 15)
	        add_images_report(sheet, 159, styles)
	        header(sheet, 0)
	        footer(sheet, 32)
	        sheet.column_widths 4, 31, 9, 9, 9, 9, 9, 9
	      end
	    end
	end
  end

  private

  def select_report_data(pinterest_datum)
    data = table_rows
    data['widths'] = [1, 32]
    data['size'] = (pinterest_datum.size+1)
    create_data_table(data, pinterest_datum)
    return data
  end

  def add_charts(sheet, size)
    @end_letter = (65 + size).chr
    @labels = sheet["C11:#{@end_letter}11"]
    sheet.add_row ["","GRAFICOS PINTEREST"], :style => 3
    add_rows_report(sheet, 2)
    insert_followers_chart(sheet)
    insert_interactivity_chart(sheet)
    insert_investment_chart(sheet)
    header(sheet, 33)
    footer(sheet, 74)
    header(sheet, 75)
    footer(sheet, 116)
    header(sheet, 117)
    footer(sheet, 158)
  end

  def table_rows
    {
      'table' => {
        'dates' => ['',''], 'community_header' => ['','Comunidad'], 'new_followers' => ['','# Nuevos Followers'], 'total_followers' => ['','# Followers'], 
        'boards' => ['', '# boards'], 'pins' => ['', '# pins'], 'interactions_header' => ['', 'Interactividad'], 
        'liked' => ['','# liked'], 'repin' => ['','# repin'], 'comments' => ['','# comments'], 'community_boards' => ['','# community boards'],
        'investment_header' => ['','Inversion'], 'investment_agency' => ['', 'Inversion Agencia'], 'investment_actions' => ['','Inversion nuevas acciones'],
        'investment_ads' => ['','Inversion anuncios'], 'total_investment' => ['','Inversion Total']
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
      data['table']['total_investment'] << datum.total_investment.round(2)
      data['table']['new_followers'] << datum.new_followers
      data['widths'] << 9
    end
  end

  def linkedin_keys
    ['community_header', 'total_followers', 'interactions_header', 'boards', 'pins', 'liked', 
      'repin', 'comments', 'community_boards', 'investment_header', 'investment_agency', 'investment_actions',
        'investment_ads']
  end

  def insert_followers_chart(sheet)
    chart = create_chart(sheet, 43, "Comunidad")
    add_serie(chart, sheet["C13:#{@end_letter}13"], @labels, '# Nuevos Followers')
    add_serie(chart, sheet["C14:#{@end_letter}14"], @labels, '# Followers')
    add_serie(chart, sheet["C15:#{@end_letter}15"], @labels, '# boards')
    add_serie(chart, sheet["C16:#{@end_letter}16"], @labels, '# pins')
    add_rows_report(sheet, 24)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.comunity]
  end

  def insert_interactivity_chart(sheet)
    chart = create_chart(sheet, 83, "Interactividad")
    add_serie(chart, sheet["C18:#{@end_letter}18"], @labels, '# liked')
    add_serie(chart, sheet["C19:#{@end_letter}19"], @labels, '# repin')
    add_serie(chart, sheet["C20:#{@end_letter}20"], @labels, '# comments')
    add_serie(chart, sheet["C21:#{@end_letter}21"], @labels, '# community boards')
    add_rows_report(sheet, 37)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.interaction]
  end

  def insert_investment_chart(sheet)
    chart = create_chart(sheet, 124, "Inversion")
    add_serie(chart, sheet["C13:#{@end_letter}13"], @labels, '# nuevos followers')
    add_serie(chart, sheet["C26:#{@end_letter}26"], @labels, 'Inversion Total')
    add_rows_report(sheet, 38)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.investment]
  end

end
