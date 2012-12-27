# encoding: utf-8
class ReportGenerators::FlickrReport < ReportGenerators::Base

  def self.can_process? type
    type == FlickrDatum
  end

  def add_to(document)
    if !flickr_datum.empty?
      @comments = social_network.flickr_comment.where("social_network_id = ?", social_network.id).first
      @report_data = select_report_data
      set_headers_and_footers
      create_report(document)
      append_headers_and_footers
    end
  end

  private

  def flickr_datum
    social_network.flickr_data.where('start_date >= ? and end_date <= ?', start_date.to_date, end_date.to_date).order("start_date ASC").limit(6)
  end

  def create_report(document)
    set_workbook_and_worksheet(document)
    create_report_styles(flickr_datum.size + 1)
    append_rows_to_report 7
    @worksheet.add_row ["","PAGINA FLICKR"], :style => 3
    add_table_to_report
    append_charts_to_report
    append_rows_to_report 15
    add_images_report 161
    @worksheet.column_widths 4, 31, 9, 9, 9, 9, 9, 9
  end

  def append_charts_to_report
    append_rows_to_report 15
    @worksheet.add_row ["","GRAFICOS FLICKR"], :style => 3
    append_rows_to_report 2
    append_community_chart
    append_interactivity_chart
    append_investment_chart
  end

  def table_rows
    {
      'dates' => ['',''], 'community_header' => ['','Comunidad'], 'new_contacts' => ['','Nuevos contactos'], 
      'total_contacts' => ['','Contactos'], 'interactivity_header' => ['','Interactividad'], 'visits' => ['','Visitas'],
      'comments' => ['','Comentarios'], 'favorites' => ['', 'Favoritos'], 'investment_header' => ['','Inversión'], 
      'investment_agency' => ['','Inversión agencia'], 'investment_actions' => ['', 'Inversión nuevas acciones'],
      'investment_ads' => ['','Inversión anuncios'], 'total_investment' => ['','Inversión total']
    }
  end

  def select_report_data
    table = table_rows
    flickr_datum.each do |datum|
      flickr_keys.each do |key|
        key.include?("header") ? (value = nil) : (value = datum[key])
        table[key] << value
      end
      table['dates'] << "#{datum.start_date.strftime('%d %b')} - #{datum.end_date.strftime('%d %b')}"
      table['new_contacts'] << datum.new_contacts
      table['total_investment'] << datum.total_investment.round(2)
    end
    table
  end

  def flickr_keys
    [ 'community_header', 'total_contacts', 'interactivity_header', 'visits', 'comments', 'favorites', 
      'investment_header', 'investment_agency', 'investment_actions', 'investment_ads']
  end

  def append_community_chart
    chart = create_chart(45, "Comunidad")
    add_serie(chart, @report_data['new_contacts'], @report_data['dates'], 'Nuevos contactos')
    add_serie(chart, @report_data['total_contacts'], @report_data['dates'], 'Contactos')
    append_rows_to_report 24
    @worksheet.add_row ["", "Comentario"], :style => 3
    append_rows_to_report 1
    @worksheet.add_row ["", @comments.community]
  end

  def append_interactivity_chart
    chart = create_chart(84, "Interactividad")
    add_serie(chart, @report_data['visits'], @report_data['dates'], 'Visitas')
    add_serie(chart, @report_data['comments'], @report_data['dates'], 'Comentarios')
    add_serie(chart, @report_data['favorites'], @report_data['dates'], 'Favorios') 
    append_rows_to_report 36
    @worksheet.add_row ["", "Comentario"], :style => 3
    append_rows_to_report 1
    @worksheet.add_row ["", @comments.interaction]
  end

  def append_investment_chart
    chart = create_chart(126, "Inversión")
    add_serie(chart, @report_data['new_contacts'], @report_data['dates'], 'Nuevos contactos')
    add_serie(chart, @report_data['total_investment'], @report_data['dates'], 'Inversión total')
    append_rows_to_report 39
    @worksheet.add_row ["", "Comentario"], :style => 3
    append_rows_to_report 1
    @worksheet.add_row ["", @comments.investment]
  end

  def set_headers_and_footers
    @headers ||= [0, 35, 77, 119]
    @footers ||= [34, 76, 118, 160]
  end
end
