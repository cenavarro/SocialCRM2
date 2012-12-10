class ReportGenerators::TwitterReport < ReportGenerators::Base

  def self.can_process? type
    type == TwitterDatum
  end

  def add_to(document)
    twitter_datum = social_network.twitter_data.where('start_date >= ? and end_date <= ?', start_date.to_date, end_date.to_date).order("start_date ASC")
    if !twitter_datum.empty?
      @comments = social_network.twitter_comment.where("social_network_id = ?", social_network.id).first
      document.workbook do | wb |
        wb.add_worksheet(:name => social_network.name, :page_margins => margins, :page_setup => page_setup) do |sheet|
          report_data = select_report_data(twitter_datum)
          styles = create_report_styles(wb, report_data['size'])
          add_rows_report(sheet, 7)
          sheet.add_row ["","PAGINA DE TWITTER"], :style => 3
          add_table(sheet, report_data, styles)
          add_rows_report(sheet, 26)
          add_charts(sheet, report_data['size'])
          add_rows_report(sheet, 15)
          add_images_report(sheet, 235, styles)
          header(sheet, 0)
          footer(sheet, 66)
          sheet.column_widths 4, 31, 9, 9, 9, 9, 9, 9
        end
      end
    end
  end

  private

  def select_report_data(twitter_datum)
    data = table_rows
    data['widths'] = [1, 32]
    data['size'] = (twitter_datum.size+1)
    create_data_table(data, twitter_datum)
    return data
  end

  def add_charts(sheet, size)
    @end_letter = (65 + size).chr
    @labels = sheet["C11:#{@end_letter}11"]
    sheet.add_row ["","GRAFICOS TWITTER"], :style => 3
    add_rows_report(sheet, 2)
    insert_followers_chart(sheet)
    insert_interactivity_chart(sheet)
    insert_investment_chart(sheet)
    insert_cost_chart(sheet)
    header(sheet, 67)
    footer(sheet, 108)
    header(sheet, 109)
    footer(sheet, 150)
    header(sheet, 151)
    footer(sheet, 192)
    header(sheet, 193)
    footer(sheet, 234)
  end

  def table_rows
    {
      'table' => {
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
    }
  end

  def create_data_table(data, twitter_datum)
    twitter_datum.each do |datum|
      twitter_keys.each do |key|
        key.include?("header") ? (value = nil) : (value = datum[key])
        data['table'][key] << value
      end
      data['table']['dates'] << "#{datum.start_date.strftime('%d %b')} - #{datum.end_date.strftime('%d %b')}"
      data['table']['new_followers'] << datum.new_followers
      data['table']['growth_follower'] << datum.get_percentage_difference_from_previous_total_followers.round(2)
      data['table']['tweets_period'] << datum.period_tweets
      data['table']['change_mentions'] << datum.get_percentage_difference_from_previous_total_mentions.round(2) 
      data['table']['change_retweets'] << datum.get_percentage_difference_from_previous_ret_tweets.round(2) 
      data['table']['change_clics'] << datum.get_percentage_difference_from_previous_total_clicks.round(2) 
      data['table']['change_interactions_ads'] << datum.get_percentage_difference_from_previous_interactions_ads.round(2) 
      data['table']['total_interactions'] << datum.total_interactions
      data['table']['change_interaction'] << datum.get_percentage_difference_from_previous_total_interactions.round(2) 
      data['table']['total_prints'] << datum.total_prints
      data['table']['change_prints'] << datum.get_percentage_difference_from_previous_total_prints.round(2) 
      data['table']['total_investment'] << datum.total_investment.round(2)
      data['table']['cost_per_prints'] << datum.cost_per_prints.round(2) 
      data['table']['cost_interaction'] << datum.cost_per_interaction.round(2) 
      data['table']['cost_follower'] << datum.cost_follower.round(2) 
      data['widths'] << 9
    end
  end

  def twitter_keys
    ['community_header', 'total_followers', 'goal_followers', 'total_tweets',
      'interaction_header', 'total_mentions', 'ret_tweets', 'total_clicks', 'interactions_ads',
      'prints', 'prints_ads', 'investment_header', 'agency_investment', 'investment_actions', 'investment_ads',
      'costs_header', 'cost_twitter_ads']
  end

  def insert_followers_chart(sheet)
    chart = create_chart(sheet, 76, "Comunidad")
    add_serie(chart, sheet["C13:#{@end_letter}13"], @labels, '# nuevos followers')
    add_serie(chart, sheet["C14:#{@end_letter}14"], @labels, '# followers')
    add_serie(chart, sheet["C16:#{@end_letter}16"], @labels, 'Objetivos Followers')
    add_rows_report(sheet, 24)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.comunity]
  end

  def insert_interactivity_chart(sheet)
    chart = create_chart(sheet, 116, "Interactividad")
    add_serie(chart, sheet["C20:#{@end_letter}20"], @labels, '# menciones')
    add_serie(chart, sheet["C22:#{@end_letter}22"], @labels, '# retweets')
    add_serie(chart, sheet["C24:#{@end_letter}24"], @labels, 'Clicks Enlaces')
    add_serie(chart, sheet["C26:#{@end_letter}26"], @labels, '# Interacciones en twitter ads')
    add_serie(chart, sheet["C28:#{@end_letter}28"], @labels, 'Interacciones en Total')
    add_rows_report(sheet, 37)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.interaction]
  end

  def insert_investment_chart(sheet)
    chart = create_chart(sheet, 158, "Inversion")
    add_serie(chart, sheet["C13:#{@end_letter}13"], @labels, '# nuevos followers')
    add_serie(chart, sheet["C38:#{@end_letter}38"], @labels, 'Inversion Total')
    add_rows_report(sheet, 39)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.investment]
  end

  def insert_cost_chart(sheet)
    chart = create_chart(sheet, 200, "Costes")
    add_serie(chart, sheet["C43:#{@end_letter}43"], @labels, 'Costes')
    add_serie(chart, sheet["C40:#{@end_letter}40"], @labels, 'Cost per engagement twitter ads')
    add_serie(chart, sheet["C41:#{@end_letter}41"], @labels, 'Coste por mil impresiones')
    add_serie(chart, sheet["C42:#{@end_letter}42"], @labels, 'Coste por interaccion')
    add_rows_report(sheet, 39)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.cost]
  end


end
