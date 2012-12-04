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
          add_images_report(sheet, 123, social_network.id, styles)
          header(sheet, 0)
          footer(sheet, 38)
          sheet.column_widths 4, 31, 9, 9, 9, 9, 9, 9
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
    add_rows_report(sheet, 26)
    sheet.add_row ["","GRAFICOS FOURSQUARE"], :style => 3
    add_rows_report(sheet, 2)
    insert_followers_chart(sheet)
    insert_offers_chart(sheet)
    header(sheet, 39)
    footer(sheet, 80)
    header(sheet, 81)
    footer(sheet, 122)
  end

  def table_rows
    {
      'table' => {
        'dates' => ['',''], 'community_header' => ['','Comunidad'], 
        'new_followers' => ['','# nuevos followers'], 'total_followers' => ['','# followers'], 
        'total_unlocks' => ['','# unlocks total de las ofertas'], 'total_visits' => ['','# visitas total de las ofertas'],
      }
    }
  end

  def create_data_table(data, foursquare_datum)
    foursquare_datum.each do |datum|
      foursquare_keys.each do |key|
        key.include?("header") ? (value = nil) : (value = datum[key])
        data['table'][key] << value
      end
      data['table']['dates'] << "#{datum.start_date.strftime('%d %b')} - #{datum.end_date.strftime('%d %b')}"
      data['table']['new_followers'] << datum.new_followers
      data['widths'] << 9
    end
  end

  def foursquare_keys
    [ 'community_header', 'total_followers', 'total_unlocks', 'total_visits' ]
  end

  def insert_followers_chart(sheet)
    chart = create_chart(sheet, 49, "Followers")
    add_serie(chart, sheet["C13:#{@end_letter}13"], @labels, '# nuevos followers')
    add_serie(chart, sheet["C14:#{@end_letter}14"], @labels, '# followers')
    add_rows_report(sheet, 24)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.followers]
  end

  def insert_offers_chart(sheet)
    chart = create_chart(sheet, 88, "Ofertas")
    add_serie(chart, sheet["C15:#{@end_letter}15"], @labels, '# unlocks  total de ofertas')
    add_serie(chart, sheet["C16:#{@end_letter}16"], @labels, '# visitas total de las ofertas')
    add_rows_report(sheet, 36)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.deals]
  end
end
