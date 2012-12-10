class ReportGenerators::CampaignReport < ReportGenerators::Base
	def self.can_process? type
		type == RowsCampaign
	end

  def add_to(document)
    rows_campaign = social_network.rows_campaign
    if !rows_campaign.empty?
      document.workbook do | wb |
        wb.add_worksheet(:name => social_network.name, :page_margins => margins, :page_setup => page_setup) do |sheet|
        @comments = social_network.campaign_comment.where("social_network_id = ?", social_network.id).first
        @report_data = select_report_data(rows_campaign)
        styles = create_report_styles(wb, @report_data['size'])
        add_rows_report(sheet, 7)
        sheet.add_row ['', "PAGINA DE CAMPANA"], :style => 3
        @row = 8
        add_table_campaign(sheet, styles)
        add_rows_report(sheet, (41-@row))
        add_charts(sheet)
        add_images_campaign_report(sheet, 83, styles)
        header(sheet, 0)
        footer(sheet, 40)
        sheet.column_widths 4, 31, 9, 9, 9, 9, 9, 9
        end
      end
    end
  end

  private

  def add_table_campaign(sheet, styles)
    add_rows_report(sheet, 2)
    @report_data['dates'].unshift('').unshift('')
    @report_data['header'].unshift('').unshift('')
    sheet.add_row @report_data['dates'], :style => styles['dates'], :height => height_cell, :widths => @report_data['widths']
    sheet.add_row @report_data['header'], :style => styles['header'], :height => height_cell
    @report_data['data'].each do |data|
      data = data.values.first.unshift(data.keys.first).unshift('')
      sheet.add_row data, :style => styles['basic'], :height => 13
      @row = @row + 1
    end
    add_rows_report(sheet, 1)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.table]
    @row = @row + 8
  end

  def add_images_campaign_report(document, y_pos, styles)
    images = ImagesSocialNetwork.where(:social_network_id => social_network.id)
    images.each do |image|
      header(document, y_pos)
      add_rows_report(document, 12)
      y_pos = y_pos + 10
      document.add_row ["",image.title], :style => styles['title'][1]
      img = File.expand_path(image.attachment.path, __FILE__)
      document.add_image(:image_src => img) do |sheet_image|
        sheet_image.width = 600
        sheet_image.height = 400
        sheet_image.start_at 1, y_pos
      end
      add_rows_report(document, 26)
      document.add_row ["", "Comentario"], :style => 3
      add_rows_report(document, 1)
      document.add_row ["", image.comment]
      y_pos = y_pos + 32
      footer(document, y_pos - 2) 
    end
  end

  def select_report_data(rows_campaign)
    campaign_data = { "dates" => [], "data" => [], "header" => [], "widths" => [1,1]}
    row_data = []
    rows_campaign.each do |row|
      row_data = select_row_data(row.id)
      values = row_data.map(&:value)
      campaign_data['size'] ||= values.size + 1
      campaign_data['data'] << {"#{row.name}" => values}
    end
    row_data.collect{ |datum| campaign_data['dates'] << datum.start_date.strftime("%d %b ") + datum.end_date.strftime("- %d %b")}.join(', ')
    row_data.each do
      campaign_data['header'] << ''
      campaign_data['widths'] << 11
    end
    campaign_data
  end

  def select_row_data(id)
  		RowDatum.where('rows_campaign_id = ? and start_date >= ? and end_date <= ?', id, start_date.to_date, end_date.to_date).order("start_date ASC")
  end

  def add_charts(sheet)
    add_rows_report(sheet, 7)
    sheet.add_row ["","GRAFICOS CAMPANA"], :style => 3
    add_rows_report(sheet, 2)
    insert_campaign_chart(sheet)
  end

  def insert_campaign_chart(sheet)
    chart = create_chart(sheet, 51, "Grafico Campana")
    @report_data['dates'].shift
    @report_data['dates'].shift
    @report_data['data'].each do |data|
      data.values.first.shift
      data.values.first.shift
      add_serie(chart, data.values.first, @report_data['dates'], data.keys.first)
    end
    add_rows_report(sheet, 24)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.chart]
    header(sheet, 41)
    footer(sheet, 82)
  end

end
