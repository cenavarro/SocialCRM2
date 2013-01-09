# encoding: utf-8
class ReportGenerators::PinterestReport < ReportGenerators::Base

  def self.can_process? type
    type == PinterestDatum
  end

  def add_to(document)
    if !pinterest_datum.empty?
        @report_data = select_report_data
        set_headers_and_footers
        create_report(document)
        append_headers_and_footers
    end
  end

  private

  def pinterest_datum
    social_network.pinterest_data.where('start_date >= ? and end_date <= ?', start_date.to_date, end_date.to_date).order("start_date ASC").limit(6)
  end

  def create_report(document)
    set_workbook_and_worksheet(document)
    create_report_styles(pinterest_datum.size + 1)
    append_rows_to_report 8
    @worksheet.add_row ["","PAGINA DE PINTEREST"], :style => 3
    add_table_to_report
    append_rows_to_report
    append_charts_to_report
    append_rows_to_report 15
    add_images_report 199
    @worksheet.column_widths 4, 31, 9, 9, 9, 9, 9, 9
  end

  def append_charts_to_report
    remove_cells_report_table
    append_rows_to_report 43
    @worksheet.add_row ["","GRAFICOS PINTEREST"], :style => 3
    append_rows_to_report 2
    append_followers_chart
    append_interactivity_chart
    append_investment_chart
  end

  def table_rows
    {
      'dates' => ['',''], 'community_header' => ['','Comunidad'], 'total_followers' => ['','Followers'],
      'diff_followers' => ['','% Crecimiento'], 'boards' => ['', 'Boards'], 'pins' => ['', 'Pins'], 
      'interactions_header' => ['', 'Interactividad'], 
      'liked' => ['','Liked'], 'diff_liked' => ['', '% Cambio'],
      'repin' => ['','Repin'], 'diff_repin' => ['', '% Cambio'],
      'comments' => ['','Comments'], 'diff_comments' => ['', '% Cambio'],
      'community_boards' => ['','Community boards'],'diff_community' => ['', '% Cambio'],
      'investment_header' => ['','Inversión'], 'investment_agency' => ['', 'Inversión agencia'], 
      'investment_actions' => ['','Inversión nuevas acciones'], 'investment_ads' => ['','Inversión anuncios'], 
      'total_investment' => ['','Inversión total'], 'coste_fan' => ['', 'Coste fan']
    }
  end

  def select_report_data
    table = table_rows
    pinterest_datum.each do |datum|
      pinterest_keys.each do |key|
        key.include?("header") ? (value = nil) : (value = datum[key])
        table[key] << value
      end
      table['dates'] << "#{datum.start_date.strftime('%d %b')} - #{datum.end_date.strftime('%d %b')}"
      table['diff_followers'] << datum.get_percentage_difference_from_previous_total_followers
      table['diff_liked'] << datum.get_percentage_difference_from_previous_liked
      table['diff_repin'] << datum.get_percentage_difference_from_previous_repin
      table['diff_comments'] << datum.get_percentage_difference_from_previous_comments
      table['diff_community'] << datum.get_percentage_difference_from_previous_community_boards
      table['coste_fan'] << datum.coste_fan
      table['total_investment'] << datum.total_investment.round(2)
    end
    table
  end

  def pinterest_keys
    ['community_header', 'total_followers', 'interactions_header', 'boards', 'pins', 'liked', 
      'repin', 'comments', 'community_boards', 'investment_header', 'investment_agency', 'investment_actions',
        'investment_ads']
  end

  def append_followers_chart
    chart = create_chart(83, "Comunidad")
    add_serie(chart, @report_data['total_folowers'], @report_data['dates'], 'Followers')
    add_serie(chart, @report_data['boards'], @report_data['dates'], 'Boards')
    add_serie(chart, @report_data['pins'], @report_data['dates'], 'Pins')
    append_rows_to_report 24
    @worksheet.add_row ["", "Comentario"], :style => 3
    append_rows_to_report
    @worksheet.add_row ["", history_comment_for(2).content] if !history_comment_for(2).nil?
  end

  def append_interactivity_chart
    chart = create_chart(122, "Interactividad")
    add_serie(chart, @report_data['liked'], @report_data['dates'], 'Liked')
    add_serie(chart, @report_data['repin'], @report_data['dates'], 'Repin')
    add_serie(chart, @report_data['comments'], @report_data['dates'], 'Comments')
    add_serie(chart, @report_data['community_boards'], @report_data['dates'], 'Community boards')
    append_rows_to_report 36
    @worksheet.add_row ["", "Comentario"], :style => 3
    append_rows_to_report
    @worksheet.add_row ["", history_comment_for(3).content] if !history_comment_for(3).nil?
  end

  def append_investment_chart
    chart = create_chart(164, "Inversión")
    add_serie(chart, @report_data['total_investment'], @report_data['dates'], 'Inversión total')
    add_serie(chart, [], @report_data['dates'], '')
    append_rows_to_report 39
    @worksheet.add_row ["", "Comentario"], :style => 3
    append_rows_to_report
    @worksheet.add_row ["", history_comment_for(4).content] if !history_comment_for(4).nil?
  end

  def set_headers_and_footers
    @headers ||= [0, 73, 115, 157]
    @footers ||= [72, 114, 156, 198]
  end

end
