class ReportGenerators::TumblrReport < ReportGenerators::Base

	def self.can_process? type
    type == TumblrDatum
  end


  def add_to(document)
  	tumblr_datum = social_network.tumblr_data.where('start_date >= ? and end_date <= ?', start_date.to_date, end_date.to_date).order("start_date ASC")
  	if !tumblr_datum.empty?
	    document.workbook do | wb |
	      wb.add_worksheet(:name => "Tumblr", :page_margins => margins, :page_setup => page_setup) do |sheet|
	        @comments = social_network.tumblr_comment.where("social_network_id = ?", social_network.id).first
	        report_data = select_report_data(tumblr_datum)
	        styles = create_report_styles(wb, report_data['size'])
	        add_rows_report(sheet, 7)
	        sheet.add_row ["","PAGINA DE TUMBLR"], :style => 3
	        add_table(sheet, report_data, styles)
	        add_rows_report(sheet, 16)
	        add_charts(sheet, report_data['size'])
	        add_rows_report(sheet, 15)
	        add_images_report(sheet, 161, social_network.id, styles)
	        header(sheet, 0)
	        footer(sheet, 34)
	        sheet.column_widths 4, 31, 9, 9, 9, 9, 9, 9
	      end
	    end
	  end
  end

  private

  def select_report_data(tumblr_datum)
    data = table_rows
    data['widths'] = [1, 32]
    data['size'] = (tumblr_datum.size+1)
    create_data_table(data, tumblr_datum)
    return data
  end

  def add_charts(sheet, size)
    @end_letter = (65 + size).chr
    @labels = sheet["C11:#{@end_letter}11"]
    sheet.add_row ["","GRAFICOS TUMBLR"], :style => 3
    add_rows_report(sheet, 2)
    insert_followers_chart(sheet)
    insert_interactivity_chart(sheet)
    insert_investment_chart(sheet)
    header(sheet, 35)
    footer(sheet, 76)
    header(sheet, 77)
    footer(sheet, 118)
    header(sheet, 119)
    footer(sheet, 160)
  end

  def table_rows
    {
      'table' => {
        'dates' => ['',''], 'community_header' => ['','Comunidad'], 'new_followers' => ['','# nuevos followers'], 
        'total_followers' => ['','# followers'], 'interaction_header' => ['', 'Interactividad'], 'likes' => ['', '# like'],
        'reblogged' => ['','# reblogged'], 'investment_header' => ['','Inversion'], 'investment_agency' => ['', 'Inversion Agencia'], 
        'investment_actions' => ['','Inversion nuevas acciones'], 'investment_ads' => ['','Inversion anuncios'], 
        'total_investment' => ['','Inversion Total'],
      }
    }
  end

  def create_data_table(data, tuenti_datum)
    tuenti_datum.each do |datum|
      tuenti_keys.each do |key|
        key.include?("header") ? (value = nil) : (value = datum[key])
        data['table'][key] << value
      end
      data['table']['dates'] << "#{datum.start_date.strftime('%d %b')} - #{datum.end_date.strftime('%d %b')}"
      data['table']['total_investment'] << datum.total_investment.round(2)
      data['table']['new_followers'] << datum.new_followers
      data['widths'] << 9
    end
  end

  def tuenti_keys
    ['community_header', 'total_followers', 'interaction_header', 'likes', 'reblogged', 'investment_header', 
      'investment_agency', 'investment_actions', 'investment_ads']
  end

  def insert_followers_chart(sheet)
    chart = create_chart(sheet, 45, "Followers")
    add_serie(chart, sheet["C13:#{@end_letter}13"], @labels, '# nuevos followers')
    add_serie(chart, sheet["C14:#{@end_letter}14"], @labels, '# followers')
    add_rows_report(sheet, 24)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.followers]
  end

  def insert_interactivity_chart(sheet)
    chart = create_chart(sheet, 84, "Interactividad")
    add_serie(chart, sheet["C16:#{@end_letter}16"], @labels, '# like')
    add_serie(chart, sheet["C17:#{@end_letter}17"], @labels, '# reblogged')
    add_rows_report(sheet, 36)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.interactivity]
  end

  def insert_investment_chart(sheet)
    chart = create_chart(sheet, 126, "Inversion")
    add_serie(chart, sheet["C13:#{@end_letter}13"], @labels, '# nuevos followers')
    add_serie(chart, sheet["C22:#{@end_letter}22"], @labels, 'Inversion Total')
    add_rows_report(sheet, 39)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.investment]
  end

end
