class LinkedinDatum < ActiveRecord::Base
  extend ApplicationHelper
  belongs_to :social_network

  def self.get_new_followers(datum)
    if !isFirstData?(datum)
      previous_data = LinkedinDatum.where('end_date < ? and social_network_id = ?', datum.start_date.to_date, datum.social_network_id).last
      return (datum.total_followers - previous_data.total_followers)
    end
    return 0
  end

  def self.get_growth_followers(datum)
    if !isFirstData?(datum)
      previous_data = LinkedinDatum.where('end_date < ? and social_network_id = ?', datum.start_date.to_date, datum.social_network_id).last
      (previous_data.total_followers != 0) ? (return (datum.new_followers.to_f/previous_data.total_followers.to_f)*100) : (return 100)
    end
    return 0
  end

  def self.get_views_page(datum)
    (datum.summary + datum.employment + datum.products_services)
  end

  def self.get_total_investment(datum)
    (datum.investment_agency + datum.investment_anno + datum.investment_actions) 
  end

  def self.isFirstData?(datum)
    previous_data = LinkedinDatum.where('end_date < ? and social_network_id = ?',datum.start_date.to_date, datum.social_network_id).last
    (previous_data == nil) ? (return true) : (return false)
  end

  def self.generate_excel(document, social_id, start_date, end_date)
    document.workbook do | wb |
      wb.add_worksheet(:name => "Linkedin", :page_margins => margins, :page_setup => page_setup) do |sheet|
        @comments = LinkedinComment.find_by_social_network_id(social_id)
        report_data = select_report_data(social_id, start_date, end_date)
        styles = create_report_styles(wb, report_data['size'])
        add_rows_report(sheet, 2)
        sheet.add_row ["","PAGINA DE LINKEDIN"], :style => 3
        add_table(sheet, report_data, styles)
        add_rows_report(sheet, 4)
        add_charts(sheet, report_data['size'])
        add_rows_report(sheet, 14)
        add_images_report(sheet, 120, social_id, styles)
      end
    end
  end

  private

  def self.select_report_data(social_id, start_date, end_date)
    linkedin_datum = LinkedinDatum.where('social_network_id = ? and start_date >= ? and end_date <= ?', social_id, start_date.to_date, end_date.to_date).order("start_date ASC")
    data = table_rows
    data['widths'] = [1, 32]
    data['size'] = (linkedin_datum.size+1)
    create_data_table(data, linkedin_datum)
    return data
  end

  def self.add_charts(sheet, size)
    @end_letter = (65 + size).chr
    @labels = sheet["C6:#{@end_letter}6"]
    sheet.add_row ["","GRAFICOS LINKEDIN"], :style => 3
    add_rows_report(sheet, 2)
    insert_followers_chart(sheet)
    insert_interactivity_chart(sheet)
  end

  def self.table_rows
    {
      'table' => {
        'dates' => ['',''], 'community_header' => ['','Comunidad'], 'new_followers' => ['','# Nuevos Followers'], 'total_followers' => ['','# Followers'], 
        'growth_followers' => ['', '% Crecimiento'], 'interactions_header' => ['', 'Interactividad'], 
        'views_pages' => ['', '# Visualizaciones de paginas'], 'summary' => ['', 'Resumen'],
        'employment' => ['', 'Empleo'], 'products_services' => ['','Productos y Servicios'], 'prints' => ['','Impresiones'],
        'clics' => ['','Clicks'], 'interest' => ['','% de interes'], 'recommendation' => ['','Recomendacion'], 'shared' => ['','Compartidos'],
        'investment_header' => ['','Inversion'], 'investment_agency' => ['', 'Inversion Agencia'], 'investment_actions' => ['','Inversion nuevas acciones'],
        'investment_anno' => ['','Inversion anuncios'], 'total_investment' => ['','Inversion Total']
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
      data['table']['growth_followers'] << get_growth_followers(datum).round(3)
      data['table']['views_pages'] << get_views_page(datum)
      data['table']['total_investment'] << get_total_investment(datum).round(2)
      data['widths'] << 9
    end
  end

  def self.linkedin_keys
    ['community_header', 'new_followers', 'total_followers', 'interactions_header', 'summary', 'employment', 'products_services', 
      'prints', 'clics', 'interest', 'recommendation', 'shared', 'investment_header', 'investment_agency', 'investment_actions',
        'investment_anno']
  end

  def self.insert_followers_chart(sheet)
    chart = create_chart(sheet, 36, "Seguidores")
    add_serie(chart, sheet["C8:#{@end_letter}8"], @labels, '# Nuevos Followers')
    add_serie(chart, sheet["C9:#{@end_letter}9"], @labels, '# Followers')
    add_rows_report(sheet, 24)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.comunity]
  end

  def self.insert_interactivity_chart(sheet)
    chart = create_chart(sheet, 76, "Interactividad")
    add_serie(chart, sheet["C13:#{@end_letter}13"], @labels, 'Resumen')
    add_serie(chart, sheet["C14:#{@end_letter}14"], @labels, 'Empleo')
    add_serie(chart, sheet["C15:#{@end_letter}15"], @labels, 'Productos y Servicios')
    add_serie(chart, sheet["C16:#{@end_letter}16"], @labels, 'Impresiones')
    add_serie(chart, sheet["C17:#{@end_letter}17"], @labels, 'Clicks')
    add_serie(chart, sheet["C18:#{@end_letter}18"], @labels, '% interest')
    add_serie(chart, sheet["C19:#{@end_letter}19"], @labels, 'Recomendacion')
    add_serie(chart, sheet["C20:#{@end_letter}20"], @labels, 'Compartidos')
    add_rows_report(sheet, 37)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.interaction]
  end

end
