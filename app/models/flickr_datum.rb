class FlickrDatum < ActiveRecord::Base
  extend ApplicationHelper
  belongs_to :social_network

  def self.get_new_contacts(datum)
    if !isFirstData?(datum)
      previous_data = FlickrDatum.where('end_date < ? and social_network_id = ?', datum.start_date.to_date, datum.social_network_id).last
      return (datum.total_contacts - previous_data.total_contacts)
    end
    return 0
  end

  def self.get_total_investment(datum)
    (datum.investment_agency + datum.investment_ads + datum.investment_actions) 
  end

  def self.isFirstData?(datum)
    previous_data = FlickrDatum.where('end_date < ? and social_network_id = ?',datum.start_date.to_date, datum.social_network_id).last
		(previous_data == nil) ? (return true) : (return false)
  end

  def self.generate_excel(document, social_id, start_date, end_date)
    document.workbook do | wb |
      wb.add_worksheet(:name => "Flickr", :page_margins => margins, :page_setup => page_setup) do |sheet|
        @comments = FlickrComment.find_by_social_network_id(social_id)
        report_data = select_report_data(social_id, start_date, end_date)
        styles = create_report_styles(wb, report_data['size'])
        add_rows_report(sheet, 2)
        sheet.add_row ["","PAGINA FLICKR"], :style => 3
        add_table(sheet, report_data, styles)
        add_rows_report(sheet, 15)
        add_charts(sheet, report_data['size'])
        add_rows_report(sheet, 14)
        add_images_report(sheet, 166, social_id, styles)
      end
    end
  end

  private

  def self.select_report_data(social_id, start_date, end_date)
    flickr_datum = FlickrDatum.where('social_network_id = ? and start_date >= ? and end_date <= ?', social_id, start_date.to_date, end_date.to_date).order("start_date ASC")
    data = table_rows
    data['widths'] = [1, 32]
    data['size'] = (flickr_datum.size+1)
    create_data_table(data, flickr_datum)
    return data
  end

  def self.add_charts(sheet, size)
    @end_letter = (65 + size).chr
    @labels = sheet["C6:#{@end_letter}6"]
    sheet.add_row ["","GRAFICOS FLICKR"], :style => 3
    add_rows_report(sheet, 2)
    insert_community_chart(sheet)
    insert_interactivity_chart(sheet)
    insert_investment_chart(sheet)
  end

  def self.table_rows
    {
      'table' => {
        'dates' => ['',''], 'community_header' => ['','Comunidad'], 'new_contacts' => ['','# nuevos contactos'], 
        'total_contacts' => ['','# contactos'], 'interactivity_header' => ['','Interactividad'], 'visits' => ['','# Visitas'],
        'comments' => ['','# Comentarios'], 'favorites' => ['', '# Favoritos'], 'investment_header' => ['','Inversion'], 
        'investment_agency' => ['','Inversion Agencia'], 'investment_actions' => ['', 'Inversion nuevas acciones'],
        'investment_ads' => ['','Inversion anuncios'], 'total_investment' => ['','Inversion Total']
      }
    }
  end

  def self.create_data_table(data, flickr_datum)
    flickr_datum.each do |datum|
      flickr_keys.each do |key|
        key.include?("header") ? (value = nil) : (value = datum[key])
        data['table'][key] << value
      end
      data['table']['dates'] << "#{datum.start_date.strftime('%d %b')} - #{datum.end_date.strftime('%d %b')}"
      data['table']['total_investment'] << get_total_investment(datum).round(2)
      data['widths'] << 9
    end
  end

  def self.flickr_keys
    [ 'community_header', 'new_contacts', 'total_contacts', 'interactivity_header', 'visits', 'comments', 'favorites', 
      'investment_header', 'investment_agency', 'investment_actions', 'investment_ads']
  end

  def self.insert_community_chart(sheet)
    chart = create_chart(sheet, 40, "Comunidad")
    add_serie(chart, sheet["C8:#{@end_letter}8"], @labels, '# nuevos contactos')
    add_serie(chart, sheet["C9:#{@end_letter}9"], @labels, '# contactos')
    add_rows_report(sheet, 24)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.community]
  end

  def self.insert_interactivity_chart(sheet)
    chart = create_chart(sheet, 80, "Interactividad")
    add_serie(chart, sheet["C11:#{@end_letter}11"], @labels, '# Visitas')
    add_serie(chart, sheet["C12:#{@end_letter}12"], @labels, '# Comentarios')
    add_serie(chart, sheet["C13:#{@end_letter}13"], @labels, '# Favorios') 
    add_rows_report(sheet, 37)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.interaction]
  end

  def self.insert_investment_chart(sheet)
    chart = create_chart(sheet, 122, "Inversion")
    add_serie(chart, sheet["C8:#{@end_letter}8"], @labels, '# nuevos contactos')
    add_serie(chart, sheet["C18:#{@end_letter}18"], @labels, 'Inversion Total')
    add_rows_report(sheet, 39)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.investment]
  end

end
