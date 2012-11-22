class RowsCampaign < ActiveRecord::Base
  extend ApplicationHelper
  has_many :row_data, :dependent => :destroy

  def self.generate_excel(document, social_id, start_date, end_date)
    document.workbook do | wb |
      wb.add_worksheet(:name => "Campana", :page_margins => margins, :page_setup => page_setup) do |sheet|
        @comments = CampaignComment.find_by_social_network_id(social_id)
        @report_data = select_report_data(social_id, start_date, end_date)
        styles = create_report_styles(wb, @report_data['size'])
        add_rows_report(sheet, 2)
        sheet.add_row ['', "PAGINA DE CAMPANA"], :style => 3
        add_table_campaign(sheet, styles)
        add_rows_report(sheet, 5)
        add_charts(sheet)
        add_rows_report(sheet, 4)
        add_images_campaign_report(sheet, 55, social_id, styles)
      end
    end
  end

  private

  def self.add_table_campaign(sheet, styles)
    add_rows_report(sheet, 2)
    @report_data['dates'].unshift('').unshift('')
    @report_data['header'].unshift('').unshift('')
    sheet.add_row @report_data['dates'], :style => styles['dates'], :height => height_cell, :widths => @report_data['widths']
    sheet.add_row @report_data['header'], :style => styles['header'], :height => height_cell
    @report_data['data'].each do |data|
      data = data.values.first.unshift(data.keys.first).unshift('')
      sheet.add_row data, :style => styles['basic'], :height => height_cell
    end
    add_rows_report(sheet, 1)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.table]
  end

  def self.add_images_campaign_report(document, y_pos, social_id, styles)
    images = ImagesSocialNetwork.where(:social_network_id => social_id)
    images.each do |image|
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
      add_rows_report(document, 6)
      y_pos = y_pos + 36
    end
  end

  def self.select_report_data(social_id, start_date, end_date)
    campaign_data = { "dates" => [], "data" => [], "header" => [], "widths" => [1,1]}
    row_data = []
    rows_campaign = RowsCampaign.where('social_network_id = ?', social_id)
    rows_campaign.each do |row|
      row_data = select_row_data(row.id, start_date, end_date)
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

  def self.select_row_data(id, start_date, end_date)
    if data_in_range?(start_date, end_date)
      row_data = RowDatum.where('rows_campaign_id = ? and start_date >= ? and end_date <= ?', id, start_date.to_date, end_date.to_date).order("start_date ASC")
    else
      row_data = RowDatum.where('rows_campaign_id = ?', id).order("start_date ASC")
    end
  end

  def self.data_in_range?(start_date, end_date)
    (start_date && end_date) ? (true) : (false)
  end

  def self.add_charts(sheet)
    sheet.add_row ["","GRAFICOS CAMPANA"], :style => 3
    add_rows_report(sheet, 2)
    insert_campaign_chart(sheet)
  end

  def self.insert_campaign_chart(sheet)
    chart = create_chart(sheet, 21, "Grafico Campana")
    @report_data['dates'].shift
    @report_data['dates'].shift
    @report_data['data'].each do |data|
      data.values.first.shift
      data.values.first.shift
      add_serie(chart, data.values.first, @report_data['dates'], data.keys.first)
    end
    add_rows_report(sheet, 23)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.chart]
  end

end
