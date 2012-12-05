class ReportGenerators::FoursquareReport < ReportGenerators::Base

  def self.can_process? type
    type == FoursquareDatum
  end

  def add_to(document)
    foursquare_datum = social_network.foursquare_data.where('start_date >= ? and end_date <= ?', start_date.to_date, end_date.to_date).order("start_date ASC")
    if !foursquare_datum.empty?
      document.workbook do | wb |
        wb.add_worksheet(:name => social_network.name, :page_margins => margins, :page_setup => page_setup) do |sheet|
          @comments = social_network.foursquare_comment.where("social_network_id = ?", social_network.id).first
          report_data = select_report_data(foursquare_datum)
          styles = create_report_styles(wb, report_data['size'])
          add_rows_report(sheet, 7)
          sheet.add_row ["","PAGINA DE FOURSQUARE"], :style => 3
          add_table(sheet, report_data, styles)
          add_charts(sheet, report_data['size'])
          add_rows_report(sheet, 15)
          add_images_report(sheet, 159, social_network.id, styles)
          sheet.column_widths 4, 31, 9, 9, 9, 9, 9, 9
          add_headers_and_footers(sheet)
        end
      end
    end
  end

  private

  def select_report_data(foursquare_datum)
    data = table_rows
    data['widths'] = [1, 32]
    data['size'] = (foursquare_datum.size+1)
    create_data_table(data, foursquare_datum)
    return data
  end

  def add_charts(sheet, size)
    @end_letter = (65 + size).chr
    @labels = sheet["C11:#{@end_letter}11"]
    add_rows_report(sheet, 10)
    sheet.add_row ["","GRAFICOS FOURSQUARE"], :style => 3
    add_rows_report(sheet, 2)
    insert_followers_chart(sheet)
    insert_interactivity_chart(sheet)
    insert_offers_chart(sheet)
  end

  def table_rows
    {
      'table' => {
        'dates' => ['',''], 'community_header' => ['','Comunidad'], 
        'new_followers' => ['','# nuevos followers'], 'total_followers' => ['','# followers'],
        'interactivity_header' => ['', 'Interactividad'], 'clients' => ['','#clientes'], 
        'diff_clients' => ['', '% diferencia'], 'likes' => ['', '#me gusta'], 'diff_likes' => ['', '% diferencia'], 
        'checkins' => ['', '#check-ins'], 'diff_checkins' => ['', '% diferencia'],
        'campaign_header' => ['','Campana'],
        'total_unlocks' => ['','# unlocks total de las ofertas'], 'diff_unlocks' => ['', '% diferencia'],
        'total_visits' => ['','# visitas total de las ofertas'], 'diff_visits' => ['', '% diferencia']
      }
    }
  end

  def create_data_table(data, foursquare_datum)
    foursquare_datum.each do |datum|
      foursquare_keys.each do |key|
        key.include?("header") ? (value = nil; p "key: #{key}" ) : (value = datum[key])
        data['table'][key] << value
      end
      data['table']['dates'] << "#{datum.start_date.strftime('%d %b')} - #{datum.end_date.strftime('%d %b')}"
      data['table']['new_followers'] << datum.new_followers
      data['table']['diff_clients'] << datum.get_percentage_difference_from_previous_clients
      data['table']['diff_likes'] << datum.get_percentage_difference_from_previous_likes
      data['table']['diff_checkins'] << datum.get_percentage_difference_from_previous_checkins
      data['table']['diff_unlocks'] << datum.get_percentage_difference_from_previous_total_unlocks
      data['table']['diff_visits'] << datum.get_percentage_difference_from_previous_total_visits
      data['widths'] << 9
    end
  end

  def foursquare_keys
    [ 'community_header', 'interactivity_header', 'campaign_header', 'total_followers', 'total_unlocks', 'total_visits', 'clients', 'likes', 'checkins' ]
  end

  def insert_followers_chart(sheet)
    chart = create_chart(sheet, 43, "Comunidad")
    add_serie(chart, sheet["C13:#{@end_letter}13"], @labels, '# nuevos followers')
    add_serie(chart, sheet["C14:#{@end_letter}14"], @labels, '# followers')
    add_rows_report(sheet, 24)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.followers]
  end

  def insert_interactivity_chart(sheet)
    chart = create_chart(sheet, 82, "Interactividad")
    add_serie(chart, sheet["C16:#{@end_letter}16"], @labels, '#clientes')
    add_serie(chart, sheet["C18:#{@end_letter}18"], @labels, '#me gusta')
    add_serie(chart, sheet["C20:#{@end_letter}20"], @labels, '#check-ins')
    add_rows_report(sheet, 36)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.interactivity]
  end

  def insert_offers_chart(sheet)
    chart = create_chart(sheet, 124, "Interactividad (Ofertas)")
    add_serie(chart, sheet["C23:#{@end_letter}23"], @labels, '# unlocks  total de ofertas')
    add_serie(chart, sheet["C25:#{@end_letter}25"], @labels, '# visitas total de las ofertas')
    add_rows_report(sheet, 39)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.deals]
  end

  def headers
    @header_positions ||= [0, 33, 75, 117]
  end

  def footers
    @footer_positions ||= [32, 74, 116, 157]
  end

  def add_headers_and_footers(sheet)
    for i in (0..headers.size-1)
      header(sheet, headers[i])
      footer(sheet, footers[i])
    end
  end
end
