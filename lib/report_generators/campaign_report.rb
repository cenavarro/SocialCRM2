# encoding: utf-8
class ReportGenerators::CampaignReport < ReportGenerators::Base
	def self.can_process? type
		type == RowsCampaign
	end

  def add_to document
    if has_data_for_the_report? 
      add_information_to document
    end
  end

  private

  def has_data_for_the_report?
    !rows_campaign.empty? and !rows_campaign.first.row_data.empty?
  end

  def rows_campaign
    social_network.rows_campaign
  end

  def add_information_to document
    initialize_variables document
    append_rows 5
    append_row_with [social_network.name], @styles['title']
    append_table_campaign
    append_charts_campaign
    append_images 64
    @worksheet.column_widths *columns_widths
    append_headers_and_footers
  end

  def append_table_campaign
    append_rows 2
    append_row_with @report_data['dates'], @styles['dates']
    append_row_with @report_data['header'], @styles['header']
    @report_data['data'].each do |data|
      data = data.values.first.unshift(data.keys.first)
      append_row_with data, @styles['basic']
    end
    append_rows 1
    append_row_with ["Comentario del consultor"], @styles['title']
    append_rows 1
    append_row_with [history_comment_for(1).content] if !history_comment_for(1).nil?
  end

  def select_report_data
    campaign_data = { "dates" => [''], "data" => [], "header" => [''] }
    row_data = []
    rows_campaign.each do |row|
      row_data = select_row_data(row.id)
      values = row_data.collect{ |data| data.value }
      campaign_data['data'] << {"#{row.name}" => values}
    end
    row_data.collect{ |datum| campaign_data['dates'] << "#{datum.start_date.strftime("%d %b")}-#{datum.end_date.strftime("%d %b")}"; campaign_data['header'] << ''}.join(', ')
    campaign_data
  end

  def select_row_data(id)
  		RowDatum.where('rows_campaign_id = ? and start_date >= ? and end_date <= ?', id, start_date.to_date, end_date.to_date).order("start_date ASC").limit(6)
  end

  def append_charts_campaign
    remove_cells_report_table_for_campaign
    append_rows (37 - current_row)
    append_row_with ["GRÁFICOS CAMPAÑA"], @styles['title']
    append_campaign_chart
  end

  def append_campaign_chart
    append_rows (39 - current_row)
    create_chart(current_row, social_network.name)
    @report_data['data'].each do |data|
      data.values.first
      add_serie(data.values.first, data.keys.first)
    end
    add_serie([], '') if rows_campaign.size == 1 
    append_rows (54 - current_row)
    append_comment_chart_for 2
  end

  def remove_cells_report_table_for_campaign
    @report_data['dates'].shift
    @report_data['data'].each do |val|
      val.values.each do |data|
        data.shift
      end
    end
  end

  def set_headers_and_footers
    @headers ||= [0, 32]
    @footers ||= [31, 63]
  end

end
