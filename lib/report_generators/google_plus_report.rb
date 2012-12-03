class ReportGenerators::GooglePlusReport < ReportGenerators::Base

  def self.can_process? type
    type == GooglePlusDatum
  end

  def add_to(document)
    google_datum = social_network.google_plus_data.where('start_date >= ? and end_date <= ?', start_date.to_date, end_date.to_date).order("start_date ASC")
    if !google_datum.empty?
      document.workbook do | wb |
        wb.add_worksheet(:name => "Google+", :page_margins => margins, :page_setup => page_setup) do |sheet|
          @comments = social_network.google_plus_comment.first
          report_data = select_report_data(google_datum)
          styles = create_report_styles(wb, report_data['size'])
          add_rows_report(sheet, 7)
          sheet.add_row ["","PAGINA DE GOOGLE+"], :style => 3
          add_table(sheet, report_data, styles)
          add_rows_report(sheet, 12)
          add_charts(sheet, report_data['size'])
          add_rows_report(sheet, 15)
          add_images_report(sheet, 160, social_network.id, styles)
          header(sheet, 0)
          footer(sheet, 33)
          sheet.column_widths 4, 31, 9, 9, 9, 9, 9, 9
        end
      end
    end
  end

  private

  def select_report_data(google_datum)
    data = table_rows
    data['widths'] = [1, 32]
    data['size'] = (google_datum.size+1)
    create_data_table(data, google_datum)
    return data
  end

  def add_charts(sheet, size)
    @end_letter = (65 + size).chr
    @labels = sheet["C11:#{@end_letter}11"]
    sheet.add_row ["","GRAFICOS GOOGLE+"], :style => 3
    add_rows_report(sheet, 2)
    insert_community_chart(sheet)
    insert_interactivity_chart(sheet)
    insert_investment_chart(sheet)
    header(sheet, 34)
    footer(sheet, 75)
    header(sheet, 76)
    footer(sheet, 117)
    header(sheet, 118)
    footer(sheet, 159)
  end

  def table_rows
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

  def create_data_table(data, google_plus_datum)
    google_plus_datum.each do |datum|
      google_plus_keys.each do |key|
        key.include?("header") ? (value = nil) : (value = datum[key])
        data['table'][key] << value
      end
      data['table']['dates'] << "#{datum.start_date.strftime('%d %b')} - #{datum.end_date.strftime('%d %b')}"
      data['table']['new_followers'] << datum.new_followers
      data['table']['growth_followers'] << datum.get_percentage_difference_from_previous_total_followers.round(3)
      data['table']['total_interactions'] << datum.total_interactions
      data['table']['change_interactions'] << datum.get_percentage_difference_from_previous_total_interactions.round(3)
      data['table']['total_investment'] << datum.total_investment.round(2)
      data['widths'] << 9
    end
  end

  def google_plus_keys
    ['community_header', 'total_followers', 'interactions_header', 'plus', 'content_shared', 
      'investment_header', 'investment_agency', 'investment_actions', 'investment_ads']
  end

  def insert_community_chart(sheet)
    chart = create_chart(sheet, 44, "Comunidad")
    add_serie(chart, sheet["C13:#{@end_letter}13"], @labels, '# nuevos followers')
    add_serie(chart, sheet["C14:#{@end_letter}14"], @labels, '# followers')
    add_rows_report(sheet, 24)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.community]
  end

  def insert_interactivity_chart(sheet)
    chart = create_chart(sheet, 83, "Interactividad")
    add_serie(chart, sheet["C17:#{@end_letter}17"], @labels, '(+1s)')
    add_serie(chart, sheet["C18:#{@end_letter}18"], @labels, 'Compartir Contenido')
    add_serie(chart, sheet["C19:#{@end_letter}19"], @labels, 'Total Interacciones')
    add_rows_report(sheet, 36)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.interaction]
  end

  def insert_investment_chart(sheet)
    chart = create_chart(sheet, 125, "Inversion")
    add_serie(chart, sheet["C13:#{@end_letter}13"], @labels, '# nuevos contactos')
    add_serie(chart, sheet["C25:#{@end_letter}25"], @labels, 'Inversion Total')
    add_rows_report(sheet, 39)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.investment]
  end

end