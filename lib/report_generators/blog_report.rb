# encoding: utf-8
class ReportGenerators::BlogReport < ReportGenerators::Base

  def self.can_process? type
    type == BlogDatum
  end

  def add_to(document)
    if !blog_datum.empty?
      add_information_to document
    end
  end

  private

  def blog_datum
    social_network.blog_data.where('start_date >= ? and end_date <= ?', start_date.to_date, end_date.to_date).order("start_date ASC").limit(6)
  end

  def add_information_to document
    initialize_variables document
    append_rows 5
    append_row_with ["PÁGINA DE BLOG"], @styles['title']
    append_table
    append_charts
    append_rows 10
    append_images 87
    @worksheet.column_widths *columns_widths
    append_headers_and_footers
  end

  def select_report_data
    table = table_rows
    blog_datum.each do |datum|
      blog_keys.each do |key|
        is_header_or_dates_row?(key)  ? table[key] << nil : (table[key] << (datum[key].nil? ? datum.send(key.to_sym) : datum[key]))
      end
      table['dates'] << "#{datum.start_date.strftime('%d %b')} - #{datum.end_date.strftime('%d %b')}"
    end
    table
  end

  def append_charts
    remove_table_legends
    append_rows 13
    append_row_with ["GRÁFICOS BLOG"], @styles['title']
    append_rows 2
    append_visits_chart
    append_percentage_chart
  end

  def append_visits_chart
    create_chart(36, "Visitas")
    add_serie(@report_data['unique_visits'], 'Número de visitas únicas')
    add_serie(@report_data['view_pages'], 'Páginas vistas')
    append_rows 14
    append_comment_chart_for 2
  end

  def append_percentage_chart
    create_chart(63, "Porcentajes")
    add_serie(@report_data['rebound_percent'], 'Porcentaje rebote')
    add_serie(@report_data['new_visits_percent'], 'Porcentaje visitas nuevas')
    append_rows 24
    append_comment_chart_for 3
  end

  def set_headers_and_footers
    @headers ||= [0, 29, 58]
    @footers ||= [28, 57, 86]
  end

  def blog_keys
    keys = table_rows
    keys.shift
    keys.collect { |key, value| key  }
  end

  def table_rows
    {
      'dates' => [''], 
      'visits_header' => ['Visitas'],
      'unique_visits' => ['Número de visitas únicas'],
      'get_percentage_difference_from_previous_unique_visits' => ['% Cambio'],
      'view_pages' => ['Páginas vistas'],
      'get_percentage_difference_from_previous_view_pages' => ['% Cambio'],
      'percentage_header' => ['Porcentajes'],
      'rebound_percent' => ['Porcentaje rebote'],
      'new_visits_percent' => ['Porcentaje de visitas nuevas'],
      'total_posts' => ['Número de posts']
    }
  end
end
