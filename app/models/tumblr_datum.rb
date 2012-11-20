class TumblrDatum < ActiveRecord::Base
  extend ApplicationHelper
  belongs_to :social_network

  def self.get_new_followers(datum)
    if !isFirstData?(datum)
      previous_data = TumblrDatum.where('end_date <= ? and social_network_id = ?', datum.start_date.to_date, datum.social_network_id).last
      return  datum.total_followers - previous_data.total_followers
    end
    return 0
  end

  def self.get_total_investment(datum)
    (datum.investment_agency + datum.investment_ads + datum.investment_actions) 
  end

	def self.isFirstData?(datum)
    previous_data = TumblrDatum.where('end_date < ? and social_network_id = ?',datum.start_date.to_date, datum.social_network_id).last
		(previous_data == nil) ? (return true) : (return false)
	end

  def self.generate_excel(document, social_id, start_date, end_date)
    document.workbook do | wb |
      wb.add_worksheet(:name => "Tumblr", :page_margins => margins, :page_setup => page_setup) do |sheet|
        @comments = TumblrComment.find_by_social_network_id(social_id)
        report_data = select_report_data(social_id, start_date, end_date)
        styles = create_report_styles(wb, report_data['size'])
        add_rows_report(sheet, 2)
        sheet.add_row ["","PAGINA DE TUMBLR"], :style => 3
        add_table(sheet, report_data, styles)
        add_rows_report(sheet, 16)
        add_charts(sheet, report_data['size'])
        add_rows_report(sheet, 14)
        add_images_report(sheet, 166, social_id, styles)
      end
    end
  end

  private

  def self.select_report_data(social_id, start_date, end_date)
    tumblr_datum = TumblrDatum.where('social_network_id = ? and start_date >= ? and end_date <= ?', social_id, start_date.to_date, end_date.to_date).order("start_date ASC")
    data = table_rows
    data['widths'] = [1, 32]
    data['size'] = (tumblr_datum.size+1)
    create_data_table(data, tumblr_datum)
    return data
  end

  def self.add_charts(sheet, size)
    @end_letter = (65 + size).chr
    @labels = sheet["C6:#{@end_letter}6"]
    sheet.add_row ["","GRAFICOS TUMBLR"], :style => 3
    add_rows_report(sheet, 2)
    insert_followers_chart(sheet)
    insert_interactivity_chart(sheet)
    insert_investment_chart(sheet)
  end

  def self.table_rows
    {
      'table' => {
        'dates' => ['',''], 'community_header' => ['','Comunidad'], 'new_followers' => ['','# nuevos followers'], 
        'total_followers' => ['','# followers'], 'interaction_header' => ['', 'Interactividad'], 'likes' => ['', '# like'],
        'reblogged' => ['','# reblogged'], 'investment_header' => ['','Inversion'], 'investment_agency' => ['', 'Inversion Agencia'], 
        'investment_actions' => ['','Inversion nuevas acciones'], 'investment_ads' => ['','Inversion anuncios'], 
        'total_investment' => ['','Inversion Total'],
      }
    }
  end

  def self.create_data_table(data, tuenti_datum)
    tuenti_datum.each do |datum|
      tuenti_keys.each do |key|
        key.include?("header") ? (value = nil) : (value = datum[key])
        data['table'][key] << value
      end
      data['table']['dates'] << "#{datum.start_date.strftime('%d %b')} - #{datum.end_date.strftime('%d %b')}"
      data['table']['total_investment'] << get_total_investment(datum).round(2)
      data['widths'] << 9
    end
  end

  def self.tuenti_keys
    ['community_header', 'new_followers', 'total_followers', 'interaction_header', 'likes', 'reblogged', 'investment_header', 
      'investment_agency', 'investment_actions', 'investment_ads']
  end

  def self.insert_followers_chart(sheet)
    chart = create_chart(sheet, 40, "Followers")
    add_serie(chart, sheet["C8:#{@end_letter}8"], @labels, '# nuevos followers')
    add_serie(chart, sheet["C9:#{@end_letter}9"], @labels, '# followers')
    add_rows_report(sheet, 24)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.followers]
  end

  def self.insert_interactivity_chart(sheet)
    chart = create_chart(sheet, 80, "Interactividad")
    add_serie(chart, sheet["C11:#{@end_letter}11"], @labels, '# like')
    add_serie(chart, sheet["C12:#{@end_letter}12"], @labels, '# reblogged')
    add_rows_report(sheet, 37)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.interactivity]
  end

  def self.insert_investment_chart(sheet)
    chart = create_chart(sheet, 122, "Inversion")
    add_serie(chart, sheet["C8:#{@end_letter}8"], @labels, '# nuevos followers')
    add_serie(chart, sheet["C17:#{@end_letter}17"], @labels, 'Inversion Total')
    add_rows_report(sheet, 39)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.investment]
  end

end
