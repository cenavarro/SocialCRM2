class ReportGenerators::CampaignReport < ReportGenerators::Base
	def self.can_process? type
		type == RowsCampaign
	end

  def add_to(document)
    if has_data_for_the_report? 
      @comments = social_network.campaign_comment.where("social_network_id = ?", social_network.id).first
      @report_data = select_report_data(rows_campaign)
      set_headers_and_footers
      create_report(document)
      append_headers_and_footers
    end
  end

  private

  def has_data_for_the_report?
    !rows_campaign.empty? and !rows_campaign.first.row_data.empty?
  end

  def rows_campaign
    social_network.rows_campaign
  end

  def create_report(document)
    set_workbook_and_worksheet(document)
    create_report_styles(@report_data['dates'].size + 1)
    append_rows_to_report 7
    @worksheet.add_row ['', "PAGINA DE CAMPANA"], :style => 3
    @row = 8
    add_table_campaign
    append_rows_to_report(41 - @row)
    append_charts_to_report
    add_images_campaign_report(83)
    @worksheet.column_widths 4, 31, 9, 9, 9, 9, 9, 9
  end

  def set_headers_and_footers
    @headers ||= [0, 41]
    @footers ||= [40, 82]
  end

  def add_table_campaign
    append_rows_to_report 2
    @worksheet.add_row @report_data['dates'], :style => @styles['dates'], :height => height_cell
    @worksheet.add_row @report_data['header'], :style => @styles['header'], :height => height_cell
    @report_data['data'].each do |data|
      data = data.values.first.unshift(data.keys.first).unshift('')
      @worksheet.add_row data, :style => styles['basic'], :height => 13
      @row = @row + 1
    end
    append_rows_to_report 1
    @worksheet.add_row ["", "Comentario"], :style => 3
    append_rows_to_report 1
    @worksheet.add_row ["", @comments.table]
    @row = @row + 8
  end

  def add_images_campaign_report(position)
    images = ImagesSocialNetwork.where(:social_network_id => social_network.id)
    images.each do |image|
      @headers << position
      append_rows_to_report 12
      position = position + 10
      @worksheet.add_row ["",image.title], :style => styles['title'][1]
      img = File.expand_path(image.attachment.path, __FILE__)
      @worksheet.add_image(:image_src => img) do |sheet_image|
        sheet_image.width = 600
        sheet_image.height = 400
        sheet_image.start_at 1, position
      end
      append_rows_to_report 26
      @worksheet.add_row ["", "Comentario"], :style => 3
      append_rows_to_report 1
      @worksheet.add_row ["", image.comment]
      position = position + 32
      @footers << (position - 2)
    end
  end

  def select_report_data(rows_campaign)
    campaign_data = { "dates" => ['',''], "data" => [], "header" => ['',''] }
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
  		RowDatum.where('rows_campaign_id = ? and start_date >= ? and end_date <= ?', id, start_date.to_date, end_date.to_date).order("start_date ASC")
  end

  def append_charts_to_report
    remove_cells_report_table_for_campaign
    append_rows_to_report 7
    @worksheet.add_row ["","GRAFICOS CAMPANA"], :style => 3
    append_rows_to_report 2
    append_campaign_chart
  end

  def append_campaign_chart
    chart = create_chart(51, "Grafico Campana")
    @report_data['data'].each do |data|
      data.values.first
      add_serie(chart, data.values.first, @report_data['dates'], data.keys.first)
    end
    add_serie(chart, [], @report_data['dates'], '') if rows_campaign.size == 1 
    append_rows_to_report 24
    @worksheet.add_row ["", "Comentario"], :style => 3
    append_rows_to_report 1
    @worksheet.add_row ["", @comments.chart]
  end

  def remove_cells_report_table_for_campaign
    @report_data['dates'].shift
    @report_data['dates'].shift
    @report_data['data'].each do |val|
      val.values.each do |data|
        2.times do
          data.shift
        end
      end
    end
  end

end
