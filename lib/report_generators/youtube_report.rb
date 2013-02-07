# encoding: utf-8
class ReportGenerators::YoutubeReport < ReportGenerators::Base

	def self.can_process? type
		type == YoutubeDatum
	end

  def add_to(document)
    if !youtube_datum.empty?
      add_information_to document
    end
  end

  private

  def youtube_datum
    social_network.youtube_data.where('start_date >= ? and end_date <= ?', start_date.to_date, end_date.to_date).order("start_date ASC").limit(6)
  end

  def add_information_to document
    initialize_variables document
    append_rows 5
    append_row_with ["PÁGINA DE YOUTUBE"], @styles['title']
    append_table
    append_charts
    append_rows 10
    append_images 174
    @worksheet.column_widths *columns_widths
    append_headers_and_footers
  end

  def append_charts
    remove_table_legends
    append_rows 25
    append_row_with ["GRÁFICOS YOUTUBE"], @styles['title']
    append_rows 2
    append_community_chart
    append_interactivity_chart
    append_interactivity_chart_2
    append_investment_chart
  end

  def select_report_data
    table = table_rows
    youtube_datum.each do |datum|
      youtube_keys.each do |key|
        is_header_or_dates_row?(key)  ? table[key] << nil : ( value = (datum[key].nil? ? datum.send(key.to_sym) : datum[key]))
        table[key] << number_with_precision(value, decimal_format) if !is_header_or_dates_row?(key)
      end
      table['dates'] << "#{datum.start_date.strftime('%d %b')} - #{datum.end_date.strftime('%d %b')}"
    end
    table
  end

  def append_community_chart
    create_chart(64, "Comunidad")
    add_serie(@report_data['new_subscriber'], 'Suscriptores nuevos')
    add_serie(@report_data['total_subscriber'], 'Suscriptores totales')
    append_rows 14
    append_comment_chart_for 2
  end

  def append_interactivity_chart
    create_chart(92, "Interactividad")
    add_serie(@report_data['total_video_views'], 'Reproducciones videos en el periodo')
    add_serie(@report_data['inserted_player'], 'Reproductor insertado')
    add_serie(@report_data['mobile_devise'], 'Dispositivos móviles')
    add_serie(@report_data['youtube_search'], 'Busqueda de Youtube')
    add_serie(@report_data['youtube_suggestion'], 'Sugerencia de Youtube')
    add_serie(@report_data['youtube_page'], 'Página de canal de Youtube')
    add_serie(@report_data['external_web_site'], 'Sitio externo a Youtube')
    add_serie(@report_data['google_search'], 'Búsqueda de Google')
    add_serie(@report_data['youtube_others'], 'Otras páginas de Youtube')
    add_serie(@report_data['youtube_subscriptions'], 'Suscripciones de Youtube')
    add_serie(@report_data['youtube_ads'], 'Publicidad de Youtube')
    append_rows 25
    append_comment_chart_for 3
  end

  def append_interactivity_chart_2
    create_chart(121, "Interactividad")
    add_serie(@report_data['likes'], 'Me gusta')
    add_serie(@report_data['no_likes'], 'No me gusta')
    add_serie(@report_data['favorite'], 'Favoritos')
    add_serie(@report_data['comments'], 'Comentarios')
    add_serie(@report_data['shared'], 'Compartidos')
    append_rows 26
    append_comment_chart_for 4
  end

  def append_investment_chart
    create_chart(150, "Inversión")
    add_serie(@report_data['new_subscriber'], 'Suscriptores nuevos')
    add_serie(@report_data['total_investment'], 'Inversión total')
    append_rows 26
    append_comment_chart_for 5
  end

  def youtube_keys
    keys = table_rows
    keys.shift
    keys.collect { |key, value| key  }
  end

  def set_headers_and_footers
    @headers ||= [0, 58, 87, 116, 145]
    @footers ||= [57, 86, 115, 144, 173]
  end

  def table_rows
    {
      'dates' => [''],
      'community_header' => ['Comunidad'],
      'new_subscribers' => ['Suscriptores nuevos'],
      'total_subscriber' => ['Suscriptores totales'],
      'interactivity_header' => ['Interactividad'],
      'total_video_views' => ['Reproducciones videos durante un periodo'],
      'inserted_player' => ['Reproductor insertado'],
      'mobile_devise' => ['Dispositivos móviles'],
      'youtube_search' => ['Búsqueda en Youtube'],
      'youtube_suggestion' => ['Sugerencia de Youtube'],
      'youtube_page' => ['Página de canal de Youtube'],
      'external_web_site' => ['Sitio web externo'],
      'google_search' => ['Búsqueda en Google'],
      'youtube_others' => ['Otras páginas de Youtube'],
      'youtube_subscriptions' => ['Suscripciones de Youtube'],
      'youtube_ads' => ['Publicidad de Youtube'],
      'likes' => ['Me gusta'],
      'no_likes' => ['No me gusta'],
      'favorite' => ['Favoritos'],
      'comments' => ['Comentarios'],
      'shared' => ['Compartidos'],
      'investment_header' => ['Inversión'], 
      'investment_agency' => ['Inversión agencia'],
      'investment_actions' => ['Inversión nuevas acciones'], 
      'investment_anno' => ['Inversión anuncios'],
      'total_investment' => ['Inversión total']
    }
  end

end
