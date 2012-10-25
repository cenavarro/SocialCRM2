class BlogDatum < ActiveRecord::Base
  extend ApplicationHelper
  belongs_to :social_network

  def self.get_diff_unique_visits(datum)
    if !isFirstData?(datum)
      previous_data = BlogDatum.where('end_date < ? and social_network_id = ?', datum.start_date.to_date, datum.social_network_id).last
      return ((datum.unique_visits-previous_data.unique_visits).to_f/previous_data.unique_visits.to_f)*100 if previous_data.unique_visits != 0
    end
    return 0 
  end

  def self.get_diff_views_pages(datum)
    if !isFirstData?(datum)
      previous_data = BlogDatum.where('end_date < ? and social_network_id = ?', datum.start_date.to_date, datum.social_network_id).last
      return ((datum.view_pages-previous_data.view_pages).to_f/previous_data.view_pages.to_f)*100 if previous_data.view_pages != 0
    end
    return 0 
  end

  def self.isFirstData?(datum)
    previous_data = BlogDatum.where('end_date < ? and social_network_id = ?',datum.start_date.to_date, datum.social_network_id).last
		(previous_data == nil) ? (return true) : (return false)
  end

  def self.select_report_data(social_id, start_date, end_date)
    blog_datum = BlogDatum.where('social_network_id = ? and start_date >= ? and end_date <= ?', social_id, start_date.to_date, end_date.to_date).order("start_date ASC")
    data = {:dates => [''], :visits_header => ['Visitas'], :visits => ['visitas unicas'], :diff_visits => ['% diferencia'], 
      :view_pages => ['# paginas vistas'], :diff_view => ['% diferencia'],
      :percentage_header => ['Porcentajes'], :rebound_percent => ['Porcentaje de Rebote'], 
      :new_visits => ['Porcentaje de visitas nuevas'], :total_posts => ['# de posts'], :widths => [25], :heights => [10], :size => blog_datum.size}
    blog_datum.each do |datum|
      data[:dates] << "#{datum.start_date.strftime('%d %b')} - #{datum.end_date.strftime('%d %b')}"
      data[:visits] << datum.unique_visits 
      data[:diff_visits] << BlogDatum.get_diff_unique_visits(datum).round(2)
      data[:view_pages] << datum.view_pages
      data[:diff_view] << BlogDatum.get_diff_views_pages(datum).round(2)
      data[:rebound_percent] << datum.rebound_percent
      data[:new_visits] << datum.new_visits_percent
      data[:total_posts] << datum.total_posts
      data[:widths] << 14
      data[:visits_header] << nil
      data[:percentage_header] << nil
    end
    return data
  end

  def self.insert_report_table(sheet, report_data, styles)
    sheet.add_row report_data[:dates], :style => styles[:dates], :height => 20
    sheet.add_row report_data[:visits_header], :style => styles[:cell_header], :height => 20
    sheet.add_row report_data[:visits] , :widths => report_data[:widths], :style => styles[:basic], :height => 20
    sheet.add_row report_data[:diff_visits], :style => styles[:basic], :height => 20
    sheet.add_row report_data[:view_pages], :style => styles[:basic], :height => 20
    sheet.add_row report_data[:diff_view], :style => styles[:basic], :height => 20
    sheet.add_row report_data[:percentage_header], :style => styles[:cell_header], :height => 20
    sheet.add_row report_data[:rebound_percent], :style => styles[:basic], :height => 20
    sheet.add_row report_data[:new_visits], :style => styles[:basic], :height => 20
    sheet.add_row report_data[:total_posts], :style => styles[:basic], :height => 20
  end

  def self.generate_excel(document, social_id, start_date, end_date)
    document.workbook do | wb |
      wb.add_worksheet(:name => "Blog") do |sheet|
        report_data = select_report_data(social_id, start_date, end_date)
        styles = create_report_styles(wb)
        end_letter = (65+report_data[:size]).chr
        add_rows_report(sheet,2)
        sheet.add_row ["PAGINA DE BLOG"], :style => styles[:title]
        add_rows_report(sheet,2)
        insert_report_table(sheet, report_data, styles)
        add_rows_report(sheet,3)
        sheet.add_row ["GRAFICOS BLOG"], :style => styles[:title]
        add_rows_report(sheet,2)
        chart = create_chart(sheet, 21, "Visitas")
        labels = sheet["B6:#{end_letter}6"]
        add_serie(chart, sheet["B8:#{end_letter}8"], labels, 'visitas unicas')
        add_serie(chart, sheet["B10:#{end_letter}10"], labels, '#paginas vistas')
        chart = create_chart(sheet, 47, "Porcentajes")
        add_serie(chart, sheet["B13:#{end_letter}13"], labels, 'Porcentaje de Rebote')
        add_serie(chart, sheet["B14:#{end_letter}14"], labels, 'Porcentaje de Visitas')
        add_rows_report(sheet, 52)
        add_images_report(sheet, 76, social_id, styles[:title])
      end
    end
  end

end

