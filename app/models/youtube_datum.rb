class YoutubeDatum < ActiveRecord::Base
  extend ApplicationHelper
  belongs_to :social_network

  def self.get_new_subscribers(datum)
    if !isFirstData?(datum)
      previous_data = YoutubeDatum.where('end_date < ? and social_network_id = ?', datum.start_date.to_date, datum.social_network_id).first
      return (datum.total_subscriber - previous_data.total_subscriber)
    end
    return 0
  end

  def self.get_total_investment(datum)
    (datum.investment_agency + datum.investment_anno + datum.investment_actions) 
  end

  def self.isFirstData?(datum)
    previous_data = YoutubeDatum.where('end_date < ? and social_network_id = ?',datum.start_date.to_date, datum.social_network_id).first
    (previous_data == nil) ? (return true) : (return false)
  end

  def self.generate_excel(document, social_id, start_date, end_date)
    @comments = YoutubeComment.find_by_social_network_id(social_id)
    document.workbook do | wb |
      wb.add_worksheet(:name => "Youtube", :page_margins => margins, :page_setup => page_setup) do |sheet|
        report_data = select_report_data(social_id, start_date, end_date)
        styles = create_report_styles(wb, report_data['size'])
        add_rows_report(sheet, 2)
        sheet.add_row ["","PAGINA DE YOUTUBE"], :style => 3
        add_table(sheet, report_data, styles)
        add_rows_report(sheet, 3)
        add_charts(sheet, report_data['size'])
        add_rows_report(sheet, 14)
        add_images_report(sheet, 120, social_id, styles)
      end
    end
  end

  private

  def self.select_report_data(social_id, start_date, end_date)
    tumblr_datum = YoutubeDatum.where('social_network_id = ? and start_date >= ? and end_date <= ?', social_id, start_date.to_date, end_date.to_date).order("start_date ASC")
    data = table_rows
    data['widths'] = [1, 32]
    data['size'] = (tumblr_datum.size+1)
    create_data_table(data, tumblr_datum)
    return data
  end

  def self.add_charts(sheet, size)
    @end_letter = (65 + size).chr
    @labels = sheet["C6:#{@end_letter}6"]
    sheet.add_row ["","GRAFICOS TWITTER"], :style => 3
    add_rows_report(sheet, 2)
    insert_community_chart(sheet)
    insert_interactivity_chart(sheet)
  end

  def self.table_rows
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

  def self.create_data_table(data, twitter_datum)
    twitter_datum.each do |datum|
      twitter_keys.each do |key|
        key.include?("header") ? (value = nil) : (value = datum[key])
        data['table'][key] << value
      end
      data['table']['dates'] << "#{datum.start_date.strftime('%d %b')} - #{datum.end_date.strftime('%d %b')}"
      data['table']['total_investment'] << get_total_investment(datum).round(2) 
      data['widths'] << 9
    end
  end

  def self.twitter_keys
    ['community_header', 'new_subscriber', 'total_subscriber', 'interactivity_header','total_video_views',
      'inserted_player', 'mobile_devise', 'youtube_search', 'youtube_suggestion', 'youtube_page',
      'external_web_site', 'google_search', 'youtube_others', 'youtube_subscriptions', 'youtube_ads', 
      'investment_header', 'investment_agency', 'investment_actions', 'investment_anno']
  end

  def self.insert_community_chart(sheet)
    chart = create_chart(sheet, 36, "Comunidad")
    add_serie(chart, sheet["C8:#{@end_letter}8"], @labels, 'Suscriptores nuevos')
    add_serie(chart, sheet["C9:#{@end_letter}9"], @labels, '# followers')
    add_rows_report(sheet, 24)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.community]
  end

  def self.insert_interactivity_chart(sheet)
    chart = create_chart(sheet, 76, "Interactividad")
    add_serie(chart, sheet["C11:#{@end_letter}11"], @labels, 'Reproducciones videos en el periodo')
    add_serie(chart, sheet["C12:#{@end_letter}12"], @labels, 'Reproductor insertado')
    add_serie(chart, sheet["C13:#{@end_letter}13"], @labels, 'Dispositivos moviles')
    add_serie(chart, sheet["C14:#{@end_letter}14"], @labels, 'Busqueda de Youtube')
    add_serie(chart, sheet["C15:#{@end_letter}15"], @labels, 'Sugerencia de Youtube')
    add_serie(chart, sheet["C16:#{@end_letter}16"], @labels, 'Pagina de canal de Youtube')
    add_serie(chart, sheet["C17:#{@end_letter}17"], @labels, 'Sitio externo a Youtube')
    add_serie(chart, sheet["C18:#{@end_letter}18"], @labels, 'Busqueda de Google')
    add_serie(chart, sheet["C19:#{@end_letter}19"], @labels, 'Otras paginas de Youtube')
    add_serie(chart, sheet["C20:#{@end_letter}20"], @labels, 'Suscripciones de Youtube')
    add_serie(chart, sheet["C21:#{@end_letter}21"], @labels, 'Publicidad de Youtube')
    add_rows_report(sheet, 37)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.interaction]
  end

end
