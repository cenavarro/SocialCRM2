class PinterestDatum < ActiveRecord::Base
  extend ApplicationHelper
  belongs_to :social_network

  def self.get_new_followers(datum)
    if !isFirstData?(datum)
      previous_data = PinterestDatum.where('end_date < ? and social_network_id = ?', datum.start_date.to_date, datum.social_network_id).last
      return (datum.total_followers - previous_data.total_followers)
    end
    return 0
  end

  def self.get_total_investment(datum)
    (datum.investment_agency + datum.investment_ads + datum.investment_actions) 
  end

  def self.isFirstData?(datum)
    previous_data = PinterestDatum.where('end_date < ? and social_network_id = ?',datum.start_date.to_date, datum.social_network_id).last
		(previous_data == nil) ? (return true) : (return false)
  end

  def self.generate_excel(document, social_id, start_date, end_date)
    document.workbook do | wb |
      wb.add_worksheet(:name => "Pinterest", :page_margins => margins, :page_setup => page_setup) do |sheet|
        @comments = PinterestComment.find_by_social_network_id(social_id)
        report_data = select_report_data(social_id, start_date, end_date)
        styles = create_report_styles(wb, report_data['size'])
        add_rows_report(sheet, 2)
        sheet.add_row ["","PAGINA DE PINTEREST"], :style => 3
        add_table(sheet, report_data, styles)
        add_rows_report(sheet, 10)
        add_charts(sheet, report_data['size'])
        add_rows_report(sheet, 14)
        add_images_report(sheet, 164, social_id, styles)
      end
    end
  end

  private

  def self.select_report_data(social_id, start_date, end_date)
    pinterest_datum = PinterestDatum.where('social_network_id = ? and start_date >= ? and end_date <= ?', social_id, start_date.to_date, end_date.to_date).order("start_date ASC")
    data = table_rows
    data['widths'] = [1, 32]
    data['size'] = (pinterest_datum.size+1)
    create_data_table(data, pinterest_datum)
    return data
  end

  def self.add_charts(sheet, size)
    @end_letter = (65 + size).chr
    @labels = sheet["C6:#{@end_letter}6"]
    sheet.add_row ["","GRAFICOS PINTEREST"], :style => 3
    add_rows_report(sheet, 2)
    insert_followers_chart(sheet)
    insert_interactivity_chart(sheet)
    insert_investment_chart(sheet)
  end

  def self.table_rows
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

  def self.create_data_table(data, linkedin_datum)
    linkedin_datum.each do |datum|
      linkedin_keys.each do |key|
        key.include?("header") ? (value = nil) : (value = datum[key])
        data['table'][key] << value
      end
      data['table']['dates'] << "#{datum.start_date.strftime('%d %b')} - #{datum.end_date.strftime('%d %b')}"
      data['table']['total_investment'] << get_total_investment(datum).round(2)
      data['widths'] << 9
    end
  end

  def self.linkedin_keys
    ['community_header', 'new_followers', 'total_followers', 'interactions_header', 'boards', 'pins', 'liked', 
      'repin', 'comments', 'community_boards', 'investment_header', 'investment_agency', 'investment_actions',
        'investment_ads']
  end

  def self.insert_followers_chart(sheet)
    chart = create_chart(sheet, 38, "Comunidad")
    add_serie(chart, sheet["C8:#{@end_letter}8"], @labels, '# Nuevos Followers')
    add_serie(chart, sheet["C9:#{@end_letter}9"], @labels, '# Followers')
    add_serie(chart, sheet["C10:#{@end_letter}10"], @labels, '# boards')
    add_serie(chart, sheet["C11:#{@end_letter}11"], @labels, '# pins')
    add_rows_report(sheet, 24)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.comunity]
  end

  def self.insert_interactivity_chart(sheet)
    chart = create_chart(sheet, 78, "Interactividad")
    add_serie(chart, sheet["C13:#{@end_letter}13"], @labels, '# liked')
    add_serie(chart, sheet["C14:#{@end_letter}14"], @labels, '# repin')
    add_serie(chart, sheet["C15:#{@end_letter}15"], @labels, '# comments')
    add_serie(chart, sheet["C16:#{@end_letter}16"], @labels, '# community boards')
    add_rows_report(sheet, 37)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.interaction]
  end

  def self.insert_investment_chart(sheet)
    chart = create_chart(sheet, 120, "Inversion")
    add_serie(chart, sheet["C8:#{@end_letter}8"], @labels, '# nuevos followers')
    add_serie(chart, sheet["C21:#{@end_letter}21"], @labels, 'Inversion Total')
    add_rows_report(sheet, 39)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.investment]
  end

end
