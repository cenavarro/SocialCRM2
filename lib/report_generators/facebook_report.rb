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
    append_row_with ["PÁGINA DE FACEBOOK"], @styles['title']
    append_table
    append_charts
    append_images 224
    @worksheet.column_widths *columns_widths
    append_headers_and_footers
  end

  def select_report_data
    table = table_rows
    facebook_datum.each do |datum|
      facebook_keys.each do |key, value|
        is_header_or_dates_row?(key)  ? table[key] << nil : ( value = (datum[key].nil? ? datum.send(key.to_sym) : datum[key]))
        table[key] << number_with_precision(value, decimal_format) if !is_header_or_dates_row?(key)
      end
      table['dates'] << datum.start_date.strftime('%d %b') + "-" + datum.end_date.strftime("%d %b")
    end
    table
  end

  def append_charts
    remove_table_legends
    append_rows (65 - current_row)
    append_rows 4
    append_row_with ["GRÁFICOS FACEBOOK"], @styles['title']
    append_community_chart
    append_interactivity_chart
    append_reach_chart
    append_investment_chart
    append_costs_chart
  end

  def append_community_chart
    append_rows (71 - current_row)
    create_chart(current_row, "Comunidad")
    add_serie(@report_data['new_fans'], 'Nuevos fans')
    add_serie(@report_data['total_fans'], 'Fans fotales')
    add_serie(@report_data['goal_fans'], 'Objetivo fans')
    append_rows (86 - current_row)
    append_comment_chart_for 2
  end

  def append_interactivity_chart
    append_rows (101 - current_row)
    create_chart(current_row, "Interactividad")
    add_serie(@report_data['total_interactions'], 'Interacciones')
    add_serie(@report_data['total_clicks_anno'], 'Clics anuncios')
    add_serie(@report_data['brand_total_interactions'], 'Interacciones total marca plataforma')
    append_rows (116 - current_row)
    append_comment_chart_for 3
  end

  def append_reach_chart
    append_rows (133 - current_row)
    create_chart(current_row, "Alcance")
    add_serie(@report_data['prints'], 'Impresiones')
    add_serie(@report_data['total_reach'], 'Alcance total')
    add_serie(@report_data['potential_reach'], 'Alcance potencial')
    append_rows (148 - current_row)
    append_comment_chart_for 4
  end

  def append_investment_chart
    append_rows (165 - current_row)
    create_chart(current_row, "Inversiones")
    add_serie(@report_data['new_fans'], 'Nuevos fans')
    add_serie(@report_data['total_investment'], 'Inversión total')
    append_rows (180 - current_row)
    append_comment_chart_for 5
  end

  def append_costs_chart
    append_rows (197 - current_row)
    create_chart(current_row, "Costes")
    change_comma_symbol
    add_serie(@report_data['ctr_anno'], 'CTR anuncios')
    add_serie(@report_data['cpc_anno'], 'CPC anuncios')
    add_serie(@report_data['coste_interactions'], 'Coste por interacción')
    add_serie(@report_data['cpm_anno'], 'CPM anuncios')
    add_serie(@report_data['cpm_general'], 'CPM general')
    add_serie(@report_data['fan_cost'], 'Coste por fan')
    append_rows (212 - current_row)
    append_comment_chart_for 6
  end

  def change_comma_symbol
    change_comma_by_period_for @report_data['ctr_anno']
    change_comma_by_period_for @report_data['cpc_anno']
    change_comma_by_period_for @report_data['coste_interactions']
    change_comma_by_period_for @report_data['cpm_anno']
    change_comma_by_period_for @report_data['cpm_general']
    change_comma_by_period_for @report_data['fan_cost']
  end

  def facebook_keys
    keys = table_rows
    keys.shift
    keys.collect{ |key, value| key  }
  end

  def set_headers_and_footers
    @headers ||= [0, 64, 96, 128, 160, 192]
    @footers ||= [63, 95, 127, 159, 191, 223]
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
