# encoding: utf-8
class ReportGenerators::TwitterReport < ReportGenerators::Base

  def self.can_process? type
    type == TwitterDatum
  end

  def add_to(document)
    if !twitter_datum.empty?
      add_information_to document
    end
  end

  private

  def twitter_datum
    social_network.twitter_data.where('start_date >= ? and end_date <= ?', start_date.to_date, end_date.to_date).order("start_date ASC").limit(6)
  end

  def add_information_to document
    initialize_variables document
    set_headers_and_footers 2, 6
    append_rows 5
    append_row_with ["PÁGINA DE TWITTER"], @styles['title']
    append_table
    append_charts
    append_images (page_size * 6)
    @worksheet.column_widths *columns_widths
    append_headers_and_footers
  end

  def append_charts
    remove_table_legends
    append_rows (((page_size * 2) + 1) - current_row)
    append_rows 4
    append_row_with ["GRÁFICOS TWITTER"], @styles['title']
    append_followers_chart
    append_interactivity_chart
    append_investment_chart
    append_cost_chart
  end

  def append_followers_chart
    append_rows (((page_size * 2) + 6) - current_row)
    create_chart(current_row, "Comunidad")
    add_serie(@report_data['new_followers'], 'Nuevos followers')
    add_serie(@report_data['total_followers'], 'Followers')
    add_serie(@report_data['goal_followers'], 'Objetivo followers')
    append_rows 15
    append_comment_chart_for 2
  end

  def append_interactivity_chart
    append_rows (((page_size * 3) + 5) - current_row)
    create_chart(current_row, "Interactividad")
    add_serie(@report_data['total_mentions'], 'Menciones')
    add_serie(@report_data['ret_tweets'], 'Retweets')
    add_serie(@report_data['favorites'], 'Favoritos')
    add_serie(@report_data['lists'], 'Listas')
    add_serie(@report_data['total_clicks'], 'Clics enlaces')
    add_serie(@report_data['interactions_ads'], '# Interacciones en Twitter Ads')
    add_serie(@report_data['total_interactions'], 'Interacciones en total')
    append_rows 15
    append_comment_chart_for 3
  end

  def append_investment_chart
    append_rows (((page_size * 4) + 5) - current_row)
    create_chart(current_row, "Inversión")
    add_serie(@report_data['new_followers'], 'Nuevos followers')
    add_serie(@report_data['total_investment'], 'Inversión total')
    append_rows 15
    append_comment_chart_for 4
  end

  def append_cost_chart
    append_rows (((page_size * 5) + 5) - current_row)
    create_chart(current_row, "Costes")
    add_serie(@report_data['cost_follower'], 'Costes')
    add_serie(@report_data['cost_twitter_ads'], 'Cost per engagement Twitter Ads')
    add_serie(@report_data['cost_per_prints'], 'Coste por mil impresiones')
    add_serie(@report_data['cost_per_interaction'], 'Coste por interacción')
    append_rows 15
    append_comment_chart_for 5
  end

  def select_report_data
    table = table_rows
    twitter_datum.each do |datum|
      twitter_keys.each do |key|
        is_header_or_dates_row?(key)  ? table[key] << nil : ( value = (datum[key].nil? ? datum.send(key.to_sym) : datum[key]))
        table[key] << value if !is_header_or_dates_row?(key)
      end
      table['dates'] << "#{datum.start_date.strftime('%d %b')} - #{datum.end_date.strftime('%d %b')}"
    end
    table
  end

  def twitter_keys
    keys = table_rows
    keys.shift
    keys.collect { |key, value| key  }
  end

  def table_rows
    {
      'dates' => [''],
      'community_header' => ['Comunidad'],
      'new_followers' => ['Nuevos followers'],
      'total_followers' => ['Followers'],
      'get_percentage_difference_from_previous_total_followers' => ['% Crecimiento'],
      'goal_followers' => ['Objetivo followers'],
      'total_tweets' => ['Número tweets en total'],
      'period_tweets' => ['Tweets por periodo'],
      'interaction_header' => ['Interactividad'],
      'total_mentions' => ['Menciones'],
      'get_percentage_difference_from_previous_total_mentions' => ['% Cambio en mensiones'],
      'ret_tweets' => ['Retweets'],
      'get_percentage_difference_from_previous_ret_tweets' => ['% Cambio en retweets'],
      'favorites' => ['Favoritos'],
      'get_percentage_difference_from_previous_favorites' => ['% Cambio en favoritos'],
      'lists' => ['Listas'],
      'get_percentage_difference_from_previous_lists' => ['% Cambio en listas'],
      'total_clicks' => ['Clics enlaces'],
      'get_percentage_difference_from_previous_total_clicks' => ['% Cambio en clics'],
      'interactions_ads' => ['Interacciones en Twitter Ads'] ,
      'get_percentage_difference_from_previous_interactions_ads' => ['% Cambio interacciones en Twitter Ads'],
      'total_interactions' => ['Interacciones en total'],
      'get_percentage_difference_from_previous_total_interactions' => ['% Cambio en interacciones'],
      'prints' => ['Impresiones(tweetreach)'],
      'prints_ads' => ['Impresiones en Twitter Ads'],
      'total_prints' => ['Impresiones en total'],
      'get_percentage_difference_from_previous_total_prints' => ['% Cambio en impresiones'],
      'investment_header' => ['Inversión'],
      'agency_investment' => ['Inversión agencia'], 
      'investment_actions' => ['Inversión nuevas acciones'],
      'investment_ads' => ['Inversión anuncios'], 
      'total_investment' => ['Inversión total'],
      'costs_header' => ['Costes'],
      'cost_twitter_ads' => ['Cost per engagement Twitter Ads'],
      'cost_per_prints' => ['Coste por mil impresiones'],
      'cost_per_interaction' => ['Coste por interacción'],
      'cost_follower' => ['Coste por follower']
    }
  end

end
