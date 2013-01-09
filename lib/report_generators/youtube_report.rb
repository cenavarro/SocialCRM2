# encoding: utf-8
class ReportGenerators::YoutubeReport < ReportGenerators::Base

	def self.can_process? type
		type == YoutubeDatum
	end

  def add_to(document)
    if !youtube_datum.empty?
      @report_data = select_report_data
      set_headers_and_footers
      create_report(document)
      append_headers_and_footers
    end
  end

  private

  def youtube_datum
    social_network.youtube_data.where('start_date >= ? and end_date <= ?', start_date.to_date, end_date.to_date).order("start_date ASC").limit(6)
  end

  def create_report(document)
    set_workbook_and_worksheet(document)
    create_report_styles(youtube_datum.size + 1)
    append_rows_to_report 7
    @worksheet.add_row ["","PAGINA DE YOUTUBE"], :style => 3
    add_table_to_report
    append_charts_to_report
    append_rows_to_report 15
    add_images_report 239
    @worksheet.column_widths 4, 31, 9, 9, 9, 9, 9, 9
  end

  def append_charts_to_report
    remove_cells_report_table
    append_rows_to_report 38
    @worksheet.add_row ["","GRAFICOS YOUTUBE"], :style => 3
    append_rows_to_report 2
    append_community_chart
    append_interactivity_chart
    append_interactivity_chart_2
    append_investment_chart
  end

  def table_rows
    {
      'dates' => ['',''], 'community_header' => ['','Comunidad'], 'new_subscriber' => ['','Suscriptores nuevos'], 
      'total_subscriber' => ['','Suscriptores totales'], 'interactivity_header' => ['', 'Interactividad'],
      'total_video_views' => ['','Reproducciones videos durante un periodo'], 'inserted_player' => ['', 'Reproductor insertado'],
      'mobile_devise' => ['', 'Dispositivos móviles'], 'youtube_search' => ['', 'Búsqueda en Youtube'],
      'youtube_suggestion' => ['', 'Sugerencia de Youtube'], 'youtube_page' => ['', 'Página de canal de Youtube'],
      'external_web_site' => ['', 'Sitio web externo'], 'google_search' => ['', 'Búsqueda en Google'],
      'youtube_others' => ['', 'Otras páginas de Youtube'], 'youtube_subscriptions' => ['', 'Suscripciones de Youtube'],
      'youtube_ads' => ['', 'Publicidad de Youtube'], 'likes' => ['','Me gusta'],
      'no_likes' => ['','No me gusta'], 'favorite' => ['','Favoritos'], 'comments' => ['', 'Comentarios'],
      'shared' => ['','Compartidos'], 'investment_header' => ['','Inversión'], 
      'investment_agency' => ['', 'Inversión agencia'], 'investment_actions' => ['','Inversión nuevas acciones'], 
      'investment_anno' => ['','Inversión anuncios'], 'total_investment' => ['','Inversión total']
    }
  end

  def select_report_data
    table = table_rows
    youtube_datum.each do |datum|
      youtube_keys.each do |key|
        key.include?("header") ? (value = nil) : (value = datum[key])
        table[key] << value
      end
      table['dates'] << "#{datum.start_date.strftime('%d %b')} - #{datum.end_date.strftime('%d %b')}"
      table['new_subscriber'] << datum.new_subscribers
      table['total_investment'] << datum.total_investment.round(2) 
    end
    table
  end

  def youtube_keys
    ['community_header', 'total_subscriber', 'interactivity_header','total_video_views',
      'inserted_player', 'mobile_devise', 'youtube_search', 'youtube_suggestion', 'youtube_page',
      'external_web_site', 'google_search', 'youtube_others', 'youtube_subscriptions', 'youtube_ads', 
      'investment_header', 'investment_agency', 'investment_actions', 'investment_anno', 'likes',
      'no_likes', 'favorite', 'comments', 'shared'
    ]
  end

  def append_community_chart
    chart = create_chart(81, "Comunidad")
    add_serie(chart, @report_data['new_subscriber'], @report_data['dates'], 'Suscriptores nuevos')
    add_serie(chart, @report_data['total_subscriber'], @report_data['dates'], 'Suscriptores totales')
    append_rows_to_report 24
    @worksheet.add_row ["", "Comentario"], :style => 3
    append_rows_to_report 1
    @worksheet.add_row ["", history_comment_for(2).content] if !history_comment_for(2).nil?
  end

  def append_interactivity_chart
    chart = create_chart(120, "Interactividad")
    add_serie(chart, @report_data['total_video_views'], @report_data['dates'], 'Reproducciones videos en el periodo')
    add_serie(chart, @report_data['inserted_player'], @report_data['dates'], 'Reproductor insertado')
    add_serie(chart, @report_data['mobile_devise'], @report_data['dates'], 'Dispositivos móviles')
    add_serie(chart, @report_data['youtube_search'], @report_data['dates'], 'Busqueda de Youtube')
    add_serie(chart, @report_data['youtube_suggestion'], @report_data['dates'], 'Sugerencia de Youtube')
    add_serie(chart, @report_data['youtube_page'], @report_data['dates'], 'Página de canal de Youtube')
    add_serie(chart, @report_data['external_web_site'], @report_data['dates'], 'Sitio externo a Youtube')
    add_serie(chart, @report_data['google_search'], @report_data['dates'], 'Búsqueda de Google')
    add_serie(chart, @report_data['youtube_others'], @report_data['dates'], 'Otras páginas de Youtube')
    add_serie(chart, @report_data['youtube_subscriptions'], @report_data['dates'], 'Suscripciones de Youtube')
    add_serie(chart, @report_data['youtube_ads'], @report_data['dates'], 'Publicidad de Youtube')
    append_rows_to_report 36
    @worksheet.add_row ["", "Comentario"], :style => 3
    append_rows_to_report 1
    @worksheet.add_row ["", history_comment_for(3).content] if !history_comment_for(3).nil?
  end

  def append_interactivity_chart_2
    chart = create_chart(162, "Interactividad")
    add_serie(chart, @report_data['likes'], @report_data['dates'], 'Me gusta')
    add_serie(chart, @report_data['no_likes'], @report_data['dates'], 'No me gusta')
    add_serie(chart, @report_data['favorite'], @report_data['dates'], 'Favoritos')
    add_serie(chart, @report_data['comments'], @report_data['dates'], 'Comentarios')
    add_serie(chart, @report_data['shared'], @report_data['dates'], 'Compartidos')
    append_rows_to_report 39
    @worksheet.add_row ["", "Comentario"], :style => 3
    append_rows_to_report 1
    @worksheet.add_row ["", history_comment_for(4).content] if !history_comment_for(4).nil?
  end

  def append_investment_chart
    chart = create_chart(204, "Inversión")
    add_serie(chart, @report_data['new_subscriber'], @report_data['dates'], 'Suscriptores nuevos')
    add_serie(chart, @report_data['total_investment'], @report_data['dates'], 'Inversión total')
    append_rows_to_report 39
    @worksheet.add_row ["", "Comentario"], :style => 3
    append_rows_to_report 1
    @worksheet.add_row ["", history_comment_for(5).content] if !history_comment_for(5).nil?
  end

  def set_headers_and_footers
    @headers ||= [0, 71, 113, 155, 197]
    @footers ||= [70, 112, 154, 196, 238]
  end

end
