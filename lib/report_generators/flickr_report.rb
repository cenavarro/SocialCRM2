# encoding: utf-8
class ReportGenerators::FlickrReport < ReportGenerators::Base

  def self.can_process? type
    type == FlickrDatum
  end

  def add_to(document)
    if !flickr_datum.empty?
      add_information_to document
    end
  end

  private

  def flickr_datum
    social_network.flickr_data.where('start_date >= ? and end_date <= ?', start_date.to_date, end_date.to_date).order("start_date ASC").limit(6)
  end

  def add_information_to document
    initialize_variables document
    append_rows 5
    append_row_with ["PÁGINA FLICKR"], @styles['title']
    append_table
    append_charts
    append_images 128
    @worksheet.column_widths *columns_widths
    append_headers_and_footers
  end

  def append_charts
    remove_table_legends
    append_rows (37 - current_row)
    append_row_with ["GRÁFICOS FLICKR"], @styles['title']
    append_community_chart
    append_interactivity_chart
    append_investment_chart
  end

  def append_community_chart
    append_rows (39 - current_row)
    create_chart(current_row, "Comunidad")
    add_serie(@report_data['new_contacts'], 'Nuevos contactos')
    add_serie(@report_data['total_contacts'], 'Contactos')
    append_rows (54 - current_row)
    append_comment_chart_for 2
  end

  def append_interactivity_chart
    append_rows (69 - current_row)
    create_chart(current_row, "Interactividad")
    add_serie(@report_data['visits'], 'Visitas')
    add_serie(@report_data['comments'], 'Comentarios')
    add_serie(@report_data['favorites'], 'Favorios') 
    append_rows (84 - current_row)
    append_comment_chart_for 3
  end

  def append_investment_chart
    append_rows (101 - current_row)
    create_chart(current_row, "Inversión")
    add_serie(@report_data['new_contacts'], 'Nuevos contactos')
    add_serie(@report_data['total_investment'], 'Inversión total')
    append_rows (116 - current_row)
    append_comment_chart_for 4
  end

  def select_report_data
    table = table_rows
    flickr_datum.each do |datum|
      flickr_keys.each do |key|
        is_header_or_dates_row?(key)  ? table[key] << nil : ( value = (datum[key].nil? ? datum.send(key.to_sym) : datum[key]))
        table[key] << value if !is_header_or_dates_row?(key)
      end
      table['dates'] << "#{datum.start_date.strftime('%d %b')} - #{datum.end_date.strftime('%d %b')}"
    end
    table
  end

  def flickr_keys
    keys = table_rows
    keys.shift
    keys.collect { |key, vale| key  }
  end

  def set_headers_and_footers
    @headers ||= [0, 32, 64, 96]
    @footers ||= [31, 63, 95, 127]
  end

  def table_rows
    {
      'dates' => [''],
      'community_header' => ['Comunidad'],
      'new_contacts' => ['Nuevos contactos'], 
      'total_contacts' => ['Contactos'],
      'interactivity_header' => ['Interactividad'],
      'visits' => ['Visitas'],
      'comments' => ['Comentarios'],
      'favorites' => ['Favoritos'],
      'investment_header' => ['Inversión'], 
      'investment_agency' => ['Inversión agencia'],
      'investment_actions' => ['Inversión nuevas acciones'],
      'investment_ads' => ['Inversión anuncios'],
      'total_investment' => ['Inversión total']
    }
  end
end
