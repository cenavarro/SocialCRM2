# encoding: utf-8
class ReportGenerators::GooglePlusReport < ReportGenerators::Base

  def self.can_process? type
    type == GooglePlusDatum
  end

  def add_to(document)
    if !google_datum.empty?
      @report_data = select_report_data
      set_headers_and_footers
      create_report(document)
      append_headers_and_footers
    end
  end

  private

  def google_datum
    social_network.google_plus_data.where('start_date >= ? and end_date <= ?', start_date.to_date, end_date.to_date).order("start_date ASC").limit(6)
  end

  def create_report(document)
    set_workbook_and_worksheet(document)
    create_report_styles(google_datum.size + 1)
    append_rows_to_report 7
    @worksheet.add_row ["","PAGINA DE GOOGLE+"], :style => 3
    add_table_to_report
    append_charts_to_report 
    append_rows_to_report 15
    add_images_report 160
    @worksheet.column_widths 4, 31, 9, 9, 9, 9, 9, 9
  end

  def append_charts_to_report
    remove_cells_report_table
    append_rows_to_report 12
    @worksheet.add_row ["","GRAFICOS GOOGLE+"], :style => 3
    append_rows_to_report 2
    append_community_chart
    append_interactivity_chart
    append_investment_chart
  end

  def table_rows
    {
      'dates' => ['',''], 'community_header' => ['','Comunidad'], 'new_followers' => ['','Nuevos followers'], 'total_followers' => ['','Followers'], 
      'growth_followers' => ['', '% Crecimiento seguidores'], 'interactions_header' => ['', 'Interactividad'], 'plus' => ['', '(+1s)'],
      'content_shared' => ['', 'Compartir contenido'], 'total_interactions' => ['','Total de interacciones'], 'change_interactions' => ['','% Cambio en interacciones'],
      'investment_header' => ['','Inversión'], 'investment_agency' => ['', 'Inversión agencia'], 'investment_actions' => ['','Inversión nuevas acciones'],
      'investment_ads' => ['','Inversión anuncios'], 'total_investment' => ['','Inversión total']
    }
  end

  def select_report_data
    table = table_rows
    google_datum.each do |datum|
      google_plus_keys.each do |key|
        key.include?("header") ? (value = nil) : (value = datum[key])
        table[key] << value
      end
      table['dates'] << "#{datum.start_date.strftime('%d %b')} - #{datum.end_date.strftime('%d %b')}"
      table['new_followers'] << datum.new_followers
      table['growth_followers'] << datum.get_percentage_difference_from_previous_total_followers.round(3)
      table['total_interactions'] << datum.total_interactions
      table['change_interactions'] << datum.get_percentage_difference_from_previous_total_interactions.round(3)
      table['total_investment'] << datum.total_investment.round(2)
    end
    table
  end

  def google_plus_keys
    ['community_header', 'total_followers', 'interactions_header', 'plus', 'content_shared', 
      'investment_header', 'investment_agency', 'investment_actions', 'investment_ads']
  end

  def append_community_chart
    chart = create_chart(44, "Comunidad")
    add_serie(chart, @report_data['new_followers'], @report_data['dates'], 'Nuevos followers')
    add_serie(chart, @report_data['total_followers'], @report_data['dates'], 'Followers')
    append_rows_to_report 24
    @worksheet.add_row ["", "Comentario"], :style => 3
    append_rows_to_report 1
    @worksheet.add_row ["", history_comment_for(2).content] if !history_comment_for(2).nil?
  end

  def append_interactivity_chart
    chart = create_chart(83, "Interactividad")
    add_serie(chart, @report_data['plus'], @report_data['dates'], '(+1s)')
    add_serie(chart, @report_data['content_shared'], @report_data['dates'], 'Compartir contenido')
    add_serie(chart, @report_data['total_interactions'], @report_data['dates'], 'Total interacciones')
    append_rows_to_report 36
    @worksheet.add_row ["", "Comentario"], :style => 3
    append_rows_to_report 1
    @worksheet.add_row ["", history_comment_for(3).content] if !history_comment_for(3).nil?
  end

  def append_investment_chart
    chart = create_chart(125, "Inversión")
    add_serie(chart, @report_data['new_followers'], @report_data['dates'], 'Nuevos followers')
    add_serie(chart, @report_data['total_investment'], @report_data['dates'], 'Inversión total')
    append_rows_to_report 39
    @worksheet.add_row ["", "Comentario"], :style => 3
    append_rows_to_report 1
    @worksheet.add_row ["", history_comment_for(4).content] if !history_comment_for(4).nil?
  end

  def set_headers_and_footers
    @headers ||= [0, 34, 76, 118]
    @footers ||= [33, 75, 117, 159]
  end

end
