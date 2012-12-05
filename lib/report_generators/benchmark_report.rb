class ReportGenerators::BenchmarkReport < ReportGenerators::Base

  def self.can_process? type
    type == BenchmarkDatum
  end

  def add_to(document)
    if !competitors.empty?
      document.workbook do | wb |
        wb.add_worksheet(:name => social_network.name, :page_margins => margins, :page_setup => {:orientation => :landscape, :paper_size => 9,  :fit_to_width => 1, 
                         :fit_to_height => 10}) do |sheet|
          @comments = social_network.benchmark_comment.where("social_network_id = ?", social_network.id).first
          @report_data = select_report_data
          styles = create_report_styles(wb, @report_data['size'])
          add_rows_report(sheet, 7)
          sheet.add_row ['', "PAGINA DE BENCHMARK"], :style => 3
          @row = 8
          add_table_benchmark(sheet, styles)
          add_rows_report(sheet, (54-@row))
          add_charts(sheet, @report_data['size'] - 1)
          add_rows_report(sheet, 20)
          add_images_benchmark_report(sheet, 165, styles)
          sheet.column_widths *columns_sizes
          add_headers_and_footers(sheet)
        end
      end
    end
  end

  private

  def add_table_benchmark(sheet, styles)
    add_rows_report(sheet, 2)
    unshift_array(@report_data['x_axis'], ' ', 2)
    dates = dates_array(@report_data['dates'])
    sheet.add_row dates, :style => 8, :height => height_cell
    sheet.add_row @report_data['x_axis'], :style => 4, :height => height_cell
    @report_data['competitors'].each do |competitor|
      sheet.add_row @report_data[competitor]['data'].unshift(competitor).unshift(''), :style => 6, :height => 13 
      @row = @row + 1
    end
    add_rows_report(sheet, 1)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.table]
    @row = @row + 8
  end

  def add_images_benchmark_report(document, y_pos, styles)
    images = ImagesSocialNetwork.where(:social_network_id => social_network.id)
    images.each do |image|
      headers << y_pos
      add_rows_report(document, 7)
      document.add_row ["",image.title], :style => styles['title'][1]
      add_rows_report(document, 2)
      y_pos = y_pos + 10 
      img = File.expand_path(image.attachment.path, __FILE__)
      document.add_image(:image_src => img) do |sheet_image|
        sheet_image.width = 600
        sheet_image.height = 400
        sheet_image.start_at 1, y_pos
      end
      add_rows_report(document, 24)
      document.add_row ["", "Comentario"], :style => 3
      add_rows_report(document, 1)
      document.add_row ["", image.comment]
      add_rows_report(document, 18)
      y_pos = y_pos + 45
      footers << (y_pos - 2)
    end
  end

  def select_report_data
    report_data = {"x_axis" => []}
    competitors = BenchmarkCompetitor.where('social_network_id = ?', social_network.id).order("name ASC")
    report_data['competitors'] = competitors.map(&:name)
    competitors.each do |competitor|
      competitor_data = data_of_competitor(competitor.id)
      report_data['size'] ||= (competitor_data.size+1)
      report_data['dates'] ||= competitor_data.collect { |datum| "#{datum.start_date.strftime("%d %b")} - #{datum.end_date.strftime("%d %b")}"}
      report_data[competitor.name] = {"data" => [], "totals" => []}
      competitor_data.each do |datum|
        total = 0
        benchmark_keys.each do |key|
          total = total + datum[key]
          report_data[competitor.name]['data'].push(datum[key])
        end
        report_data[competitor.name]['data'].push(total)
        report_data[competitor.name]['totals'].push(total)
      end
    end
    data = data_of_competitor(competitors.first.id)
    data.each do |datum|
      report_data['x_axis'].concat(x_axis_array)
    end
    return report_data
  end

  def add_charts(sheet, size)
    size = size * 7
    add_rows_report(sheet, 7)
    sheet.add_row ["","GRAFICOS BENCHMAR"], :style => 3
    add_rows_report(sheet, 2)
    insert_distribution_chart(sheet, size)
    add_rows_report(sheet, 14)
    insert_totals_chart(sheet, size)
  end

  def insert_distribution_chart(sheet, size)
    chart = create_chart(sheet, 64, "Distribucion", 18)
    shift_array(@report_data['x_axis'], 2)
    @report_data['competitors'].each do |competitor|
      shift_array(@report_data[competitor]['data'], 2)
      add_serie(chart, @report_data[competitor]['data'], @report_data['x_axis'], competitor)
      add_serie(chart, [0], @report_data['x_axis'], "")
    end
    add_rows_report(sheet, 24)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.distribution]
  end

  def insert_totals_chart(sheet, size)
    chart = create_chart(sheet, 118, "Totales", 18)
    @report_data['competitors'].each do |competitor|
      add_serie(chart, @report_data[competitor]['totals'], @report_data['dates'], competitor)
      add_serie(chart, [0], @report_data['x_axis'], "")
    end
    add_rows_report(sheet, 37)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.totals]
  end

  def data_of_competitor id
      BenchmarkDatum.where('start_date >= ? and end_date <= ? and benchmark_competitor_id = ?', 
                           start_date.to_date, end_date.to_date, id).limit(3).order("start_date ASC") 
  end

  def benchmark_keys
    ['blogs', 'forums', 'videos', 'twitter', 'facebook', 'others']
  end

  def x_axis_array
    ['Blogs', "Foros", "Videos", "Twitter", "Facebook", "Otros", "Total"]
  end

  def dates_array(dates)
    array = ['','','']
    dates.each do |date|
      array << date[0,6]
      array << ''
      array << "al"
      array << date[8,date.size]
      for i in (1..3)
        array << ''
      end
    end
    array
  end

  def headers
    @header_positions ||= [0, 54, 109]
  end

  def footers
    @footer_positions ||= [53, 108, 164]
  end

  def add_headers_and_footers(sheet)
    for i in (0..headers.size-1)
      header(sheet, headers[i], 1267)
      footer(sheet, footers[i], 1267)
    end
  end

  def columns_sizes
    sizes = [4, 27]
    for i in (1..21)
      sizes << 5
    end
    sizes
  end

  def competitors
    BenchmarkCompetitor.where('social_network_id = ?', social_network.id).order("name ASC")
  end

  def shift_array(array, times = 1)
    for i in (1..times)
      array.shift
    end 
  end

  def unshift_array(array, value, times = 1)
    for i in (1..times)
      array.unshift(value)
    end
  end

end
