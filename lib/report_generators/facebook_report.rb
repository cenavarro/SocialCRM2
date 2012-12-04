class ReportGenerators::FacebookReport < ReportGenerators::Base

  def self.can_process? type
    type == FacebookDatum
  end

  def add_to(document)
    facebook_datum = social_network.facebook_data.where('start_date >= ? and end_date <= ?', start_date.to_date, end_date.to_date).order("start_date ASC")
    if !facebook_datum.empty?
      document.workbook do | wb |
        wb.add_worksheet(:name => social_network.name, :page_margins => margins, :page_setup => page_setup) do |sheet|
          @comments = social_network.facebook_comment.where("social_network_id = ?", social_network.id).first
          @report_data = select_report_data(facebook_datum)
          styles = create_report_styles(wb, @report_data['size'])
          add_rows_report(sheet, 7)
          sheet.add_row ["","PAGINA DE FACEBOOK"], :style => 3
          add_table(sheet, @report_data, styles)
          add_charts(sheet)
          add_rows_report(sheet, 15)
          add_images_report(sheet, 277, social_network.id, styles)
          header(sheet, 0)
          footer(sheet, 66)
          sheet.column_widths 4, 31, 9, 9, 9, 9, 9, 9
        end
      end
    end
  end

  private

  def select_report_data(facebook_datum)
    data = table_rows
    data['widths'] = [1, 32]
    data['size'] = (facebook_datum.size+1)
    create_data_table(data, facebook_datum)
    return data
  end

  def add_charts(sheet)
    add_rows_report(sheet, 27)
    @end_letter = (65 + @report_data['size']).chr
    sheet.add_row ["","GRAFICOS FACEBOOK"], :style => 3
    add_rows_report(sheet, 2)
    insert_community_chart(sheet)
    insert_interactivity_chart(sheet)
    insert_reach_chart(sheet)
    insert_investment_chart(sheet)
    insert_costs_chart(sheet)
    header(sheet, 67)
    footer(sheet, 108)
    header(sheet, 109)
    footer(sheet, 150)
    header(sheet, 151)
    footer(sheet, 192)
    header(sheet, 193)
    footer(sheet, 234)
    header(sheet, 235)
    footer(sheet, 276)
  end

  def table_rows
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

  def create_data_table(data, facebook_datum)
    facebook_datum.each do |datum|
      facebook_keys.each do |key|
        key.include?("header") ? (value = nil) : (value = datum[key])
        data['table'][key] << value
      end
      data['widths'] << 9
      data['table']['dates'] << datum.start_date.strftime('%d %b') + "-" + datum.end_date.strftime("%d %b")
      data['table']['new_fans'] << datum.new_fans
      data['table']['total_investment'] << datum.total_investment.round(2)
      data['table']['growth_fans'] << datum.get_percentage_difference_from_previous_total_fans.round(2)
      data['table']['change_total_reach'] << datum.get_percentage_difference_from_previous_total_reach.round(2)
      data['table']['total_interactions_platform'] << datum.brand_total_interactions.round(2)
      data['table']['change_interactions'] << datum.get_percentage_difference_from_previous_total_interactions.round(2)
      data['table']['total_prints'] << datum.total_prints.round(2)
      data['table']['change_prints'] << datum.get_percentage_difference_from_previous_total_prints.round(2)
      data['table']['cpm_general'] << datum.cpm_general.round(2)
      data['table']['cost_per_iteraction'] << datum.coste_interactions.round(2)
      data['table']['cost_per_fan'] << datum.fan_cost.round(2)
    end
  end

  def facebook_keys
    ['interactivity_header', 'investment_header', 'costs_header', 'actions', 'total_fans', 'goal_fans', 'ranking_espana','ranking_world', 
      'prints', 'total_interactions', 'total_reach', 'potential_reach', 'total_prints_per_anno', 'total_clicks_anno', 'fans_through_anno',
      'agency_investment', 'new_stock_investment', 'anno_investment', 'ctr_anno', 'cpm_anno', 'cpc_anno'
    ]
  end

  def insert_community_chart(sheet)
    chart = create_chart(sheet, 77, "Comunidad")
    dates = @report_data['table']['dates']
    new_fans = @report_data['table']['new_fans']
    total_fans = @report_data['table']['total_fans']
    goal_fans = @report_data['table']['goal_fans']
    add_serie(chart, new_fans[2, new_fans.size], dates[2,dates.size], 'Nuevos Fans')
    add_serie(chart, total_fans[2, total_fans.size], dates[2,dates.size], 'Fans Totales')
    add_serie(chart, goal_fans[2, goal_fans.size], dates[2,dates.size], 'Objetivo Fans')
    add_rows_report(sheet, 24)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.fans]
  end

  def insert_interactivity_chart(sheet)
    chart = create_chart(sheet, 116, "Interactividad")
    dates = @report_data['table']['dates']
    add_serie(chart, sheet["C21:#{@end_letter}21"], dates[2, dates.size], '# Interacciones')
    add_serie(chart, sheet["C26:#{@end_letter}26"], dates[2, dates.size], '# clics Anuncios')
    add_serie(chart, sheet["C28:#{@end_letter}28"], dates[2, dates.size], 'Interacciones Total Marca Plataforma')
    add_rows_report(sheet, 36)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.interaction]
  end

  def insert_reach_chart(sheet)
    chart = create_chart(sheet, 158, "Alcance")
    dates = @report_data['table']['dates']
    add_serie(chart, sheet["C20:#{@end_letter}20"], dates[2, dates.size], '# Impresiones')
    add_serie(chart, sheet["C22:#{@end_letter}22"], dates[2, dates.size], 'Alcance Total')
    add_serie(chart, sheet["C24:#{@end_letter}24"], dates[2, dates.size], 'Alcance Potencial')
    add_rows_report(sheet, 39)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.reach]
  end

  def insert_investment_chart(sheet)
    chart = create_chart(sheet, 200, "Inversiones")
    dates = @report_data['table']['dates']
    add_serie(chart, sheet["C13:#{@end_letter}13"], dates[2, dates.size], '# Nuevos Fans')
    add_serie(chart, sheet["C36:#{@end_letter}36"], dates[2, dates.size], 'Inversion total')
    add_rows_report(sheet, 39)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.investment]
  end

  def insert_costs_chart(sheet)
    chart = create_chart(sheet, 242, "Costes")
    dates = @report_data['table']['dates']
    add_serie(chart, sheet["C38:#{@end_letter}38"], dates[2, dates.size], 'CTR Anuncios')
    add_serie(chart, sheet["C40:#{@end_letter}40"], dates[2, dates.size], 'CPC anuncios')
    add_serie(chart, sheet["C42:#{@end_letter}42"], dates[2, dates.size], 'Coste por iteracion')
    add_serie(chart, sheet["C39:#{@end_letter}39"], dates[2, dates.size], 'CPM Anuncios')
    add_serie(chart, sheet["C41:#{@end_letter}41"], dates[2, dates.size], 'CPM General')
    add_serie(chart, sheet["C43:#{@end_letter}43"], dates[2, dates.size], 'Coste por fan')
    add_rows_report(sheet, 39)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.cost]
  end
end
