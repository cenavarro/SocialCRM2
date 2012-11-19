class FoursquareDatum < ActiveRecord::Base
  extend ApplicationHelper
  belongs_to :social_network

  def self.get_new_followers(datum)
    if !isFirstData?(datum)
      previous_data = FoursquareDatum.where('end_date < ? and social_network_id = ?', datum.start_date.to_date, datum.social_network_id).last
      return (datum.total_followers - previous_data.total_followers)
    end
    return 0
  end

  def self.isFirstData?(datum)
    previous_data = FoursquareDatum.where('end_date < ? and social_network_id = ?',datum.start_date.to_date, datum.social_network_id).last
		(previous_data == nil) ? (return true) : (return false)
  end

  def self.generate_excel(document, social_id, start_date, end_date)
    document.workbook do | wb |
      wb.add_worksheet(:name => "Foursquare", :page_margins => margins, :page_setup => page_setup) do |sheet|
        @comments = FoursquareComment.find_by_social_network_id(social_id)
        report_data = select_report_data(social_id, start_date, end_date)
        styles = create_report_styles(wb, report_data['size'])
        add_rows_report(sheet, 2)
        sheet.add_row ["","PAGINA DE FOURSQUARE"], :style => 3
        add_table(sheet, report_data, styles)
        add_rows_report(sheet, 26)
        add_charts(sheet, report_data['size'])
        add_rows_report(sheet, 14)
        add_images_report(sheet, 128, social_id, styles)
      end
    end
  end

  private

  def self.select_report_data(social_id, start_date, end_date)
    foursquare_datum = FoursquareDatum.where('social_network_id = ? and start_date >= ? and end_date <= ?', social_id, start_date.to_date, end_date.to_date).order("start_date ASC")
    data = table_rows
    data['widths'] = [1, 32]
    data['size'] = (foursquare_datum.size+1)
    create_data_table(data, foursquare_datum)
    return data
  end

  def self.add_charts(sheet, size)
    @end_letter = (65 + size).chr
    @labels = sheet["C6:#{@end_letter}6"]
    sheet.add_row ["","GRAFICOS FOURSQUARE"], :style => 3
    add_rows_report(sheet, 2)
    insert_followers_chart(sheet)
    insert_offers_chart(sheet)
  end

  def self.table_rows
    {
      'table' => {
        'dates' => ['',''], 'community_header' => ['','Comunidad'], 
        'new_followers' => ['','# nuevos followers'], 'total_followers' => ['','# followers'], 
        'total_unlocks' => ['','# unlocks total de las ofertas'], 'total_visits' => ['','# visitas total de las ofertas'],
      }
    }
  end

  def self.create_data_table(data, foursquare_datum)
    foursquare_datum.each do |datum|
      foursquare_keys.each do |key|
        key.include?("header") ? (value = nil) : (value = datum[key])
        data['table'][key] << value
      end
      data['table']['dates'] << "#{datum.start_date.strftime('%d %b')} - #{datum.end_date.strftime('%d %b')}"
      data['widths'] << 9
    end
  end

  def self.foursquare_keys
    [ 'community_header', 'new_followers', 'total_followers', 'total_unlocks', 'total_visits' ]
  end

  def self.insert_followers_chart(sheet)
    chart = create_chart(sheet, 44, "Followers")
    add_serie(chart, sheet["C8:#{@end_letter}8"], @labels, '# nuevos followers')
    add_serie(chart, sheet["C9:#{@end_letter}9"], @labels, '# followers')
    add_rows_report(sheet, 24)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.followers]
  end

  def self.insert_offers_chart(sheet)
    chart = create_chart(sheet, 84, "Ofertas")
    add_serie(chart, sheet["C10:#{@end_letter}10"], @labels, '# unlocks  total de ofertas')
    add_serie(chart, sheet["C11:#{@end_letter}11"], @labels, '# visitas total de las ofertas')
    add_rows_report(sheet, 37)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.deals]
  end

end
