class FacebookDatum < ActiveRecord::Base
  extend ApplicationHelper
  belongs_to :social_network

  def self.get_total_interactions(datum)
    (datum.total_clicks_anno + datum.total_interactions)
  end

  def self.get_total_prints(datum)
    (datum.total_prints_per_anno + datum.prints)
  end

  def self.get_total_investment(datum)
    datum.agency_investment.to_f+datum.new_stock_investment.to_f+datum.anno_investment.to_f
  end

  def self.get_fan_cost(datum)
    if !isFirstData?(datum)
      total_investment = get_total_investment(datum)
      return (total_investment.to_f/datum.new_fans.to_f)
    end
    return 0
  end

  def self.get_new_fans(datum)
    if !isFirstData?(datum)
      previous_data = FacebookDatum.where('end_date < ? and social_network_id = ?', datum.start_date.to_date, datum.social_network_id).last
      return (datum.total_fans - previous_data.total_fans) 
    end
    return 0
  end

  def self.get_fan_growth_percentage(datum)
    diffFans = datum.total_fans-datum.new_fans
    (diffFans != 0) ? (return (datum.new_fans.to_f/(datum.total_fans-datum.new_fans).to_f)*100) : ( return 100)
  end

  def self.get_print_percentage(datum)
    !isFirstData?(datum) ? (return getPercentagePrints(datum)) : (return 0)
  end

  def self.getPercentagePrints(datum)
    prevPrintsData = FacebookDatum.where('end_date < ? and social_network_id = ?', datum.start_date.to_date, datum.social_network_id).last.prints
    (prevPrintsData != 0) ? (return ((datum.prints.to_f - prevPrintsData).to_f/prevPrintsData.to_f)*100) : ( return 100)
  end

  def self.get_interactions_percentage(datum)
     !isFirstData?(datum) ? (return getPercentageIteractions(datum)) : ( return 0 )
  end

  def self.getPercentageIteractions(datum)
    prevIteractionData = FacebookDatum.where('end_date < ? and social_network_id = ?', datum.start_date.to_date, datum.social_network_id).last.total_interactions
    (prevIteractionData != 0) ? ( return ((datum.total_interactions.to_f-prevIteractionData.to_f)/prevIteractionData.to_f)*100) : ( return 100)
  end

  def self.percentage_total_reach(datum) 
    !isFirstData?(datum) ? (return getPercentageTotalReach(datum)) : (return 0)
  end

  def self.getPercentageTotalReach(datum)
    prevTotalReach = FacebookDatum.where('end_date < ? and social_network_id = ?',datum.start_date.to_date, datum.social_network_id).last.total_reach
    (prevTotalReach != 0) ? (return ((datum.total_reach - prevTotalReach).to_f/prevTotalReach.to_f) * 100) : ( return 0)
  end

  def self.percentage_change_interactions(datum) 
    !isFirstData?(datum) ? (return getPercentageChangeInteractions(datum)) : ( return 0) 
  end

  def self.getPercentageChangeInteractions(datum)
    prevData = FacebookDatum.where('end_date < ? and social_network_id = ?',datum.start_date.to_date, datum.social_network_id).last
    prevTotalInteractions = get_total_interactions(prevData)
    total_interactions = get_total_interactions(datum)
    return ((total_interactions - prevTotalInteractions).to_f / prevTotalInteractions.to_f) * 100
  end

  def self.percentage_change_prints(datum) 
    !isFirstData?(datum) ? (return getPercentageChangePrints(datum)) : (return 0)
  end

  def self.getPercentageChangePrints(datum)
    prevData = FacebookDatum.where('end_date < ? and social_network_id = ?',datum.start_date.to_date, datum.social_network_id).last
    prevTotalPrints = get_total_prints(prevData)
    total_prints = get_total_prints(datum)
    return ((total_prints - prevTotalPrints).to_f / prevTotalPrints.to_f) * 100
  end

  def self.get_cpm_general(datum)
    total_investment = get_total_investment(datum)
    total_prints = get_total_prints(datum)
    (total_prints != 0) ? (return (total_investment.to_f/total_prints.to_f)/1000.0) : (return 0)
  end

  def self.get_coste_interaction(datum)
   total_investment = get_total_investment(datum)
   total_interaction = get_total_interactions(datum)
   (total_interaction != 0) ? (return (total_investment.to_f/total_interaction.to_f)) : (return 0)
  end

  def self.isFirstData?(datum)
    previous_data = FacebookDatum.where('end_date < ? and social_network_id = ?', datum.start_date.to_date, datum.social_network_id).last
    return previous_data.nil?
  end

  def self.generate_excel(document, social_id, start_date, end_date)
    document.workbook do | wb |
      wb.add_worksheet(:name => "Facebook", :page_margins => margins, :page_setup => page_setup) do |sheet|
        @comments = FacebookComment.find_by_social_network_id(social_id)
        report_data = select_report_data(social_id, start_date, end_date)
        styles = create_report_styles(wb, report_data['size'])
        add_rows_report(sheet, 2)
        sheet.add_row ["","PAGINA DE FACEBOOK"], :style => 3
        add_table(sheet, report_data, styles)
        add_rows_report(sheet, 26)
        add_charts(sheet, report_data['size'])
        add_rows_report(sheet, 14)
        add_images_report(sheet, 281, social_id, styles)
      end
    end
  end

  private

  def self.select_report_data(social_id, start_date, end_date)
    facebook_datum = FacebookDatum.where('social_network_id = ? and start_date >= ? and end_date <= ?', social_id, start_date.to_date, end_date.to_date).order("start_date ASC")
    data = table_rows
    data['widths'] = [1, 32]
    data['size'] = (facebook_datum.size+1)
    create_data_table(data, facebook_datum)
    return data
  end

  def self.add_charts(sheet, size)
    @end_letter = (65 + size).chr
    @labels = sheet["C6:#{@end_letter}6"]
    sheet.add_row ["","GRAFICOS FACEBOOK"], :style => 3
    add_rows_report(sheet, 2)
    insert_community_chart(sheet)
    insert_interactivity_chart(sheet)
    insert_reach_chart(sheet)
    insert_investment_chart(sheet)
    insert_costs_chart(sheet)
  end

  def self.table_rows
    {
      'table' => {
        'dates'=> ['', ''], 'actions'=> ['', 'Acciones durantes el periodo'], 'new_fans' => ['', '# new fans'], 
        'total_fans' =>['', '# fans reales'], 'growth_fans' => ['', '% crecimiento fans'], 'goal_fans' => ['', 'Objetivo fans'], 
        'ranking_espana' => ['', 'Ranking en Espana'], 'ranking_world' => ['', 'Ranking Mundial'], 
        'interactivity_header' => ['', 'Interactividad y Alcance'],'prints' => ['', '# impresiones'], 
        'total_interactions' => ['', '# interacciones'], 'total_reach' => ['', 'Alcance Total'], 
        'change_total_reach' => ['', '% cambio en Alcance Total'], 'potential_reach' => ['', 'Alcance Potencial'],
        'total_prints_per_anno' => ['', '# impresiones anuncios'], 'total_clicks_anno' => ['', '# clics Anuncios'],
        'fans_through_anno' => ['', '# fans a traves de anuncios'], 'total_interactions_platform' => ['', 'Interacciones totales de la marca en plataforma'], 
        'change_interactions' => ['', '% cambio en interacciones'],'total_prints' => ['', 'Impresiones totales de la marca en plataforma'], 
        'change_prints' => ['', '% cambio en impresiones'],'investment_header' => ['', 'Inversion'], 
        'agency_investment' => ['', 'Inversion agencia'], 'new_stock_investment' => ['', 'Inversion nuevas acciones'], 
        'anno_investment' => ['', 'Inversion de anuncios'], 'total_investment' => ['', 'Inversion Total'],
        'costs_header' => ['', 'Costes'], 'ctr_anno' => ['', 'CTR Anuncios'], 'cpm_anno' => ['', 'CPM Anuncios'], 'cpc_anno' => ['', 'CPC Anuncios'],
        'cpm_general' => ['', 'CPM General'], 'cost_per_iteraction'=> ['', 'Coste por Interaccion'], 'cost_per_fan'=> ['', 'Coste por Fan']
      }
    }
  end

  def self.create_data_table(data, facebook_datum)
    facebook_datum.each do |datum|
      facebook_keys.each do |key|
        key.include?("header") ? (value = nil) : (value = datum[key])
        data['table'][key] << value
      end
      data['widths'] << 9
      data['table']['dates'] << datum.start_date.strftime('%d %b') + "-" + datum.end_date.strftime("%d %b")
      data['table']['total_investment'] << get_total_investment(datum).round(2)
      data['table']['growth_fans'] << get_fan_growth_percentage(datum).round(2)
      data['table']['change_total_reach'] << percentage_total_reach(datum).round(2)
      data['table']['total_interactions_platform'] << get_total_interactions(datum).round(2)
      data['table']['change_interactions'] << percentage_change_interactions(datum).round(2)
      data['table']['total_prints'] << get_total_prints(datum).round(2)
      data['table']['change_prints'] << percentage_change_prints(datum).round(2)
      data['table']['cpm_general'] << get_cpm_general(datum).round(2)
      data['table']['cost_per_iteraction'] << get_coste_interaction(datum).round(2)
      data['table']['cost_per_fan'] << get_fan_cost(datum).round(2)
    end
  end

  def self.facebook_keys
    ['interactivity_header', 'investment_header', 'costs_header', 'actions', 'new_fans', 'total_fans', 'goal_fans', 'ranking_espana','ranking_world', 
      'prints', 'total_interactions', 'total_reach', 'potential_reach', 'total_prints_per_anno', 'total_clicks_anno', 'fans_through_anno',
      'agency_investment', 'new_stock_investment', 'anno_investment', 'ctr_anno', 'cpm_anno', 'cpc_anno'
    ]
  end

  def self.insert_community_chart(sheet)
    chart = create_chart(sheet, 70, "Comunidad")
    add_serie(chart, sheet["C8:#{@end_letter}8"], @labels, 'Nuevos Fans')
    add_serie(chart, sheet["C9:#{@end_letter}9"], @labels, 'Fans Totales')
    add_serie(chart, sheet["C11:#{@end_letter}11"], @labels, 'Objetivo Fans')
    add_rows_report(sheet, 24)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.fans]
  end

  def self.insert_interactivity_chart(sheet)
    chart = create_chart(sheet, 111, "Interactividad")
    add_serie(chart, sheet["C16:#{@end_letter}16"], @labels, '# Interacciones')
    add_serie(chart, sheet["C21:#{@end_letter}21"], @labels, '# clics Anuncios')
    add_serie(chart, sheet["C23:#{@end_letter}23"], @labels, 'Interacciones Total Marca Plataforma')
    add_rows_report(sheet, 37)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.interaction]
  end

  def self.insert_reach_chart(sheet)
    chart = create_chart(sheet, 153, "Alcance")
    add_serie(chart, sheet["C15:#{@end_letter}15"], @labels, '# Impresiones')
    add_serie(chart, sheet["C17:#{@end_letter}17"], @labels, 'Alcance Total')
    add_serie(chart, sheet["C19:#{@end_letter}19"], @labels, 'Alcance Potencial')
    add_rows_report(sheet, 39)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.reach]
  end

  def self.insert_investment_chart(sheet)
    chart = create_chart(sheet, 195, "Inversiones")
    add_serie(chart, sheet["C8:#{@end_letter}8"], @labels, '# Nuevos Fans')
    add_serie(chart, sheet["C31:#{@end_letter}31"], @labels, 'Inversion total')
    add_rows_report(sheet, 39)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.investment]
  end

  def self.insert_costs_chart(sheet)
    chart = create_chart(sheet, 237, "Costes")
    add_serie(chart, sheet["C33:#{@end_letter}33"], @labels, 'CTR Anuncios')
    add_serie(chart, sheet["C35:#{@end_letter}35"], @labels, 'CPC anuncios')
    add_serie(chart, sheet["C37:#{@end_letter}37"], @labels, 'Coste por iteracion')
    add_serie(chart, sheet["C34:#{@end_letter}34"], @labels, 'CPM Anuncios')
    add_serie(chart, sheet["C36:#{@end_letter}36"], @labels, 'CPM General')
    add_serie(chart, sheet["C38:#{@end_letter}38"], @labels, 'Coste por fan')
    add_rows_report(sheet, 39)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.cost]
  end
end
