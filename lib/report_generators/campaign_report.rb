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
    append_row_with ["PÁGINA DE CAMPANA"], @styles['title']
    append_table_campaign
    append_rows (28-@current_row)
    append_charts_campaign
    append_images_campaign_in_row 58
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

  def append_images_campaign_in_row position
    last_period_image = ImagesSocialNetwork.where(:social_network_id => social_network.id).order('start_date DESC').order('end_date DESC').first
    start_date_last_period = last_period_image.start_date if !last_period_image.nil?
    end_date_last_period = last_period_image.end_date if !last_period_image.nil?
    images = ImagesSocialNetwork.where('social_network_id = ? and start_date = ? and end_date = ?', social_network.id, start_date_last_period, end_date_last_period)
    images.each do |image|
      @headers << position
      append_rows 9
      position = position + 8
      append_row_with [image.title], @styles['title']
      img = File.expand_path(image.attachment.path, __FILE__)
      @worksheet.add_image(:image_src => img) do |sheet_image|
        sheet_image.width = 600
        sheet_image.height = 333
        sheet_image.start_at 0, position
      end
      append_rows 16
      append_row_with ["Comentario"], @styles['title']
      append_rows 1
      append_row_with [image.comment]
      position = position + 21
      @footers << (position - 1)
    end
  end

  def select_report_data
    campaign_data = { "dates" => [''], "data" => [], "header" => [''] }
    row_data = []
    rows_campaign.each do |row|
      row_data = select_row_data(row.id)
      values = row_data.map(&:value)
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
    append_rows 6
    append_row_with ["GRÁFICOS CAMPAÑA"], @styles['title']
    append_rows 2
    append_campaign_chart
  end

  def append_campaign_chart
    create_chart(36, "Gráfico Campaña")
    @report_data['data'].each do |data|
      data.values.first
      add_serie(data.values.first, data.keys.first)
    end
    add_serie([], '') if rows_campaign.size == 1 
    append_rows 14
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
    @headers ||= [0, 29]
    @footers ||= [28, 57]
  end

end
