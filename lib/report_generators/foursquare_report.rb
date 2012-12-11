class ReportGenerators::FoursquareReport < ReportGenerators::Base

  def self.can_process? type
    type == FoursquareDatum
  end

  def add_to(document)
    if !foursquare_datum.empty?
      @comments = social_network.foursquare_comment.where("social_network_id = ?", social_network.id).first
      @report_data = select_report_data
      set_headers_and_footers
      create_report(document)
      append_headers_and_footers
    end
  end

  private

  def foursquare_datum
    social_network.foursquare_data.where('start_date >= ? and end_date <= ?', start_date.to_date, end_date.to_date).order("start_date ASC")
  end

  def create_report(document)
    set_workbook_and_worksheet(document)
    create_report_styles(foursquare_datum.size + 1)
    append_rows_to_report 7
    @worksheet.add_row ["","PAGINA DE FOURSQUARE"], :style => 3
    add_table_to_report
    append_charts_to_report
    append_rows_to_report 15
    add_images_report(159)
    @worksheet.column_widths 4, 31, 9, 9, 9, 9, 9, 9
  end

  def append_charts_to_report
    remove_cells_report_table
    append_rows_to_report 10
    @worksheet.add_row ["","GRAFICOS FOURSQUARE"], :style => 3
    append_rows_to_report 2
    append_followers_chart
    append_interactivity_chart
    append_offers_chart
  end

  def table_rows
    {
      'dates' => ['',''], 'community_header' => ['','Comunidad'], 
      'new_followers' => ['','# nuevos followers'], 'total_followers' => ['','# followers'],
      'interactivity_header' => ['', 'Interactividad'], 'clients' => ['','#clientes'], 
      'diff_clients' => ['', '% diferencia'], 'likes' => ['', '#me gusta'], 'diff_likes' => ['', '% diferencia'], 
      'checkins' => ['', '#check-ins'], 'diff_checkins' => ['', '% diferencia'],
      'campaign_header' => ['','Campana'],
      'total_unlocks' => ['','# unlocks total de las ofertas'], 'diff_unlocks' => ['', '% diferencia'],
      'total_visits' => ['','# visitas total de las ofertas'], 'diff_visits' => ['', '% diferencia']
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
    add_serie(chart, @report_data['new_followers'], @report_data['dates'], '# nuevos followers')
    add_serie(chart, @report_data['total_followers'], @report_data['dates'], '# followers')
    append_rows_to_report 24
    @worksheet.add_row ["", "Comentario"], :style => 3
    append_rows_to_report
    @worksheet.add_row ["", @comments.followers]
  end

  def append_interactivity_chart
    chart = create_chart(82, "Interactividad")
    add_serie(chart, @report_data['clients'], @report_data['dates'], '#clientes')
    add_serie(chart, @report_data['likes'], @report_data['dates'], '#me gusta')
    add_serie(chart, @report_data['checkins'], @report_data['dates'], '#check-ins')
    append_rows_to_report 36
    @worksheet.add_row ["", "Comentario"], :style => 3
    append_rows_to_report
    @worksheet.add_row ["", @comments.interactivity]
  end

  def append_offers_chart
    chart = create_chart(124, "Interactividad (Ofertas)")
    add_serie(chart, @report_data['total_unlocks'], @report_data['dates'], '# unlocks  total de ofertas')
    add_serie(chart, @report_data['total_visits'], @report_data['dates'], '# visitas total de las ofertas')
    append_rows_to_report 39
    @worksheet.add_row ["", "Comentario"], :style => 3
    append_rows_to_report
    @worksheet.add_row ["", @comments.deals]
  end


  def set_headers_and_footers
    @headers ||= [0, 33, 75, 117]
    @footers ||= [32, 74, 116, 157]
  end

end
