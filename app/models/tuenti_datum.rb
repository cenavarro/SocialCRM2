class TuentiDatum < ActiveRecord::Base
  extend ApplicationHelper
  belongs_to :social_network

  def self.get_new_fans(datum)
    if !isFirstData?(datum)
      previous_data = TuentiDatum.where('end_date < ? and social_network_id = ?', datum.start_date.to_date, datum.social_network_id).last
      return (datum.real_fans - previous_data.real_fans)
    end
    return 0
  end

  def self.get_total_investment(datum)
    (datum.investment_agency + datum.investment_ads + datum.investment_actions) 
  end

  def self.get_cost_fan(datum)
    total_investment = get_total_investment(datum)
    new_fans = get_new_fans(datum)
    (new_fans != 0) ? (return (total_investment.to_f/new_fans.to_f)) : (return 0)
  end

  def self.get_grown_fans_percent(datum)
    if !isFirstData?(datum)
      previous_data = TuentiDatum.where('end_date < ? and social_network_id = ?', datum.start_date.to_date, datum.social_network_id).last
      return ((datum.real_fans.to_f-previous_data.real_fans.to_f)*100) if previous_data.real_fans != 0
    end
    return datum.new_fans * 100.0
  end

  def self.isFirstData?(datum)
    previous_data = TuentiDatum.where('end_date < ? and social_network_id = ?',datum.start_date.to_date, datum.social_network_id).last
    (previous_data == nil) ? (return true) : (return false)
  end

  def self.generate_excel(document, social_id, start_date, end_date)
    document.workbook do | wb |
      wb.add_worksheet(:name => "Tuenti", :page_margins => margins, :page_setup => page_setup) do |sheet|
        @comments = TuentiComment.find_by_social_network_id(social_id)
        report_data = select_report_data(social_id, start_date, end_date)
        styles = create_report_styles(wb, report_data['size'])
        add_rows_report(sheet, 2)
        sheet.add_row ["","PAGINA DE TUENTI"], :style => 3
        add_table(sheet, report_data, styles)
        add_rows_report(sheet, 41)
        add_charts(sheet, report_data['size'])
        add_rows_report(sheet, 14)
        add_images_report(sheet, 286, social_id, styles)
      end
    end
  end

  private

  def self.select_report_data(social_id, start_date, end_date)
    tuenti_datum = TuentiDatum.where('social_network_id = ? and start_date >= ? and end_date <= ?', social_id, start_date.to_date, end_date.to_date).order("start_date ASC")
    data = table_rows
    data['widths'] = [1, 32]
    data['size'] = (tuenti_datum.size+1)
    create_data_table(data, tuenti_datum)
    return data
  end

  def self.add_charts(sheet, size)
    @end_letter = (65 + size).chr
    @labels = sheet["C6:#{@end_letter}6"]
    sheet.add_row ["","GRAFICOS TUENTI"], :style => 3
    add_rows_report(sheet, 2)
    insert_followers_chart(sheet)
    insert_interactivity_chart(sheet)
    insert_reach_chart(sheet)
    insert_investment_chart(sheet)
    insert_cost_chart(sheet)
  end

  def self.table_rows
    {
      'table' => {
        'dates' => ['',''], 'actions' => ['', 'Acciones Periodo'], 'fans_header' => ['','Fans'], 'new_fans' => ['','# nuevos fans'], 
        'real_fans' => ['','# fans reales'], 'goal_fans' => ['', '# Objetivo Fans'], 'growth_fans' => ['', 'Porcentaje crecimiento fans'],
        'page_header' => ['','Pagina de la empresa'], 'page_prints' => ['', 'Impresiones de la pagina'],
        'unique_total_users' => ['', 'Total de usuario unicos'], 'external_clics' => ['','Clics externos'],
        'clics' => ['','Clicks'], 'downloads' => ['','Descargars'], 'comments' => ['','Numero de comentarios'],
        'ctr_external_clics' => ['','CTR % clic externos'], 'upload_photos' => ['','Fotos subidas'],
        'investment_header' => ['','Inversion'], 'investment_agency' => ['', 'Inversion Agencia'], 'investment_actions' => ['','Inversion nuevas acciones'],
        'investment_ads' => ['','Inversion anuncios'], 'total_investment' => ['','Inversion Total'],
        'costs_header' => ['', 'Coste Fan'], 'cost_fan' => ['','Coste Fan']
      }
    }
  end

  def self.create_data_table(data, tuenti_datum)
    tuenti_datum.each do |datum|
      tuenti_keys.each do |key|
        key.include?("header") ? (value = nil) : ((key == 'cost_fan') ? (value = datum[key].round(2)) : (value = datum[key]))
        data['table'][key] << value
      end
      data['table']['dates'] << "#{datum.start_date.strftime('%d %b')} - #{datum.end_date.strftime('%d %b')}"
      data['table']['growth_fans'] << get_grown_fans_percent(datum).round(2)
      data['table']['total_investment'] << get_total_investment(datum).round(2)
      data['widths'] << 9
    end
  end

  def self.tuenti_keys
    ['actions', 'fans_header', 'new_fans', 'real_fans', 'goal_fans', 'page_header', 'page_prints', 'unique_total_users', 
      'external_clics', 'clics', 'downloads', 'comments', 'ctr_external_clics', 'upload_photos', 'investment_header', 
      'investment_agency', 'investment_actions', 'investment_ads','costs_header','cost_fan']
  end

  def self.insert_followers_chart(sheet)
    chart = create_chart(sheet, 76, "Comunidad")
    add_serie(chart, sheet["C9:#{@end_letter}9"], @labels, '# nuevos fans')
    add_serie(chart, sheet["C10:#{@end_letter}10"], @labels, '# Fans Reales')
    add_serie(chart, sheet["C11:#{@end_letter}11"], @labels, 'Objetivos Fans')
    add_rows_report(sheet, 24)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.fans]
  end

  def self.insert_interactivity_chart(sheet)
    chart = create_chart(sheet, 116, "Interacciones")
    add_serie(chart, sheet["C15:#{@end_letter}15"], @labels, 'Total usuarios unicos')
    add_serie(chart, sheet["C17:#{@end_letter}17"], @labels, 'Clicks')
    add_serie(chart, sheet["C18:#{@end_letter}18"], @labels, 'Descargas')
    add_serie(chart, sheet["C19:#{@end_letter}19"], @labels, 'Numero Comentarios')
    add_serie(chart, sheet["C21:#{@end_letter}21"], @labels, 'Fotos subidas')
    add_rows_report(sheet, 37)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.interaction]
  end

  def self.insert_reach_chart(sheet)
    chart = create_chart(sheet, 158, "Alcance")
    add_serie(chart, sheet["C14:#{@end_letter}14"], @labels, 'Impresiones de la pagina')
    add_rows_report(sheet, 39)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.reach]
  end

  def self.insert_investment_chart(sheet)
    chart = create_chart(sheet, 200, "Inversion")
    add_serie(chart, sheet["C23:#{@end_letter}23"], @labels, 'Inversion agencia')
    add_serie(chart, sheet["C24:#{@end_letter}24"], @labels, 'Inversion nuevas acciones')
    add_serie(chart, sheet["C25:#{@end_letter}25"], @labels, 'Inversion anuncios')
    add_serie(chart, sheet["C26:#{@end_letter}26"], @labels, 'Inversion Total')
    add_rows_report(sheet, 39)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.investment]
  end

  def self.insert_cost_chart(sheet)
    chart = create_chart(sheet, 242, "Costes")
    add_serie(chart, sheet["C28:#{@end_letter}28"], @labels, 'Coste Fan')
    add_rows_report(sheet, 39)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.cost]
  end

end
