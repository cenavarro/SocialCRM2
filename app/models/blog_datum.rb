class BlogDatum < ActiveRecord::Base
  extend ApplicationHelper
  belongs_to :social_network

  def self.get_diff_unique_visits(datum)
    if !first_data?(datum)
      previous_data = BlogDatum.where('end_date < ? and social_network_id = ?', datum.start_date.to_date, datum.social_network_id).last
      return ((datum.unique_visits-previous_data.unique_visits).to_f/previous_data.unique_visits.to_f)*100 if previous_data.unique_visits != 0
    end
    return 0 
  end

  def self.get_diff_views_pages(datum)
    if !first_data?(datum)
      previous_data = BlogDatum.where('end_date < ? and social_network_id = ?', datum.start_date.to_date, datum.social_network_id).last
      return ((datum.view_pages-previous_data.view_pages).to_f/previous_data.view_pages.to_f)*100 if previous_data.view_pages != 0
    end
    return 0
  end

  def self.first_data?(datum)
    previous_data = BlogDatum.where('end_date < ? and social_network_id = ?',datum.start_date.to_date, datum.social_network_id).last
		(previous_data == nil) ? (return true) : (return false)
  end

  def self.generate_excel(document, social_id, start_date, end_date)
    document.workbook do | wb |
      wb.add_worksheet(:name => "Blog", :page_margins => margins, :page_setup => page_setup) do |sheet|
        @comments = BlogComment.find_by_social_network_id(social_id)
        report_data = select_report_data(social_id, start_date, end_date)
        styles = create_report_styles(wb, report_data['size'])
        add_rows_report(sheet, 2)
        sheet.add_row ["","PAGINA DE BLOG"], :style => 3
        add_table(sheet, report_data, styles)
        add_rows_report(sheet, 19)
        add_charts(sheet, report_data['size'])
        add_rows_report(sheet, 14)
        add_images_report(sheet, 125, social_id, styles)
      end
    end
  end

  private

  def self.select_report_data(social_id, start_date, end_date)
    blog_datum = BlogDatum.where('social_network_id = ? and start_date >= ? and end_date <= ?', social_id, start_date.to_date, end_date.to_date).order("start_date ASC")
    data = table_rows
    data['widths'] = [1, 32]
    data['size'] = (blog_datum.size+1)
    create_data_table(data, blog_datum)
    return data
  end

  def self.add_table(sheet, report_data, styles)
    add_rows_report(sheet, 2)
    report_data['table'].each do |key, data|
      if key.include?("header") || (key=="actions")
        sheet.add_row data, :style => styles['header'], :height => height_cell, :widths => report_data['widths']
      elsif key.include?("dates")
        sheet.add_row data, :style => styles['dates'], :height => height_cell
      else
        sheet.add_row data, :style => styles['basic'], :height => height_cell
      end
    end
    add_rows_report(sheet, 1)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.table]
  end

  def self.add_charts(sheet, size)
    @end_letter = (65 + size).chr
    @labels = sheet["C6:#{@end_letter}6"]
    sheet.add_row ["","GRAFICOS BLOG"], :style => 3
    add_rows_report(sheet, 2)
    insert_visits_chart(sheet)
    insert_percentage_chart(sheet)
  end

  def self.table_rows
    {
      'table' => {
        'dates' => ['',''], 'visits_header' => ['','Visitas'], 'unique_visits' => ['','# visitas unicas'], 
        'diff_visits' => ['','% diferencia'], 'view_pages' => ['','# paginas vistas'], 'diff_view' => ['','% diferencia'],
        'percentage_header' => ['','Porcentajes'], 'rebound_percent' => ['','Porcentaje de Rebote'],
        'new_visits_percent' => ['','Porcentaje de visitas nuevas'], 'total_posts' => ['','# de posts']
      }
    }
  end

  def self.create_data_table(data, blog_datum)
    blog_datum.each do |datum|
      blog_keys.each do |key|
        key.include?("header") ? (value = nil) : (value = datum[key])
        data['table'][key] << value
      end
      data['table']['dates'] << "#{datum.start_date.strftime('%d %b')} - #{datum.end_date.strftime('%d %b')}"
      data['table']['diff_visits'] << BlogDatum.get_diff_unique_visits(datum).round(2)
      data['table']['diff_view'] << BlogDatum.get_diff_views_pages(datum).round(2)
      data['widths'] << 9
    end
  end

  def self.blog_keys
    ['visits_header', 'percentage_header', 'unique_visits', 'view_pages', 'rebound_percent', 'new_visits_percent', 'total_posts']
  end

  def self.insert_visits_chart(sheet)
    chart = create_chart(sheet, 41, "Visitas")
    add_serie(chart, sheet["C8:#{@end_letter}8"], @labels, 'visitas unicas')
    add_serie(chart, sheet["C10:#{@end_letter}10"], @labels, '#paginas vistas')
    add_rows_report(sheet, 24)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.visits]
  end

  def self.insert_percentage_chart(sheet)
    chart = create_chart(sheet, 81, "Porcentajes")
    add_serie(chart, sheet["C13:#{@end_letter}13"], @labels, 'Porcentaje de Rebote')
    add_serie(chart, sheet["C14:#{@end_letter}14"], @labels, 'Porcentaje de Visitas')
    add_rows_report(sheet, 37)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.percentages]
  end

end

