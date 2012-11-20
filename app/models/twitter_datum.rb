class TwitterDatum < ActiveRecord::Base
  extend ApplicationHelper
  belongs_to :social_network

  def self.get_new_followers(datum)
    if !isFirstData?(datum)
      previous_data = TwitterDatum.where('end_date <= ? and social_network_id = ?', datum.start_date.to_date, datum.social_network_id).last
      return  datum.total_followers - previous_data.total_followers
    end
    return 0
  end

  def self.get_period_tweets(datum)
    if !isFirstData?(datum)
      previous_data = TwitterDatum.where('end_date <= ? and social_network_id = ?', datum.start_date.to_date, datum.social_network_id).last
      return (previous_data.total_tweets + datum.total_tweets)
    end
    return datum.total_tweets
  end

  def self.get_growth_followers(datum)
    if !isFirstData?(datum)
      previous_data = TwitterDatum.where('end_date <= ? and social_network_id = ?', datum.start_date.to_date, datum.social_network_id).last
      return (datum.new_followers.to_f/previous_data.total_followers.to_f)*100 if previous_data.total_followers != 0
    end
    return 0
  end

  def self.get_change_mentions(datum)
    if !isFirstData?(datum)
      previous_data = TwitterDatum.where('end_date <= ? and social_network_id = ?', datum.start_date.to_date, datum.social_network_id).last
      if previous_data.total_mentions != 0
        return ((datum.total_mentions - previous_data.total_mentions).to_f/previous_data.total_mentions.to_f)*100
      end
    end
    return 0
  end

  def self.get_change_retweets(datum)
    if !isFirstData?(datum)
      previous_data = TwitterDatum.where('end_date <= ? and social_network_id = ?', datum.start_date.to_date, datum.social_network_id).last
      if previous_data.ret_tweets != 0
        return ((datum.ret_tweets - previous_data.ret_tweets).to_f/previous_data.ret_tweets.to_f)*100
      end
    end
    return 0
  end

  def self.get_change_clics(datum)
    if !isFirstData?(datum)
      previous_data = TwitterDatum.where('end_date <= ? and social_network_id = ?', datum.start_date.to_date, datum.social_network_id).last
      if previous_data.total_clicks != 0
        return ((datum.total_clicks - previous_data.total_clicks).to_f/previous_data.total_clicks.to_f)*100
      end
    end
    return 0
  end

  def self.get_change_interactions_ads(datum)
    if !isFirstData?(datum)
      previous_data = TwitterDatum.where('end_date <= ? and social_network_id = ?', datum.start_date.to_date, datum.social_network_id).last
      if previous_data.interactions_ads != 0
        return ((datum.interactions_ads - previous_data.interactions_ads).to_f/previous_data.interactions_ads.to_f)*100
      end
    end
    return 0
  end

  def self.get_total_interactions(datum)
    (datum.total_mentions + datum.ret_tweets + datum.total_clicks + datum.interactions_ads)
  end

  def self.get_change_interactions(datum)
    if !isFirstData?(datum)
      previous_data = TwitterDatum.where('end_date <= ? and social_network_id = ?', datum.start_date.to_date, datum.social_network_id).last
      if previous_data.total_interactions != 0
        return ((datum.total_interactions - previous_data.total_interactions).to_f/previous_data.total_interactions.to_f)*100
      end
    end
    return 0
  end

  def self.get_total_prints(datum)
    (datum.prints + datum.prints_ads)
  end

  def self.get_change_prints(datum)
    if !isFirstData?(datum)
      previous_data = TwitterDatum.where('end_date <= ? and social_network_id = ?', datum.start_date.to_date, datum.social_network_id).last
      previous_total_prints = TwitterDatum.get_total_prints(datum) 
      if previous_total_prints != 0
        return ((TwitterDatum.get_total_prints(datum) - previous_total_prints).to_f/previous_total_prints.to_f)*100
      end
    end
    return 0
  end

  def self.get_total_investment(datum)
    (datum.agency_investment + datum.investment_ads + datum.investment_actions) 
  end

  def self.get_cost_per_prints(datum)
    total_investment = get_total_investment(datum)
    total_prints = get_total_prints(datum)
    return (total_investment.to_f/total_prints.to_f)*1000 if total_prints != 0
    return 0
  end

  def self.get_cost_per_interaction(datum)
    total_investment = get_total_investment(datum)
    total_interactions = get_total_interactions(datum)
    return (total_investment.to_f/total_interactions.to_f) if total_interactions != 0
    return 0
  end

  def self.get_cost_follower(datum)
    if !isFirstData?(datum)
      total_investment = get_total_investment(datum)
      return (total_investment.to_f/datum.new_followers.to_f) if datum.new_followers != 0
    end
    return 0
  end

	def self.isFirstData?(datum)
    previous_data = TwitterDatum.where('end_date < ? and social_network_id = ?',datum.start_date.to_date, datum.social_network_id).last
		if(previous_data == nil)
			return true
		end
		return false
	end

  def self.generate_excel(document, social_id, start_date, end_date)
    @comments = TwitterComment.find_by_social_network_id(social_id)
    document.workbook do | wb |
      wb.add_worksheet(:name => "Twitter", :page_margins => margins, :page_setup => page_setup) do |sheet|
        report_data = select_report_data(social_id, start_date, end_date)
        styles = create_report_styles(wb, report_data['size'])
        add_rows_report(sheet, 2)
        sheet.add_row ["","PAGINA DE TWITTER"], :style => 3
        add_table(sheet, report_data, styles)
        add_rows_report(sheet, 26)
        add_charts(sheet, report_data['size'])
        add_rows_report(sheet, 14)
        add_images_report(sheet, 239, social_id, styles)
      end
    end
  end

  private

  def self.select_report_data(social_id, start_date, end_date)
    tumblr_datum = TwitterDatum.where('social_network_id = ? and start_date >= ? and end_date <= ?', social_id, start_date.to_date, end_date.to_date).order("start_date ASC")
    data = table_rows
    data['widths'] = [1, 32]
    data['size'] = (tumblr_datum.size+1)
    create_data_table(data, tumblr_datum)
    return data
  end

  def self.add_charts(sheet, size)
    @end_letter = (65 + size).chr
    @labels = sheet["C6:#{@end_letter}6"]
    sheet.add_row ["","GRAFICOS TWITTER"], :style => 3
    add_rows_report(sheet, 2)
    insert_followers_chart(sheet)
    insert_interactivity_chart(sheet)
    insert_investment_chart(sheet)
    insert_cost_chart(sheet)
  end

  def self.table_rows
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

  def self.create_data_table(data, twitter_datum)
    twitter_datum.each do |datum|
      twitter_keys.each do |key|
        key.include?("header") ? (value = nil) : (value = datum[key])
        data['table'][key] << value
      end
      data['table']['dates'] << "#{datum.start_date.strftime('%d %b')} - #{datum.end_date.strftime('%d %b')}"
      data['table']['growth_follower'] << get_growth_followers(datum).round(2) 
      data['table']['tweets_period'] << get_period_tweets(datum).round(2) 
      data['table']['change_mentions'] << get_change_mentions(datum).round(2) 
      data['table']['change_retweets'] << get_change_retweets(datum).round(2) 
      data['table']['change_clics'] << get_change_clics(datum).round(2) 
      data['table']['change_interactions_ads'] << get_change_interactions_ads(datum).round(2) 
      data['table']['total_interactions'] << get_total_interactions(datum).round(2) 
      data['table']['change_interaction'] << get_change_interactions(datum).round(2) 
      data['table']['total_prints'] << get_total_prints(datum).round(2) 
      data['table']['change_prints'] << get_change_prints(datum).round(2) 
      data['table']['total_investment'] << get_total_investment(datum).round(2) 
      data['table']['cost_per_prints'] << get_cost_per_prints(datum).round(2) 
      data['table']['cost_interaction'] << get_cost_per_interaction(datum).round(2) 
      data['table']['cost_follower'] << get_cost_follower(datum).round(2) 
      data['widths'] << 9
    end
  end

  def self.twitter_keys
    ['community_header', 'new_followers', 'total_followers', 'goal_followers', 'total_tweets',
      'interaction_header', 'total_mentions', 'ret_tweets', 'total_clicks', 'interactions_ads',
      'prints', 'prints_ads', 'investment_header', 'agency_investment', 'investment_actions', 'investment_ads',
      'costs_header', 'cost_twitter_ads']
  end

  def self.insert_followers_chart(sheet)
    chart = create_chart(sheet, 71, "Comunidad")
    add_serie(chart, sheet["C8:#{@end_letter}8"], @labels, '# nuevos followers')
    add_serie(chart, sheet["C9:#{@end_letter}9"], @labels, '# followers')
    add_serie(chart, sheet["C11:#{@end_letter}11"], @labels, 'Objetivos Followers')
    add_rows_report(sheet, 24)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.comunity]
  end

  def self.insert_interactivity_chart(sheet)
    chart = create_chart(sheet, 111, "Interactividad")
    add_serie(chart, sheet["C15:#{@end_letter}15"], @labels, '# menciones')
    add_serie(chart, sheet["C17:#{@end_letter}17"], @labels, '# retweets')
    add_serie(chart, sheet["C19:#{@end_letter}19"], @labels, 'Clicks Enlaces')
    add_serie(chart, sheet["C21:#{@end_letter}21"], @labels, '# Interacciones en twitter ads')
    add_serie(chart, sheet["C23:#{@end_letter}23"], @labels, 'Interacciones en Total')
    add_rows_report(sheet, 37)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.interaction]
  end

  def self.insert_investment_chart(sheet)
    chart = create_chart(sheet, 153, "Inversion")
    add_serie(chart, sheet["C8:#{@end_letter}8"], @labels, '# nuevos followers')
    add_serie(chart, sheet["C33:#{@end_letter}33"], @labels, 'Inversion Total')
    add_rows_report(sheet, 39)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.investment]
  end

  def self.insert_cost_chart(sheet)
    chart = create_chart(sheet, 195, "Costes")
    add_serie(chart, sheet["C38:#{@end_letter}38"], @labels, 'Costes')
    add_serie(chart, sheet["C35:#{@end_letter}35"], @labels, 'Cost per engagement twitter ads')
    add_serie(chart, sheet["C36:#{@end_letter}36"], @labels, 'Coste por mil impresiones')
    add_serie(chart, sheet["C37:#{@end_letter}37"], @labels, 'Coste por interaccion')
    add_rows_report(sheet, 39)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.cost]
  end


end
