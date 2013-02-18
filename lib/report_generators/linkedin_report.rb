# encoding: utf-8
class ReportGenerators::LinkedinReport < ReportGenerators::Base

  def self.can_process? type
    type == LinkedinDatum
  end

  def add_to(document)
    if !linkedin_datum.empty?
      add_information_to document
    end
  end

  private

  def linkedin_datum
    social_network.linkedin_data.where('start_date >= ? and end_date <= ?', start_date.to_date, end_date.to_date).order("start_date ASC").limit(6)
  end

  def add_information_to document
    initialize_variables document
    append_rows 7
    append_row_with ["PÁGINA DE LINKEDIN"], @styles['title']
    append_table 3
    append_charts
    append_images 160
    @worksheet.column_widths *columns_widths
    append_headers_and_footers
  end

  def append_charts
    remove_table_legends
    append_rows (65 - current_row)
    append_rows 4
    append_row_with ["GRÁFICOS LINKEDIN"], @styles['title']
    append_followers_chart
    append_interactivity_chart
    append_views_pages_chart
  end


  def append_followers_chart 
    append_rows (71 - current_row)
    create_chart(current_row, "Seguidores")
    add_serie(@report_data['new_followers'], 'Nuevos seguidores')
    add_serie(@report_data['total_followers'], 'Seguidores totales')
    append_rows (86 - current_row)
    append_comment_chart_for 2
  end

  def append_interactivity_chart
    append_rows (101 - current_row)
    create_chart(current_row, "Interactividad")
    add_serie(@report_data['prints'], 'Impresiones')
    add_serie(@report_data['clics'], 'Clicks')
    add_serie(@report_data['interest'], '% Interés')
    add_serie(@report_data['recommendation'], 'Recomendación')
    append_rows (116 - current_row)
    append_comment_chart_for 3
  end

  def append_views_pages_chart
    append_rows (133 - current_row)
    create_chart(current_row, "Visualizaciones de paginas")
    add_serie(@report_data['views_page'], 'Número de visualizaciones de páginas')
    add_serie([0], '')
    append_rows (148 - current_row)
    append_comment_chart_for 4
  end

  def select_report_data
    table = table_rows
    linkedin_datum.each do |datum|
      linkedin_keys.each do |key|
        is_header_or_dates_row?(key)  ? table[key] << nil : ( value = (datum[key].nil? ? datum.send(key.to_sym) : datum[key]))
        table[key] << value if !is_header_or_dates_row?(key)
      end
      table['dates'] << "#{datum.start_date.strftime('%d %b')} - #{datum.end_date.strftime('%d %b')}"
    end
    table
  end

  def linkedin_keys 
    keys = table_rows
    keys.shift
    keys.collect { |key, vale| key  }
  end

  def set_headers_and_footers
    @headers ||= [0, 64, 96, 128]
    @footers ||= [63, 95, 127, 159]
  end

  def table_rows
    {
      'dates' => [''],
      'actions' => ['Acciones durante periodo'],
      'community_header' => ['Comunidad'], 
      'new_followers' => ['Nuevos seguidores'],
      'total_followers' => ['Seguidores totales'], 
      'get_percentage_difference_from_previous_total_followers' => ['% Crecimiento seguidores'],
      'interactions_header' => ['Interactividad'], 
      'views_page' => ['Número de visualizaciones de páginas'], 
      'summary' => ['Resumen'],
      'employment' => ['Empleo'],
      'products_services' => ['Productos y servicios'], 
      'prints' => ['Impresiones'],
      'clics' => ['Clicks'],
      'interest' => ['% Interés'],
      'recommendation' => ['Recomendación'],
      'investment_header' => ['Inversión'],
      'investment_agency' => ['Inversión agencia'], 
      'investment_actions' => ['Inversión nuevas acciones'],
      'investment_anno' => ['Inversión anuncios'],
      'total_investment' => ['Inversión total']
    }
  end

end
