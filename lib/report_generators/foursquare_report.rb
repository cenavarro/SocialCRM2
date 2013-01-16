# encoding: utf-8
class ReportGenerators::FoursquareReport < ReportGenerators::Base

  def self.can_process? type
    type == FoursquareDatum
  end

  def add_to(document)
    if !foursquare_datum.empty?
      @report_data = select_report_data
      set_headers_and_footers
      create_report(document)
      append_headers_and_footers
    end
  end

  private

  def foursquare_datum
    social_network.foursquare_data.where('start_date >= ? and end_date <= ?', start_date.to_date, end_date.to_date).order("start_date ASC").limit(6)
  end

  def create_report(document)
    set_workbook_and_worksheet(document)
    create_report_styles(foursquare_datum.size + 1)
    append_rows_to_report 7
    @worksheet.add_row ["","PÁGINA DE FOURSQUARE"], :style => 3
    add_table_to_report
    append_charts_to_report
    append_rows_to_report 15
    add_images_report(159)
    @worksheet.column_widths 4, 31, 9, 9, 9, 9, 9, 9
  end

  def append_charts_to_report
    remove_cells_report_table
    append_rows_to_report 10
    @worksheet.add_row ["","GRÁFICOS FOURSQUARE"], :style => 3
    append_rows_to_report 2
    append_followers_chart
    append_interactivity_chart
    append_offers_chart
  end

  def table_rows
    {
      'dates' => ['',''], 'community_header' => ['','Comunidad'], 
      'new_followers' => ['','Nuevos followers'], 'total_followers' => ['','Followers'],
      'interactivity_header' => ['', 'Interactividad'], 'clients' => ['','Clientes'], 
      'diff_clients' => ['', '% Cambio'], 'likes' => ['', 'Me gusta'], 'diff_likes' => ['', '% Cambio'], 
      'checkins' => ['', 'Check-ins'], 'diff_checkins' => ['', '% Cambio'],
      'campaign_header' => ['','Campaña'],
      'total_unlocks' => ['','Unlocks total de las ofertas'], 'diff_unlocks' => ['', '% Cambio'],
      'total_visits' => ['','Visitas totales de las ofertas'], 'diff_visits' => ['', '% Cambio']
    }
  end

  def select_report_data
    table = table_rows
    foursquare_datum.each do |datum|
      foursquare_keys.each do |key|
        key.include?("header") ? (value = nil) : (value = datum[key])
        table[key] << value
      end
      table['dates'] << "#{datum.start_date.strftime('%d %b')} - #{datum.end_date.strftime('%d %b')}"
      table['new_followers'] << datum.new_followers
      table['diff_clients'] << datum.get_percentage_difference_from_previous_clients
      table['diff_likes'] << datum.get_percentage_difference_from_previous_likes
      table['diff_checkins'] << datum.get_percentage_difference_from_previous_checkins
      table['diff_unlocks'] << datum.get_percentage_difference_from_previous_total_unlocks
      table['diff_visits'] << datum.get_percentage_difference_from_previous_total_visits
    end
    table
  end

  def foursquare_keys
    [ 'community_header', 'interactivity_header', 'campaign_header', 'total_followers', 'total_unlocks', 'total_visits', 'clients', 'likes', 'checkins' ]
  end

  def append_followers_chart
    chart = create_chart(43, "Comunidad")
    add_serie(chart, @report_data['new_followers'], @report_data['dates'], 'Nuevos followers')
    add_serie(chart, @report_data['total_followers'], @report_data['dates'], 'Followers')
    append_rows_to_report 24
    @worksheet.add_row ["", "Comentario"], :style => 3
    append_rows_to_report
    @worksheet.add_row ["", history_comment_for(2).content] if !history_comment_for(2).nil?
  end

  def append_interactivity_chart
    chart = create_chart(82, "Interactividad")
    add_serie(chart, @report_data['clients'], @report_data['dates'], 'Clientes')
    add_serie(chart, @report_data['likes'], @report_data['dates'], 'Me gusta')
    add_serie(chart, @report_data['checkins'], @report_data['dates'], 'Check-ins')
    append_rows_to_report 36
    @worksheet.add_row ["", "Comentario"], :style => 3
    append_rows_to_report
    @worksheet.add_row ["", history_comment_for(3).content] if !history_comment_for(3).nil?
  end

  def append_offers_chart
    chart = create_chart(124, "Interactividad (Ofertas)")
    add_serie(chart, @report_data['total_unlocks'], @report_data['dates'], 'Unlocks  total de ofertas')
    add_serie(chart, @report_data['total_visits'], @report_data['dates'], 'Visitas totales de las ofertas')
    append_rows_to_report 39
    @worksheet.add_row ["", "Comentario"], :style => 3
    append_rows_to_report
    @worksheet.add_row ["", history_comment_for(4).content] if !history_comment_for(4).nil?
  end


  def set_headers_and_footers
    @headers ||= [0, 33, 75, 117]
    @footers ||= [32, 74, 116, 157]
  end

end
