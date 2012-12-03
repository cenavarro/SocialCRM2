class ReportGenerators::BlogReport < ReportGenerators::Base

  def self.can_process? type
    type == BlogDatum
  end

  def add_to(document)
    blog_datum = social_network.blog_data.where('start_date >= ? and end_date <= ?', start_date.to_date, end_date.to_date).order("start_date ASC")
    if !blog_datum.empty?
      document.workbook do | wb |
        wb.add_worksheet(:name => "Blog", :page_margins => margins, :page_setup => page_setup) do |sheet|
          @comments = social_network.blog_comment.where("social_network_id = ?", social_network.id).first
          report_data = select_report_data(blog_datum)
          styles = create_report_styles(wb, report_data['size'])
          add_rows_report(sheet, 7)
          sheet.add_row ["","PAGINA DE BLOG"], :style => 3
          add_table(sheet, report_data, styles)
          add_charts(sheet, report_data['size'])
          add_rows_report(sheet, 14)
          add_images_report(sheet, 120, social_network.id, styles)
          header(sheet, 0)
          footer(sheet, 35)
          sheet.column_widths 4, 27, 9, 9, 9, 9, 9, 9
        end
      end
    end
  end

  private

  def select_report_data(blog_datum)
    data = table_rows
    data['widths'] = [1, 32]
    data['size'] = (blog_datum.size+1)
    create_data_table(data, blog_datum)
    return data
  end

  def add_charts(sheet, size)
    add_rows_report(sheet, 19)
    @end_letter = (65 + size).chr
    @labels = sheet["C11:#{@end_letter}11"]
    sheet.add_row ["","GRAFICOS BLOG"], :style => 3
    add_rows_report(sheet, 2)
    insert_visits_chart(sheet)
    insert_percentage_chart(sheet)
    header(sheet, 36)
    footer(sheet, 77)
    header(sheet, 78)
    footer(sheet, 119)
  end

  def table_rows
    {
      'table' => {
        'dates' => ['',''], 'visits_header' => ['','Visitas'], 'unique_visits' => ['','# visitas unicas'], 
        'diff_visits' => ['','% diferencia'], 'view_pages' => ['','# paginas vistas'], 'diff_view' => ['','% diferencia'],
        'percentage_header' => ['','Porcentajes'], 'rebound_percent' => ['','Porcentaje de Rebote'],
        'new_visits_percent' => ['','Porcentaje de visitas nuevas'], 'total_posts' => ['','# de posts']
      }
    }
  end

  def create_data_table(data, blog_datum)
    blog_datum.each do |datum|
      blog_keys.each do |key|
        key.include?("header") ? (value = nil) : (value = datum[key])
        data['table'][key] << value
      end
      data['table']['dates'] << "#{datum.start_date.strftime('%d %b')} - #{datum.end_date.strftime('%d %b')}"
      data['table']['diff_visits'] << datum.get_percentage_difference_from_previous_unique_visits.round(2)
      data['table']['diff_view'] << datum.get_percentage_difference_from_previous_view_pages.round(2)
      data['widths'] << 9
    end
  end

  def blog_keys
    ['visits_header', 'percentage_header', 'unique_visits', 'view_pages', 'rebound_percent', 'new_visits_percent', 'total_posts']
  end

  def insert_visits_chart(sheet)
    chart = create_chart(sheet, 46, "Visitas")
    add_serie(chart, sheet["C13:#{@end_letter}13"], @labels, 'visitas unicas')
    add_serie(chart, sheet["C15:#{@end_letter}15"], @labels, '#paginas vistas')
    add_rows_report(sheet, 24)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.visits]
  end

  def insert_percentage_chart(sheet)
    chart = create_chart(sheet, 86, "Porcentajes")
    add_serie(chart, sheet["C18:#{@end_letter}18"], @labels, 'Porcentaje de Rebote')
    add_serie(chart, sheet["C19:#{@end_letter}19"], @labels, 'Porcentaje de Visitas')
    add_rows_report(sheet, 37)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.percentages]
  end
end
