# encoding: utf-8
class ReportGenerators::PinterestReport < ReportGenerators::Base

  def self.can_process? type
    type == PinterestDatum
  end

  def add_to(document)
    if !pinterest_datum.empty?
      add_information_to document
    end
  end

  private

  def pinterest_datum
    social_network.pinterest_data.where('start_date >= ? and end_date <= ?', start_date.to_date, end_date.to_date).order("start_date ASC").limit(6)
  end

  def add_information_to document
    initialize_variables document
    append_rows 6
    append_row_with ["PÁGINA DE PINTEREST"], @styles['title']
    append_table 3
    append_charts
    append_images 160
    @worksheet.column_widths *columns_widths
    append_headers_and_footers
  end

  def append_charts
    remove_table_legends
    append_rows (69 - current_row)
    append_row_with ["GRÁFICOS PINTEREST"], @styles['title']
    append_followers_chart
    append_interactivity_chart
    append_investment_chart
  end

  def append_followers_chart
    append_rows (71 - current_row)
    create_chart(current_row, "Comunidad")
    add_serie(@report_data['total_followers'], 'Followers')
    add_serie(@report_data['boards'], 'Boards')
    add_serie(@report_data['pins'], 'Pins')
    append_rows (86 - current_row)
    append_comment_chart_for 2
  end

  def append_interactivity_chart
    append_rows (101 - current_row)
    create_chart(current_row, "Interactividad")
    add_serie(@report_data['liked'], 'Liked')
    add_serie(@report_data['repin'], 'Repin')
    add_serie(@report_data['comments'], 'Comments')
    add_serie(@report_data['community_boards'], 'Community boards')
    append_rows (116 - current_row)
    append_comment_chart_for 3
  end

  def append_investment_chart
    append_rows (133 - current_row)
    create_chart(current_row, "Inversión")
    add_serie(@report_data['total_investment'], 'Inversión total')
    add_serie([], '')
    append_rows (148 - current_row)
    append_comment_chart_for 4
  end

  def select_report_data
    table = table_rows
    pinterest_datum.each do |datum|
      pinterest_keys.each do |key|
        is_header_or_dates_row?(key)  ? table[key] << nil : ( value = (datum[key].nil? ? datum.send(key.to_sym) : datum[key]))
        table[key] << value if !is_header_or_dates_row?(key)
      end
      table['dates'] << "#{datum.start_date.strftime('%d %b')} - #{datum.end_date.strftime('%d %b')}"
    end
    table
  end

  def pinterest_keys
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
      'community_header' => ['Comunidad'],
      'total_followers' => ['Followers'],
      'get_percentage_difference_from_previous_total_followers' => ['% Crecimiento'],
      'boards' => ['Boards'],
      'pins' => ['Pins'], 
      'interactions_header' => ['Interactividad'], 
      'liked' => ['Liked'],
      'get_percentage_difference_from_previous_liked' => ['% Cambio'],
      'repin' => ['Repin'],
      'get_percentage_difference_from_previous_repin' => ['% Cambio'],
      'comments' => ['Comments'],
      'get_percentage_difference_from_previous_comments' => ['% Cambio'],
      'community_boards' => ['Community boards'],
      'get_percentage_difference_from_previous_community_boards' => ['% Cambio'],
      'investment_header' => ['Inversión'],
      'investment_agency' => ['Inversión agencia'], 
      'investment_actions' => ['Inversión nuevas acciones'],
      'investment_ads' => ['Inversión anuncios'], 
      'total_investment' => ['Inversión total'],
      'coste_fan' => ['Coste fan']
    }
  end

end
