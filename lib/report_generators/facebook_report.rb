class ReportGenerators::FacebookReport < ReportGenerators::Base

  def self.can_process? type
    type == FacebookDatum
  end

  def add_to(document)
    if !facebook_datum.empty?
      @comments = social_network.facebook_comment.where("social_network_id = ?", social_network.id).first
      @report_data = select_report_data
      set_headers_and_footers
      create_report(document)
      append_headers_and_footers
    end
  end

  private

  def facebook_datum
    social_network.facebook_data.where('start_date >= ? and end_date <= ?', start_date.to_date, end_date.to_date).order("start_date ASC").limit(6)
  end

  def create_report(document)
    set_workbook_and_worksheet(document)
    create_report_styles(facebook_datum.size + 1)
    append_rows_to_report 7
    @worksheet.add_row ["","PAGINA DE FACEBOOK"], :style => 3
    add_table_to_report
    append_charts_to_report
    append_rows_to_report 15
    add_images_report(277)
    @worksheet.column_widths 4, 31, 9, 9, 9, 9, 9, 9
  end

  def append_charts_to_report
    remove_cells_report_table
    append_rows_to_report 27
    @worksheet.add_row ["","GRAFICOS FACEBOOK"], :style => 3
    append_rows_to_report 2
    append_community_chart
    append_interactivity_chart
    append_reach_chart
    append_investment_chart
    append_costs_chart
  end

  def table_rows
    {
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
  end

  def select_report_data
    table = table_rows
    facebook_datum.each do |datum|
      facebook_keys.each do |key|
        key.include?("header") ? (value = nil) : (value = datum[key])
        table[key] << value
      end
      table['dates'] << datum.start_date.strftime('%d %b') + "-" + datum.end_date.strftime("%d %b")
      table['new_fans'] << datum.new_fans
      table['total_investment'] << datum.total_investment.round(2)
      table['growth_fans'] << datum.get_percentage_difference_from_previous_total_fans.round(2)
      table['change_total_reach'] << datum.get_percentage_difference_from_previous_total_reach.round(2)
      table['total_interactions_platform'] << datum.brand_total_interactions.round(2)
      table['change_interactions'] << datum.get_percentage_difference_from_previous_total_interactions.round(2)
      table['total_prints'] << datum.total_prints.round(2)
      table['change_prints'] << datum.get_percentage_difference_from_previous_total_prints.round(2)
      table['cpm_general'] << datum.cpm_general.round(2)
      table['cost_per_iteraction'] << datum.coste_interactions.round(2)
      table['cost_per_fan'] << datum.fan_cost.round(2)
    end
    table
  end

  def facebook_keys
    ['interactivity_header', 'investment_header', 'costs_header', 'actions', 'total_fans', 'goal_fans', 'ranking_espana','ranking_world', 
      'prints', 'total_interactions', 'total_reach', 'potential_reach', 'total_prints_per_anno', 'total_clicks_anno', 'fans_through_anno',
      'agency_investment', 'new_stock_investment', 'anno_investment', 'ctr_anno', 'cpm_anno', 'cpc_anno'
    ]
  end

  def append_community_chart
    chart = create_chart(77, "Comunidad")
    add_serie(chart, @report_data['new_fans'], @report_data['dates'], 'Nuevos Fans')
    add_serie(chart, @report_data['total_fans'], @report_data['dates'], 'Fans Totales')
    add_serie(chart, @report_data['goal_fans'], @report_data['dates'], 'Objetivo Fans')
    append_rows_to_report 24
    @worksheet.add_row ["", "Comentario"], :style => 3
    append_rows_to_report 1
    @worksheet.add_row ["", @comments.fans]
  end

  def append_interactivity_chart
    chart = create_chart(116, "Interactividad")
    add_serie(chart, @report_data['total_interactions'], @report_data['dates'], '# Interacciones')
    add_serie(chart, @report_data['total_clicks_anno'], @report_data['dates'], '# clics Anuncios')
    add_serie(chart, @report_data['total_interactions_platform'], @report_data['dates'], 'Interacciones Total Marca Plataforma')
    append_rows_to_report 36
    @worksheet.add_row ["", "Comentario"], :style => 3
    append_rows_to_report 1
    @worksheet.add_row ["", @comments.interaction]
  end

  def append_reach_chart
    chart = create_chart(158, "Alcance")
    add_serie(chart, @report_data['prints'], @report_data['dates'], '# Impresiones')
    add_serie(chart, @report_data['total_reach'], @report_data['dates'], 'Alcance Total')
    add_serie(chart, @report_data['potential_reach'], @report_data['dates'], 'Alcance Potencial')
    append_rows_to_report 39
    @worksheet.add_row ["", "Comentario"], :style => 3
    append_rows_to_report 1
    @worksheet.add_row ["", @comments.reach]
  end

  def append_investment_chart
    chart = create_chart(200, "Inversiones")
    add_serie(chart, @report_data['new_fans'], @report_data['dates'], '# Nuevos Fans')
    add_serie(chart, @report_data['total_investment'], @report_data['dates'], 'Inversion total')
    append_rows_to_report 39
    @worksheet.add_row ["", "Comentario"], :style => 3
    append_rows_to_report 1
    @worksheet.add_row ["", @comments.investment]
  end

  def append_costs_chart
    chart = create_chart(242, "Costes")
    add_serie(chart, @report_data['ctr_anno'], @report_data['dates'], 'CTR Anuncios')
    add_serie(chart, @report_data['cpc_anno'], @report_data['dates'], 'CPC anuncios')
    add_serie(chart, @report_data['cost_per_interaction'], @report_data['dates'], 'Coste por iteracion')
    add_serie(chart, @report_data['cpm_anno'], @report_data['dates'], 'CPM Anuncios')
    add_serie(chart, @report_data['cmp_general'], @report_data['dates'], 'CPM General')
    add_serie(chart, @report_data['coste_per_fan'], @report_data['dates'], 'Coste por fan')
    append_rows_to_report 39
    @worksheet.add_row ["", "Comentario"], :style => 3
    append_rows_to_report 1
    @worksheet.add_row ["", @comments.cost]
  end

  def set_headers_and_footers
    @headers ||= [0, 67, 109, 151, 193, 235]
    @footers ||= [66, 108, 150, 192, 234, 276]
  end
end
