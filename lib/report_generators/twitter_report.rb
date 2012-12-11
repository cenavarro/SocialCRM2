class ReportGenerators::TwitterReport < ReportGenerators::Base

  def self.can_process? type
    type == TwitterDatum
  end

  def add_to(document)
    if !twitter_datum.empty?
      @comments = social_network.twitter_comment.where("social_network_id = ?", social_network.id).first
      @report_data = select_report_data
      set_headers_and_footers
      create_report(document)
      append_headers_and_footers
    end
  end

  private

  def twitter_datum
    social_network.twitter_data.where('start_date >= ? and end_date <= ?', start_date.to_date, end_date.to_date).order("start_date ASC")
  end

  def create_report(document)
    set_workbook_and_worksheet(document)
    create_report_styles(twitter_datum.size + 1)
    append_rows_to_report 7
    @worksheet.add_row ["","PAGINA DE TWITTER"], :style => 3
    add_table_to_report
    append_charts_to_report
    append_rows_to_report 15
    add_images_report 235
    @worksheet.column_widths 4, 31, 9, 9, 9, 9, 9, 9
  end

  def append_charts_to_report
    remove_cells_report_table
    append_rows_to_report 26
    @worksheet.add_row ["","GRAFICOS TWITTER"], :style => 3
    append_rows_to_report 2
    append_followers_chart
    append_interactivity_chart
    append_investment_chart
    append_cost_chart
  end

  def table_rows
    {
      'dates' => ['',''], 'community_header' => ['','Comunidad'], 'new_followers' => ['','# nuevos followers'], 
      'total_followers' => ['','# followers'], 'growth_follower' => ['', '% Crecimiento'], 'goal_followers' => ['', 'Objetivo Followers'], 
      'total_tweets' => ['', '# numero tweets en total'], 'tweets_period' => ['', '# tweets periodo'],
      'interaction_header' => ['', 'Interactividad'], 'total_mentions' => ['', '# Menciones'], 'change_mentions' => ['', '% cambio en mensiones'],
      'ret_tweets' => ['', '# Retweets'], 'change_retweets' => ['', '% cambio en retweets'], 'total_clicks' => ['', 'Clicks enlaces'],
      'change_clics' => ['', '% cambio en clics'], 'interactions_ads' => ['', 'Interacciones en twitter ads'] ,
      'change_interactions_ads' => ['', '% cambio interacciones en twitter ads'], 'total_interactions' => ['', 'Interacciones en Total'],
      'change_interaction' => ['', '% cambio en interacciones'], 'prints' => ['', '# impresiones(tweetreach)'],
      'prints_ads' => ['', '# impreiones en twitter ads'], 'total_prints' => ['', 'impresiones en total'],
      'change_prints' => ['', '% cambio en impresiones'],
      'investment_header' => ['','Inversion'], 'agency_investment' => ['', 'Inversion Agencia'], 
      'investment_actions' => ['','Inversion nuevas acciones'], 'investment_ads' => ['','Inversion anuncios'], 
      'total_investment' => ['','Inversion Total'],
      'costs_header' => ['', 'Costes'], 'cost_twitter_ads' => ['', 'Cost per engagement twitter ads'],
      'cost_per_prints' => ['', 'Coste por mil impresiones'], 'cost_interaction' => ['', 'Coste por interaccion'],
      'cost_follower' => ['', 'Costes por follower']
    }
  end

  def select_report_data
    table = table_rows
    twitter_datum.each do |datum|
      twitter_keys.each do |key|
        key.include?("header") ? (value = nil) : (value = datum[key])
        table[key] << value
      end
      table['dates'] << "#{datum.start_date.strftime('%d %b')} - #{datum.end_date.strftime('%d %b')}"
      table['new_followers'] << datum.new_followers
      table['growth_follower'] << datum.get_percentage_difference_from_previous_total_followers.round(2)
      table['tweets_period'] << datum.period_tweets
      table['change_mentions'] << datum.get_percentage_difference_from_previous_total_mentions.round(2) 
      table['change_retweets'] << datum.get_percentage_difference_from_previous_ret_tweets.round(2) 
      table['change_clics'] << datum.get_percentage_difference_from_previous_total_clicks.round(2) 
      table['change_interactions_ads'] << datum.get_percentage_difference_from_previous_interactions_ads.round(2) 
      table['total_interactions'] << datum.total_interactions
      table['change_interaction'] << datum.get_percentage_difference_from_previous_total_interactions.round(2) 
      table['total_prints'] << datum.total_prints
      table['change_prints'] << datum.get_percentage_difference_from_previous_total_prints.round(2) 
      table['total_investment'] << datum.total_investment.round(2)
      table['cost_per_prints'] << datum.cost_per_prints.round(2) 
      table['cost_interaction'] << datum.cost_per_interaction.round(2) 
      table['cost_follower'] << datum.cost_follower.round(2) 
    end
    table
  end

  def twitter_keys
    ['community_header', 'total_followers', 'goal_followers', 'total_tweets',
      'interaction_header', 'total_mentions', 'ret_tweets', 'total_clicks', 'interactions_ads',
      'prints', 'prints_ads', 'investment_header', 'agency_investment', 'investment_actions', 'investment_ads',
      'costs_header', 'cost_twitter_ads']
  end

  def append_followers_chart
    chart = create_chart(76, "Comunidad")
    add_serie(chart, @report_data['new_followers'], @report_data['dates'], '# nuevos followers')
    add_serie(chart, @report_data['total_followers'], @report_data['dates'], '# followers')
    add_serie(chart, @report_data['goal_followers'], @report_data['dates'], 'Objetivos Followers')
    append_rows_to_report 24
    @worksheet.add_row ["", "Comentario"], :style => 3
    append_rows_to_report 1
    @worksheet.add_row ["", @comments.comunity]
  end

  def append_interactivity_chart
    chart = create_chart(116, "Interactividad")
    add_serie(chart, @report_data['total_mentions'], @report_data['dates'], '# menciones')
    add_serie(chart, @report_data['ret_tweets'], @report_data['dates'], '# retweets')
    add_serie(chart, @report_data['total_clicks'], @report_data['dates'], 'Clicks Enlaces')
    add_serie(chart, @report_data['interactions_ads'], @report_data['dates'], '# Interacciones en twitter ads')
    add_serie(chart, @report_data['total_interactions'], @report_data['dates'], 'Interacciones en Total')
    append_rows_to_report 37
    @worksheet.add_row ["", "Comentario"], :style => 3
    append_rows_to_report 1
    @worksheet.add_row ["", @comments.interaction]
  end

  def append_investment_chart
    chart = create_chart(158, "Inversion")
    add_serie(chart, @report_data['new_followers'], @report_data['dates'], '# nuevos followers')
    add_serie(chart, @report_data['total_investment'], @report_data['dates'], 'Inversion Total')
    append_rows_to_report 39
    @worksheet.add_row ["", "Comentario"], :style => 3
    append_rows_to_report 1
    @worksheet.add_row ["", @comments.investment]
  end

  def append_cost_chart
    chart = create_chart(200, "Costes")
    add_serie(chart, @report_data['cost_follower'], @report_data['dates'], 'Costes')
    add_serie(chart, @report_data['cost_twitter_ads'], @report_data['dates'], 'Cost per engagement twitter ads')
    add_serie(chart, @report_data['cost_per_prints'], @report_data['dates'], 'Coste por mil impresiones')
    add_serie(chart, @report_data['cost_interaction'], @report_data['dates'], 'Coste por interaccion')
    append_rows_to_report 39
    @worksheet.add_row ["", "Comentario"], :style => 3
    append_rows_to_report 1
    @worksheet.add_row ["", @comments.cost]
  end

  def set_headers_and_footers
    @headers ||= [0, 67, 109, 151, 193]
    @footers ||= [66, 108, 150, 192, 234]
  end

end
