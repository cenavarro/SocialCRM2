# encoding: utf-8
class ReportGenerators::BlogReport < ReportGenerators::Base

  def self.can_process? type
    type == BlogDatum
  end

  def add_to(document)
    if !blog_datum.empty?
      @comments = social_network.blog_comment.where("social_network_id = ?", social_network.id).first
      @report_data = select_report_data
      set_headers_and_footers
      create_report(document)
      append_headers_and_footers
    end
  end

  private

  def blog_datum
    social_network.blog_data.where('start_date >= ? and end_date <= ?', start_date.to_date, end_date.to_date).order("start_date ASC").limit(6)
  end

  def create_report(document)
    set_workbook_and_worksheet(document)
    create_report_styles(blog_datum.size + 1)
    append_rows_to_report 7
    @worksheet.add_row ["","PAGINA DE BLOG"], :style => 3
    add_table_to_report
    append_charts_to_report
    append_rows_to_report 14
    add_images_report(120)
    @worksheet.column_widths 4, 27, 9, 9, 9, 9, 9, 9
  end

  def append_charts_to_report
    remove_cells_report_table
    append_rows_to_report 19
    @worksheet.add_row ["","GRAFICOS BLOG"], :style => 3
    append_rows_to_report 2
    append_visits_chart
    append_percentage_chart
  end

  def table_rows
    {
      'dates' => ['',''], 'visits_header' => ['','Visitas'], 'unique_visits' => ['','Número de visitas únicas'],
      'diff_visits' => ['','% Cambio'], 'view_pages' => ['','Páginas vistas'], 'diff_view' => ['','% Cambio'],
      'percentage_header' => ['','Porcentajes'], 'rebound_percent' => ['','Porcentaje rebote'],
      'new_visits_percent' => ['','Porcentaje de visitas nuevas'], 'total_posts' => ['','Número de posts']
    }
  end

  def select_report_data
    table = table_rows
    blog_datum.each do |datum|
      blog_keys.each do |key|
        key.include?("header") ? (value = nil) : (value = datum[key])
        table[key] << value
      end
      table['dates'] << "#{datum.start_date.strftime('%d %b')} - #{datum.end_date.strftime('%d %b')}"
      table['diff_visits'] << datum.get_percentage_difference_from_previous_unique_visits.round(2)
      table['diff_view'] << datum.get_percentage_difference_from_previous_view_pages.round(2)
    end
    table
  end

  def blog_keys
    ['visits_header', 'percentage_header', 'unique_visits', 'view_pages', 'rebound_percent', 'new_visits_percent', 'total_posts']
  end

  def append_visits_chart
    chart = create_chart(46, "Visitas")
    add_serie(chart, @report_data['unique_visits'], @report_data['dates'], 'Número de visitas únicas')
    add_serie(chart, @report_data['view_pages'], @report_data['dates'], 'Páginas vistas')
    append_rows_to_report 24
    @worksheet.add_row ["", "Comentario"], :style => 3
    append_rows_to_report 1
    @worksheet.add_row ["", @comments.visits]
  end

  def append_percentage_chart
    chart = create_chart(86, "Porcentajes")
    add_serie(chart, @report_data['rebound_percent'], @report_data['dates'], 'Porcentaje rebote')
    add_serie(chart, @report_data['new_visits_percent'], @report_data['dates'], 'Porcentaje visitas nuevas')
    append_rows_to_report 37
    @worksheet.add_row ["", "Comentario"], :style => 3
    append_rows_to_report 1
    @worksheet.add_row ["", @comments.percentages]
  end

  def set_headers_and_footers
    @headers ||= [0, 36, 78]
    @footers ||= [35, 77, 119]
  end
end
