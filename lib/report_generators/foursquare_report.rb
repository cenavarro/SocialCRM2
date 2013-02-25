# encoding: utf-8
class ReportGenerators::FoursquareReport < ReportGenerators::Base

  def self.can_process? type
    type == FoursquareDatum
  end

  def add_to(document)
    if !foursquare_datum.empty?
      add_information_to document
    end
  end

  private

  def foursquare_datum
    social_network.foursquare_data.where('start_date >= ? and end_date <= ?', start_date.to_date, end_date.to_date).order("start_date ASC").limit(6)
  end

  def add_information_to(document)
    initialize_variables document
    set_headers_and_footers 1, 4
    append_rows 4
    append_row_with ["PÁGINA DE FOURSQUARE"], @styles['title']
    append_table
    append_charts
    append_images (page_size * 4)
    @worksheet.column_widths *columns_widths
    append_headers_and_footers
  end

  def append_charts
    remove_table_legends
    append_rows ((page_size + 5) - current_row)
    append_row_with ["GRÁFICOS FOURSQUARE"], @styles['title']
    append_followers_chart
    append_interactivity_chart
    append_offers_chart
  end

  def append_followers_chart
    append_rows ((page_size + 7) - current_row)
    create_chart(current_row, "Comunidad")
    add_serie(@report_data['new_followers'], 'Nuevos followers')
    add_serie(@report_data['total_followers'], 'Followers')
    append_rows 15
    append_comment_chart_for 2
  end

  def append_interactivity_chart
    append_rows (((page_size * 2) + 5) - current_row)
    create_chart(current_row, "Interactividad")
    add_serie(@report_data['clients'], 'Clientes')
    add_serie(@report_data['likes'], 'Me gusta')
    add_serie(@report_data['checkins'], 'Check-ins')
    append_rows 15
    append_comment_chart_for 3
  end

  def append_offers_chart
    append_rows (((page_size * 3) + 5) - current_row)
    create_chart(current_row, "Interactividad (Ofertas)")
    add_serie(@report_data['total_unlocks'], 'Unlocks  total de ofertas')
    add_serie(@report_data['total_visits'], 'Visitas totales de las ofertas')
    append_rows 15
    append_comment_chart_for 4
  end

  def select_report_data
    table = table_rows
    foursquare_datum.each do |datum|
      foursquare_keys.each do |key|
        is_header_or_dates_row?(key)  ? table[key] << nil : ( value = (datum[key].nil? ? datum.send(key.to_sym) : datum[key]))
        table[key] << value if !is_header_or_dates_row?(key)
      end
      table['dates'] << "#{datum.start_date.strftime('%d %b')} - #{datum.end_date.strftime('%d %b')}"
    end
    table
  end

  def foursquare_keys
    keys = table_rows
    keys.shift
    keys.collect { |key, vale| key  }
  end

  def table_rows
    {
      'dates' => [''],
      'community_header' => ['Comunidad'],
      'new_followers' => ['Nuevos followers'],
      'total_followers' => ['Followers'],
      'interactivity_header' => ['Interactividad'],
      'clients' => ['Clientes'],
      'get_percentage_difference_from_previous_clients' => ['% Cambio'],
      'likes' => ['Me gusta'],
      'get_percentage_difference_from_previous_likes' => ['% Cambio'], 
      'checkins' => ['Check-ins'],
      'get_percentage_difference_from_previous_checkins' => ['% Cambio'],
      'campaign_header' => ['Campaña'],
      'total_unlocks' => ['Unlocks total de las ofertas'],
      'get_percentage_difference_from_previous_total_unlocks' => ['% Cambio'],
      'total_visits' => ['Visitas totales de las ofertas'],
      'get_percentage_difference_from_previous_total_visits' => ['% Cambio']
    }
  end

end
