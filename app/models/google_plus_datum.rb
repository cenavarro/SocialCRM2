class GooglePlusDatum < ActiveRecord::Base
  extend ApplicationHelper
  belongs_to :social_network

  def self.get_new_followers(datum)
    if !isFirstData?(datum)
      previous_data = GooglePlusDatum.where('end_date < ? and social_network_id = ?', datum.start_date.to_date, datum.social_network_id).last
      return (datum.total_followers - previous_data.total_followers)
    end
    return 0
  end

  def self.get_total_investment(datum)
    (datum.investment_agency + datum.investment_ads + datum.investment_actions) 
  end

  def self.get_grown_followers(datum)
    if !isFirstData?(datum)
      previous_data = GooglePlusDatum.where('end_date < ? and social_network_id = ?', datum.start_date.to_date, datum.social_network_id).last
      return ((datum.total_followers-previous_data.total_followers).to_f/previous_data.total_followers.to_f)*100 if previous_data.total_followers != 0
    end
    return 0
  end

  def self.get_total_interactions(datum)
    return (datum.plus + datum.content_shared)
  end

  def self.get_change_interactions(datum)
    if !isFirstData?(datum)
      previous_data = GooglePlusDatum.where('end_date < ? and social_network_id = ?', datum.start_date.to_date, datum.social_network_id).last
      total_interactions = GooglePlusDatum.get_total_interactions(datum)
      previous_total_interactions = GooglePlusDatum.get_total_interactions(previous_data)
      return ((total_interactions-previous_total_interactions).to_f/previous_total_interactions.to_f)*100 if previous_total_interactions != 0
    end
    return 0
  end

  def self.isFirstData?(datum)
    previous_data = GooglePlusDatum.where('end_date < ? and social_network_id = ?',datum.start_date.to_date, datum.social_network_id).last
    (previous_data == nil) ? (return true) : (return false)
  end

  def self.generate_excel(document, social_id, start_date, end_date)
    document.workbook do | wb |
      wb.add_worksheet(:name => "Google+", :page_margins => margins, :page_setup => page_setup) do |sheet|
        @comments = GooglePlusComment.find_by_social_network_id(social_id)
        report_data = select_report_data(social_id, start_date, end_date)
        styles = create_report_styles(wb, report_data['size'])
        add_rows_report(sheet, 2)
        sheet.add_row ["","PAGINA DE GOOGLE+"], :style => 3
        add_table(sheet, report_data, styles)
        add_rows_report(sheet, 12)
        add_charts(sheet, report_data['size'])
        add_rows_report(sheet, 14)
        add_images_report(sheet, 165, social_id, styles)
      end
    end
  end

  private

  def self.select_report_data(social_id, start_date, end_date)
    foursquare_datum = GooglePlusDatum.where('social_network_id = ? and start_date >= ? and end_date <= ?', social_id, start_date.to_date, end_date.to_date).order("start_date ASC")
    data = table_rows
    data['widths'] = [1, 32]
    data['size'] = (foursquare_datum.size+1)
    create_data_table(data, foursquare_datum)
    return data
  end

  def self.add_charts(sheet, size)
    @end_letter = (65 + size).chr
    @labels = sheet["C6:#{@end_letter}6"]
    sheet.add_row ["","GRAFICOS GOOGLE+"], :style => 3
    add_rows_report(sheet, 2)
    insert_community_chart(sheet)
    insert_interactivity_chart(sheet)
    insert_investment_chart(sheet)
  end

  def self.table_rows
    {
      'table' => {
        'dates' => ['',''], 'community_header' => ['','Comunidad'], 'new_followers' => ['','# nuevos followers'], 'total_followers' => ['','# followers'], 
        'growth_followers' => ['', '% crecimiento seguidores'], 'interactions_header' => ['', 'Interactividad'], 'plus' => ['', '(+1s)'],
        'content_shared' => ['', 'Compartir contenido'], 'total_interactions' => ['','Total de Interacciones'], 'change_interactions' => ['','% cambio en interacciones'],
        'investment_header' => ['','Inversion'], 'investment_agency' => ['', 'Inversion Agencia'], 'investment_actions' => ['','Inversion nuevas acciones'],
        'investment_ads' => ['','Inversion anuncios'], 'total_investment' => ['','Inversion Total']
      }
    }
  end

  def self.create_data_table(data, google_plus_datum)
    google_plus_datum.each do |datum|
      google_plus_keys.each do |key|
        key.include?("header") ? (value = nil) : (value = datum[key])
        data['table'][key] << value
      end
      data['table']['dates'] << "#{datum.start_date.strftime('%d %b')} - #{datum.end_date.strftime('%d %b')}"
      data['table']['growth_followers'] << get_grown_followers(datum).round(3)
      data['table']['total_interactions'] << get_total_interactions(datum)
      data['table']['change_interactions'] << get_change_interactions(datum).round(3)
      data['table']['total_investment'] << get_total_investment(datum).round(2)
      data['widths'] << 9
    end
  end

  def self.google_plus_keys
    ['community_header', 'new_followers', 'total_followers', 'interactions_header', 'plus', 'content_shared', 
      'investment_header', 'investment_agency', 'investment_actions', 'investment_ads']
  end

  def self.insert_community_chart(sheet)
    chart = create_chart(sheet, 39, "Comunidad")
    add_serie(chart, sheet["C8:#{@end_letter}8"], @labels, '# nuevos contactos')
    add_serie(chart, sheet["C9:#{@end_letter}9"], @labels, '# contactos')
    add_rows_report(sheet, 24)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.community]
  end

  def self.insert_interactivity_chart(sheet)
    chart = create_chart(sheet, 79, "Interactividad")
    add_serie(chart, sheet["C12:#{@end_letter}12"], @labels, '(+1s)')
    add_serie(chart, sheet["C13:#{@end_letter}13"], @labels, 'Compartir Contenido')
    add_serie(chart, sheet["C14:#{@end_letter}14"], @labels, 'Total Interacciones')
    add_rows_report(sheet, 37)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.interaction]
  end

  def self.insert_investment_chart(sheet)
    chart = create_chart(sheet, 121, "Inversion")
    add_serie(chart, sheet["C8:#{@end_letter}8"], @labels, '# nuevos contactos')
    add_serie(chart, sheet["C20:#{@end_letter}20"], @labels, 'Inversion Total')
    add_rows_report(sheet, 39)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.investment]
  end

end
