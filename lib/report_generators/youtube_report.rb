class ReportGenerators::YoutubeReport < ReportGenerators::Base

	def self.can_process? type
		type == YoutubeDatum
	end

	def add_to(document)
		youtube_datum = social_network.youtube_data.where('start_date >= ? and end_date <= ?', start_date.to_date, end_date.to_date).order("start_date ASC")
		if !youtube_datum.empty?
	    @comments = social_network.youtube_comment.first
	    document.workbook do | wb |
	      wb.add_worksheet(:name => "Youtube", :page_margins => margins, :page_setup => page_setup) do |sheet|
	        report_data = select_report_data(youtube_datum)
	        styles = create_report_styles(wb, report_data['size'])
	        add_rows_report(sheet, 7)
	        sheet.add_row ["","PAGINA DE YOUTUBE"], :style => 3
	        add_table(sheet, report_data, styles)
	        add_rows_report(sheet, 45)
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

  def select_report_data(youtube_datum)
    data = table_rows
    data['widths'] = [1, 32]
    data['size'] = (youtube_datum.size+1)
    create_data_table(data, youtube_datum)
    return data
  end

  def add_charts(sheet, size)
    @end_letter = (65 + size).chr
    @labels = sheet["C11:#{@end_letter}11"]
    sheet.add_row ["","GRAFICOS YOUTUBE"], :style => 3
    add_rows_report(sheet, 2)
    insert_community_chart(sheet)
    insert_interactivity_chart(sheet)
    header(sheet, 73)
    footer(sheet, 114)
    header(sheet, 115)
    footer(sheet, 156)
  end

  def table_rows
    {
      'table' => {
        'dates' => ['',''], 'community_header' => ['','Comunidad'], 'new_subscriber' => ['','Suscriptores nuevos'], 
        'total_subscriber' => ['','Suscriptores totales'], 'interactivity_header' => ['', 'Interactividad'],
        'total_video_views' => ['','Reproducciones videos durante un periodo'], 'inserted_player' => ['', 'Reproductor insertado'],
        'mobile_devise' => ['', 'Dispositivos moviles'], 'youtube_search' => ['', 'Busqueda en Youtube'],
        'youtube_suggestion' => ['', 'Sugerencia de Youtube'], 'youtube_page' => ['', 'Pagina de canal de Youtube'],
        'external_web_site' => ['', 'Sitio web externo'], 'google_search' => ['', 'Busqueda en Google'],
        'youtube_others' => ['', 'Otras paginas de Youtube'], 'youtube_subscriptions' => ['', 'Suscripciones de Youtube'],
        'youtube_ads' => ['', 'Publicidad de Youtube'], 'investment_header' => ['','Inversion'], 
        'investment_agency' => ['', 'Inversion Agencia'], 'investment_actions' => ['','Inversion nuevas acciones'], 
        'investment_anno' => ['','Inversion anuncios'], 'total_investment' => ['','Inversion Total'],
      }
    }
  end

  def create_data_table(data, twitter_datum)
    twitter_datum.each do |datum|
      twitter_keys.each do |key|
        key.include?("header") ? (value = nil) : (value = datum[key])
        data['table'][key] << value
      end
      data['table']['dates'] << "#{datum.start_date.strftime('%d %b')} - #{datum.end_date.strftime('%d %b')}"
      data['table']['new_subscriber'] << datum.new_subscribers
      data['table']['total_investment'] << datum.total_investment.round(2) 
      data['widths'] << 9
    end
  end

  def twitter_keys
    ['community_header', 'total_subscriber', 'interactivity_header','total_video_views',
      'inserted_player', 'mobile_devise', 'youtube_search', 'youtube_suggestion', 'youtube_page',
      'external_web_site', 'google_search', 'youtube_others', 'youtube_subscriptions', 'youtube_ads', 
      'investment_header', 'investment_agency', 'investment_actions', 'investment_anno']
  end

  def insert_community_chart(sheet)
    chart = create_chart(sheet, 83, "Comunidad")
    add_serie(chart, sheet["C13:#{@end_letter}13"], @labels, 'Suscriptores nuevos')
    add_serie(chart, sheet["C14:#{@end_letter}14"], @labels, '# followers')
    add_rows_report(sheet, 24)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.community]
  end

  def insert_interactivity_chart(sheet)
    chart = create_chart(sheet, 122, "Interactividad")
    add_serie(chart, sheet["C16:#{@end_letter}16"], @labels, 'Reproducciones videos en el periodo')
    add_serie(chart, sheet["C17:#{@end_letter}17"], @labels, 'Reproductor insertado')
    add_serie(chart, sheet["C18:#{@end_letter}18"], @labels, 'Dispositivos moviles')
    add_serie(chart, sheet["C19:#{@end_letter}19"], @labels, 'Busqueda de Youtube')
    add_serie(chart, sheet["C20:#{@end_letter}20"], @labels, 'Sugerencia de Youtube')
    add_serie(chart, sheet["C21:#{@end_letter}21"], @labels, 'Pagina de canal de Youtube')
    add_serie(chart, sheet["C22:#{@end_letter}22"], @labels, 'Sitio externo a Youtube')
    add_serie(chart, sheet["C23:#{@end_letter}23"], @labels, 'Busqueda de Google')
    add_serie(chart, sheet["C24:#{@end_letter}24"], @labels, 'Otras paginas de Youtube')
    add_serie(chart, sheet["C25:#{@end_letter}25"], @labels, 'Suscripciones de Youtube')
    add_serie(chart, sheet["C26:#{@end_letter}26"], @labels, 'Publicidad de Youtube')
    add_rows_report(sheet, 36)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.interaction]
  end

end