class ReportGenerators::TuentiReport < ReportGenerators::Base

  def self.can_process? type
    type == TuentiDatum
  end

	def add_to(document)
		tuenti_datum = social_network.tuenti_data.where('start_date >= ? and end_date <= ?', start_date.to_date, end_date.to_date).order("start_date ASC")
		if !tuenti_datum.empty?
			document.workbook do | wb |
				wb.add_worksheet(:name => "Tuenti", :page_margins => margins, :page_setup => page_setup) do |sheet|
					@comments = social_network.tuenti_comment.where("social_network_id = ?", social_network.id).first
					report_data = select_report_data(tuenti_datum)
					styles = create_report_styles(wb, report_data['size'])
	        add_rows_report(sheet, 7)
	        sheet.add_row ["","PAGINA DE TUENTI"], :style => 3
	        add_table(sheet, report_data, styles)
	        add_rows_report(sheet, 41)
	        add_charts(sheet, report_data['size'])
	        add_rows_report(sheet, 15)
	        add_images_report(sheet, 282, social_network.id, styles)
	        header(sheet, 0)
	        footer(sheet, 71)
	        sheet.column_widths 4, 31, 9, 9, 9, 9, 9, 9
	      end
			end
		end
	end

  private

  def select_report_data(tuenti_datum)
    data = table_rows
    data['widths'] = [1, 32]
    data['size'] = (tuenti_datum.size+1)
    create_data_table(data, tuenti_datum)
    return data
  end

  def add_charts(sheet, size)
		@end_letter = (65 + size).chr
		@labels = sheet["C11:#{@end_letter}11"]
		sheet.add_row ["","GRAFICOS TUENTI"], :style => 3
		add_rows_report(sheet, 2)
		insert_followers_chart(sheet)
		insert_interactivity_chart(sheet)
		insert_reach_chart(sheet)
		insert_investment_chart(sheet)
		insert_cost_chart(sheet)
		header(sheet, 72)
		footer(sheet, 113)
		header(sheet, 114)
		footer(sheet, 155)
		header(sheet, 156)
		footer(sheet, 197)
		header(sheet, 198)
		footer(sheet, 239)
		header(sheet, 240)
		footer(sheet, 281)
  end

  def table_rows
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

  def create_data_table(data, tuenti_datum)
    tuenti_datum.each do |datum|
      tuenti_keys.each do |key|
        key.include?("header") ? (value = nil) : ((key == 'cost_fan') ? (value = datum[key].round(2)) : (value = datum[key]))
        data['table'][key] << value
      end
      data['table']['dates'] << "#{datum.start_date.strftime('%d %b')} - #{datum.end_date.strftime('%d %b')}"
      data['table']['growth_fans'] << datum.get_percentage_difference_from_previous_real_fans.round(3)
      data['table']['total_investment'] << datum.total_investment.round(2)
      data['table']['new_fans'] << datum.new_fans
      data['table']['cost_fan'] << datum.cost_fan.round(2)
      data['widths'] << 9
    end
  end

  def tuenti_keys
    ['actions', 'fans_header', 'real_fans', 'goal_fans', 'page_header', 'page_prints', 'unique_total_users', 
      'external_clics', 'clics', 'downloads', 'comments', 'ctr_external_clics', 'upload_photos', 'investment_header', 
      'investment_agency', 'investment_actions', 'investment_ads','costs_header']
  end

  def insert_followers_chart(sheet)
    chart = create_chart(sheet, 81, "Comunidad")
    add_serie(chart, sheet["C14:#{@end_letter}14"], @labels, '# nuevos fans')
    add_serie(chart, sheet["C15:#{@end_letter}15"], @labels, '# Fans Reales')
    add_serie(chart, sheet["C16:#{@end_letter}16"], @labels, 'Objetivos Fans')
    add_rows_report(sheet, 24)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.fans]
  end

  def insert_interactivity_chart(sheet)
    chart = create_chart(sheet, 121, "Interacciones")
    add_serie(chart, sheet["C20:#{@end_letter}20"], @labels, 'Total usuarios unicos')
    add_serie(chart, sheet["C22:#{@end_letter}22"], @labels, 'Clicks')
    add_serie(chart, sheet["C23:#{@end_letter}23"], @labels, 'Descargas')
    add_serie(chart, sheet["C24:#{@end_letter}23"], @labels, 'Numero Comentarios')
    add_serie(chart, sheet["C26:#{@end_letter}26"], @labels, 'Fotos subidas')
    add_rows_report(sheet, 37)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.interaction]
  end

  def insert_reach_chart(sheet)
    chart = create_chart(sheet, 163, "Alcance")
    add_serie(chart, sheet["C19:#{@end_letter}19"], @labels, 'Impresiones de la pagina')
    add_rows_report(sheet, 39)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.reach]
  end

  def insert_investment_chart(sheet)
    chart = create_chart(sheet, 205, "Inversion")
    add_serie(chart, sheet["C28:#{@end_letter}28"], @labels, 'Inversion agencia')
    add_serie(chart, sheet["C29:#{@end_letter}29"], @labels, 'Inversion nuevas acciones')
    add_serie(chart, sheet["C30:#{@end_letter}30"], @labels, 'Inversion anuncios')
    add_serie(chart, sheet["C31:#{@end_letter}31"], @labels, 'Inversion Total')
    add_rows_report(sheet, 39)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.investment]
  end

  def insert_cost_chart(sheet)
    chart = create_chart(sheet, 247, "Costes")
    add_serie(chart, sheet["C33:#{@end_letter}33"], @labels, 'Coste Fan')
    add_rows_report(sheet, 39)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.cost]
  end

end
