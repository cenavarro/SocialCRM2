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
    append_rows 5
    append_row_with ["PÁGINA DE LINKEDIN"], @styles['title']
    append_table
    append_charts
    append_rows 10
    append_images 145
    @worksheet.column_widths *columns_widths
    append_headers_and_footers
  end

  def append_charts
    remove_table_legends
    append_rows 31
    append_row_with ["GRÁFICOS LINKEDIN"], @styles['title']
    append_rows 2
    append_followers_chart
    append_interactivity_chart
    append_views_pages_chart
  end

  def select_report_data
    table = table_rows
    linkedin_datum.each do |datum|
      linkedin_keys.each do |key|
        is_header_or_dates_row?(key)  ? table[key] << nil : (table[key] << (datum[key].nil? ? datum.send(key.to_sym) : datum[key]))
      end
      table['dates'] << "#{datum.start_date.strftime('%d %b')} - #{datum.end_date.strftime('%d %b')}"
    end
    table
  end

  def append_followers_chart 
    create_chart(64, "Seguidores")
    add_serie(@report_data['new_followers'], 'Nuevos seguidores')
    add_serie(@report_data['total_followers'], 'Seguidores totales')
    append_rows 14
    append_comment_chart_for 2
  end

  def append_interactivity_chart
    create_chart(92, "Interactividad")
    add_serie(@report_data['prints'], 'Impresiones')
    add_serie(@report_data['clics'], 'Clicks')
    add_serie(@report_data['interest'], '% Interés')
    add_serie(@report_data['recommendation'], 'Recomendación')
    append_rows 25
    append_comment_chart_for 3
  end

  def append_views_pages_chart
    create_chart(121, "Visualizaciones de paginas")
    add_serie(@report_data['views_pages'], 'Número de visualizaciones de páginas')
    add_serie([], '')
    append_rows 26
    append_comment_chart_for 4
  end

  def linkedin_keys 
    keys = table_rows
    keys.shift
    keys.collect { |key, vale| key  }
  end

  def set_headers_and_footers
    @headers ||= [0, 58, 87, 116]
    @footers ||= [57, 86, 115, 144]
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
