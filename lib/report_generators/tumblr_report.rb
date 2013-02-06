# encoding: utf-8
class ReportGenerators::TumblrReport < ReportGenerators::Base

  def self.can_process? type
    type == TumblrDatum
  end

  def add_to(document)
    if !tumblr_datum.empty?
      add_information_to document
    end
  end

  private

  def tumblr_datum
    social_network.tumblr_data.where('start_date >= ? and end_date <= ?', start_date.to_date, end_date.to_date).order("start_date ASC").limit(6)
  end

  def add_information_to document
    initialize_variables document
    append_rows 5
    append_row_with ["PÁGINA DE TUMBLR"], @styles['title']
    append_table
    append_charts
    append_rows 10
    append_images 116
    @worksheet.column_widths *columns_widths
    append_headers_and_footers
  end

  def append_charts
    remove_table_legends
    append_rows 9
    append_row_with ["GRÁFICOS TUMBLR"], @styles['title']
    append_rows 2
    append_followers_chart
    append_interactivity_chart
    append_investment_chart
  end

  def select_report_data
    table = table_rows
    tumblr_datum.each do |datum|
      tumblr_keys.each do |key|
        is_header_or_dates_row?(key)  ? table[key] << nil : (table[key] << (datum[key].nil? ? datum.send(key.to_sym) : datum[key]))
      end
      table['dates'] << "#{datum.start_date.strftime('%d %b')} - #{datum.end_date.strftime('%d %b')}"
    end
    table
  end

  def append_followers_chart
    create_chart(35, "Followers")
    add_serie(@report_data['new_followers'], 'Nuevos followers')
    add_serie(@report_data['total_followers'], 'Followers')
    append_rows 14
    append_comment_chart_for 2
  end

  def append_interactivity_chart
    create_chart(63, "Interactividad")
    add_serie(@report_data['likes'], 'Like')
    add_serie(@report_data['reblogged'], 'Reblogged')
    append_rows 25
    append_comment_chart_for 3
  end

  def append_investment_chart
    create_chart(92, "Inversión")
    add_serie(@report_data['new_followers'], 'Nuevos followers')
    add_serie(@report_data['total_investment'], 'Inversión total')
    append_rows 26
    append_comment_chart_for 4
  end

  def tumblr_keys
    keys = table_rows
    keys.shift
    keys.collect { |key, vale| key  }
  end

  def set_headers_and_footers
    @headers ||= [0, 29, 58, 87]
    @footers ||= [28, 57, 86, 115]
  end

  def table_rows
    {
      'dates' => [''],
      'community_header' => ['Comunidad'], 
      'new_followers' => ['Nuevos followers'],
      'total_followers' => ['Followers'], 
      'posts' => ['Post'],
      'interaction_header' => ['Interactividad'],
      'likes' => ['Like'],
      'reblogged' => ['Reblogged'],
      'investment_header' => ['Inversión'],
      'investment_agency' => ['Inversión agencia'], 
      'investment_actions' => ['Inversión nuevas acciones'],
      'investment_ads' => ['Inversión anuncios'], 
      'total_investment' => ['Inversión total'],
    }
  end


end
