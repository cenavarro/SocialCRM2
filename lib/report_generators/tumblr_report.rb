# encoding: utf-8
class ReportGenerators::TumblrReport < ReportGenerators::Base

  def self.can_process? type
    type == TumblrDatum
  end

  def add_to(document)
    if !tumblr_datum.empty?
      @report_data = select_report_data
      set_headers_and_footers
      create_report(document)
      append_headers_and_footers 
    end
  end

  private

  def tumblr_datum
    social_network.tumblr_data.where('start_date >= ? and end_date <= ?', start_date.to_date, end_date.to_date).order("start_date ASC").limit(6)
  end

  def create_report(document)
    set_workbook_and_worksheet(document)
    create_report_styles(tumblr_datum.size + 1)
    append_rows_to_report 7
    @worksheet.add_row ["","PÁGINA DE TUMBLR"], :style => 3
    add_table_to_report
    append_charts_to_report
    append_rows_to_report 15
    add_images_report 161
    @worksheet.column_widths 4, 31, 9, 9, 9, 9, 9, 9
  end

  def append_charts_to_report
    remove_cells_report_table
    append_rows_to_report 15
    @worksheet.add_row ["","GRÁFICOS TUMBLR"], :style => 3
    append_rows_to_report 2
    append_followers_chart
    append_interactivity_chart
    append_investment_chart
  end

  def table_rows
    {
      'dates' => ['',''], 'community_header' => ['','Comunidad'], 
      'new_followers' => ['','Nuevos followers'], 'total_followers' => ['','Followers'], 
      'posts' => ['', 'Post'],
      'interaction_header' => ['', 'Interactividad'], 'likes' => ['', 'Like'],
      'reblogged' => ['','Reblogged'], 'investment_header' => ['','Inversión'], 'investment_agency' => ['', 'Inversión agencia'], 
      'investment_actions' => ['','Inversión nuevas acciones'], 'investment_ads' => ['','Inversión anuncios'], 
      'total_investment' => ['','Inversión total'],
    }
  end

  def select_report_data
    table = table_rows
    tumblr_datum.each do |datum|
      tumblr_keys.each do |key|
        key.include?("header") ? (value = nil) : (value = datum[key])
        table[key] << value
      end
      table['dates'] << "#{datum.start_date.strftime('%d %b')} - #{datum.end_date.strftime('%d %b')}"
      table['total_investment'] << datum.total_investment.round(2)
      table['new_followers'] << datum.new_followers
    end
    table
  end

  def tumblr_keys
    ['community_header', 'total_followers', 'posts', 'interaction_header', 'likes', 'reblogged', 'investment_header', 
      'investment_agency', 'investment_actions', 'investment_ads']
  end

  def append_followers_chart
    chart = create_chart(45, "Followers")
    add_serie(chart, @report_data['new_followers'], @report_data['dates'], 'Nuevos followers')
    add_serie(chart, @report_data['total_followers'], @report_data['dates'], 'Followers')
    append_rows_to_report 24
    @worksheet.add_row ["", "Comentario"], :style => 3
    append_rows_to_report 1
    @worksheet.add_row ["", history_comment_for(2).content] if !history_comment_for(2).nil?
  end

  def append_interactivity_chart
    chart = create_chart(84, "Interactividad")
    add_serie(chart, @report_data['likes'], @report_data['dates'], 'Like')
    add_serie(chart, @report_data['reblogged'], @report_data['dates'], 'Reblogged')
    append_rows_to_report 36
    @worksheet.add_row ["", "Comentario"], :style => 3
    append_rows_to_report 1
    @worksheet.add_row ["", history_comment_for(3).content] if !history_comment_for(3).nil?
  end

  def append_investment_chart
    chart = create_chart(126, "Inversión")
    add_serie(chart, @report_data['new_followers'], @report_data['dates'], 'Nuevos followers')
    add_serie(chart, @report_data['total_investment'], @report_data['dates'], 'Inversión total')
    append_rows_to_report 39
    @worksheet.add_row ["", "Comentario"], :style => 3
    append_rows_to_report 1
    @worksheet.add_row ["", history_comment_for(4).content] if !history_comment_for(4).nil?
  end

  def set_headers_and_footers
    @headers ||= [0, 35, 77, 119]
    @footers ||= [34, 76, 118, 160]
  end


end
