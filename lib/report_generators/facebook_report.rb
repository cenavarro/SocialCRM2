# encoding: utf-8
class ReportGenerators::FacebookReport < ReportGenerators::Base

  def self.can_process? type
    type == FacebookDatum
  end

  def add_to document
    if !facebook_datum.empty?
      add_information_to document
    end
  end

  private

  def facebook_datum
    social_network.facebook_data.where('start_date >= ? and end_date <= ?', start_date.to_date, end_date.to_date).order("start_date ASC").limit(6)
  end

  def add_information_to document
    initialize_variables document
    append_rows 5
    append_row_with ["PÁGINA DE FACEBOOK"]
    append_table
    append_charts
    append_rows 15
    @worksheet.column_widths *columns_widths
    append_headers_and_footers
  end

  def select_report_data
    table = table_rows
    facebook_datum.each do |datum|
      facebook_keys.each do |key, value|
        is_header_or_dates_row?(key)  ? table[key] << nil : (table[key] << (datum[key].nil? ? datum.send(key.to_sym) : datum[key]))
      end
      table['dates'] << datum.start_date.strftime('%d %b') + "-" + datum.end_date.strftime("%d %b")
    end
    table
  end

  def facebook_keys
    keys = table_rows
    keys.shift
    keys.collect{ |key, value| key  }
  end

  def append_charts
    remove_table_legends
    append_rows 18
    append_row_with ["GRÁFICOS FACEBOOK"]
    append_rows 2
    append_community_chart
    append_interactivity_chart
    append_reach_chart
    append_investment_chart
    append_costs_chart
  end

  def append_community_chart
    create_chart(65, "Comunidad")
    add_serie(@report_data['new_fans'], 'Nuevos fans')
    add_serie(@report_data['total_fans'], 'Fans fotales')
    add_serie(@report_data['goal_fans'], 'Objetivo fans')
    append_rows 14
    append_comment_chart_for 2
  end

  def append_interactivity_chart
    create_chart(92, "Interactividad")
    add_serie(@report_data['total_interactions'], 'Interacciones')
    add_serie(@report_data['total_clicks_anno'], 'Clics anuncios')
    add_serie(@report_data['total_interactions_platform'], 'Interacciones total marca plataforma')
    append_rows 24
    append_comment_chart_for 3
  end

  def append_reach_chart
    create_chart(121, "Alcance")
    add_serie(@report_data['prints'], 'Impresiones')
    add_serie(@report_data['total_reach'], 'Alcance total')
    add_serie(@report_data['potential_reach'], 'Alcance potencial')
    append_rows 26
    append_comment_chart_for 4
  end

  def append_investment_chart
    create_chart(150, "Inversiones")
    add_serie(@report_data['new_fans'], 'Nuevos fans')
    add_serie(@report_data['total_investment'], 'Inversión total')
    append_rows 26
    append_comment_chart_for 5
  end

  def append_costs_chart
    create_chart(179, "Costes")
    add_serie(@report_data['ctr_anno'], 'CTR anuncios')
    add_serie(@report_data['cpc_anno'], 'CPC anuncios')
    add_serie(@report_data['cost_per_interaction'], 'Coste por interación')
    add_serie(@report_data['cpm_anno'], 'CPM anuncios')
    add_serie(@report_data['cmp_general'], 'CPM general')
    add_serie(@report_data['coste_per_fan'], 'Coste por fan')
    append_rows 26
    append_comment_chart_for 6
  end

  def is_header_or_dates_row? key
    ['costs_header', 'interactivity_header', 'investment_header', 'actions', 'dates'].include?(key)
  end

  def set_headers_and_footers
    @headers ||= [0, 58, 87, 116, 145, 174]
    @footers ||= [57, 86, 115, 144, 173, 202]
  end

  def table_rows
    {
      'dates'=> [''], 'actions'=> ['Acciones durantes el periodo'], 
      'new_fans' => ['Nuevos fans'], 
      'total_fans' =>['Fans totales'], 
      'get_percentage_difference_from_previous_total_fans' => ['% Crecimiento'], 
      'goal_fans' => ['Objetivo fans'], 
      'ranking_espana' => ['Ranking en España'], 
      'ranking_world' => ['Ranking mundial'], 
      'interactivity_header' => ['Interactividad y Alcance'], 
      'prints' => ['Impresiones'], 
      'total_interactions' => ['Interacciones'], 
      'total_reach' => ['Alcance total'], 
      'get_percentage_difference_from_previous_total_reach' => ['% Cambio en alcance total'], 
      'potential_reach' => ['Alcance potencial'],
      'total_prints_per_anno' => ['Impresiones anuncios'], 
      'total_clicks_anno' => ['Clics en anuncios'],
      'fans_through_anno' => ['Fans a través de anuncios'], 
      'brand_total_interactions' => ['Interacciones totales de la marca en plataforma'], 
      'get_percentage_difference_from_previous_total_interactions' => ['% Cambio en interacciones'], 
      'total_prints' => ['Impresiones totales de la marca en plataforma'], 
      'get_percentage_difference_from_previous_total_prints' => ['% Cambio en impresiones'],
      'investment_header' => ['Inversión'], 
      'agency_investment' => ['Inversión agencia'], 
      'new_stock_investment' => ['Inversión nuevas acciones'], 
      'anno_investment' => ['Inversión de anuncios'], 
      'total_investment' => ['Inversión total'],
      'costs_header' => ['Costes'], 
      'ctr_anno' => ['CTR anuncios'], 
      'cpm_anno' => ['CPM anuncios'], 
      'cpc_anno' => ['CPC anuncios'],
      'cpm_general' => ['CPM general'], 
      'coste_interactions'=> ['Coste por interación'], 
      'fan_cost'=> ['Coste por fan']
    }
  end

end
