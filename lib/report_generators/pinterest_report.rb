class ReportGenerators::PinterestReport < ReportGenerators::Base

  def self.can_process? type
    type == PinterestDatum
  end

  def add_to(document)
    if !pinterest_datum.empty?
        @comments = social_network.pinterest_comment.where("social_network_id = ?", social_network.id).first
        @report_data = select_report_data
        set_headers_and_footers
        create_report(document)
        append_headers_and_footers
    end
  end

  private

  def pinterest_datum
    social_network.pinterest_data.where('start_date >= ? and end_date <= ?', start_date.to_date, end_date.to_date).order("start_date ASC")
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
      'table' => {
        'dates' => ['',''], 'community_header' => ['','Comunidad'], 'total_followers' => ['','# Followers'],
        'diff_followers' => ['','% de crecimiento'], 'boards' => ['', '# boards'], 'pins' => ['', '# pins'], 
        'interactions_header' => ['', 'Interactividad'], 
        'liked' => ['','# liked'], 'diff_liked' => ['', '% cambio'],
        'repin' => ['','# repin'], 'diff_repin' => ['', '% cambio'],
        'comments' => ['','# comments'], 'diff_comments' => ['', '% cambio'],
        'community_boards' => ['','# community boards'],'diff_community' => ['', '% cambio'],
        'investment_header' => ['','Inversion'], 'investment_agency' => ['', 'Inversion Agencia'], 
        'investment_actions' => ['','Inversion nuevas acciones'], 'investment_ads' => ['','Inversion anuncios'], 
        'total_investment' => ['','Inversion Total'], 'coste_fan' => ['', 'Coste Fan']
      }
    }
  end

  def select_report_data
    table = table_rows
    pinterest_datum.each do |datum|
      pinterest_keys.each do |key|
        key.include?("header") ? (value = nil) : (value = datum[key])
        table['table'][key] << value
      end
      table['table']['dates'] << "#{datum.start_date.strftime('%d %b')} - #{datum.end_date.strftime('%d %b')}"
      table['table']['diff_followers'] << datum.get_percentage_difference_from_previous_total_followers
      table['table']['diff_liked'] << datum.get_percentage_difference_from_previous_liked
      table['table']['diff_repin'] << datum.get_percentage_difference_from_previous_repin
      table['table']['diff_comments'] << datum.get_percentage_difference_from_previous_comments
      table['table']['diff_community'] << datum.get_percentage_difference_from_previous_community_boards
      table['table']['coste_fan'] << datum.coste_fan
      table['table']['total_investment'] << datum.total_investment.round(2)
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
    add_serie(chart, @report_data['table']['total_folowers'], @report_data['table']['dates'], '# followers')
    add_serie(chart, @report_data['table']['boards'], @report_data['table']['dates'], '# boards')
    add_serie(chart, @report_data['table']['pins'], @report_data['table']['dates'], '# pins')
    append_rows_to_report 24
    @worksheet.add_row ["", "Comentario"], :style => 3
    append_rows_to_report
    @worksheet.add_row ["", @comments.comunity]
  end

  def append_interactivity_chart
    chart = create_chart(122, "Interactividad")
    add_serie(chart, @report_data['table']['liked'], @report_data['table']['dates'], '# liked')
    add_serie(chart, @report_data['table']['repin'], @report_data['table']['dates'], '# repin')
    add_serie(chart, @report_data['table']['comments'], @report_data['table']['dates'], '# comments')
    add_serie(chart, @report_data['table']['community_boards'], @report_data['table']['dates'], '# community boards')
    append_rows_to_report 36
    @worksheet.add_row ["", "Comentario"], :style => 3
    append_rows_to_report
    @worksheet.add_row ["", @comments.interaction]
  end

  def append_investment_chart
    chart = create_chart(164, "Inversion")
    add_serie(chart, @report_data['table']['total_investment'], @report_data['table']['dates'], 'Inversion Total')
    add_serie(chart, [], @report_data['table']['dates'], '')
    append_rows_to_report 39
    @worksheet.add_row ["", "Comentario"], :style => 3
    append_rows_to_report
    @worksheet.add_row ["", @comments.investment]
  end

  def set_headers_and_footers
    @headers ||= [0, 73, 115, 157]
    @footers ||= [72, 114, 156, 198]
  end

end
