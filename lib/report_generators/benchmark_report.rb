class ReportGenerators::BenchmarkReport < ReportGenerators::Base

  def self.can_process? type
    type == BenchmarkDatum
  end

  def add_rows(sheet, amount)
    @row = @row + amount
    add_rows_report(sheet, amount)
  end

  def add_to(document)
    competitors = BenchmarkCompetitor.where('social_network_id = ?', social_network.id).order("name ASC")
    if !competitors.empty?
      document.workbook do | wb |
        wb.add_worksheet(:name => "Benchmark", :page_margins => margins, :page_setup => {:orientation => :landscape, :paper_size => 9,  :fit_to_width => 1, 
                         :fit_to_height => 10}) do |sheet|
          @comments = social_network.benchmark_comment.where("social_network_id = ?", social_network.id).first
          @report_data = select_report_data(social_network.id, start_date, end_date)
          @row = 0
          styles = create_report_styles(wb, @report_data['size'])
          add_rows(sheet, 7)
          sheet.add_row ['', "PAGINA DE BENCHMARK"], :style => 3
          @row = @row + 1
          add_table_benchmark(sheet, @report_data, styles)
          add_rows(sheet, (54-@row))
          add_charts(sheet, @report_data['size'] - 1)
          add_rows(sheet, (168-@row))
          add_images_benchmark_report(sheet, social_network.id, styles)
          header(sheet, 0, 1267)
          footer(sheet, 53, 1267)
          args = [4, 27]
          for i in (1..21)
            args << 5
          end
          sheet.column_widths *args
        end
      end
    end
  end

  private

  def add_table_benchmark(sheet, report_data, styles)
    add_rows(sheet, 2)
    report_data['x_axis'].unshift('')
    report_data['x_axis'].unshift('')
    dates = dates_array(report_data['dates'])
    sheet.add_row dates, :style => 8, :height => height_cell
    sheet.add_row report_data['x_axis'], :style => 4, :height => height_cell
    @row = @row + 2
    report_data['competitors'].each do |competitor|
      sheet.add_row report_data[competitor]['data'].unshift(competitor).unshift(''), :style => 6, :height => height_cell
      @row = @row + 1
    end
    @row = @row - ((report_data['competitor'].size)/2)
    add_rows(sheet, 1)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows(sheet, 1)
    sheet.add_row ["", @comments.table]
    @row = @row + 2
  end

  def add_images_benchmark_report(document, social_id, styles)
    images = ImagesSocialNetwork.where(:social_network_id => social_id)
    images.each do |image|
      header(document, @row, 1267)
      add_rows(document, 7)
      document.add_row ["",image.title], :style => styles['title'][1]
      @row = @row + 1
      add_rows(document, 2)
      img = File.expand_path(image.attachment.path, __FILE__)
      document.add_image(:image_src => img) do |sheet_image|
        sheet_image.width = 600
        sheet_image.height = 400
        sheet_image.start_at 1, @row
      end
      add_rows(document, 24)
      document.add_row ["", "Comentario"], :style => 3
      add_rows(document, 1)
      document.add_row ["", image.comment]
      add_rows(document, 19)
      @row = @row + 2
      footer(document, @row, 1267)
      add_rows(document, 1)
    end
  end

  def select_report_data(social_id, start_date, end_date)
    report_data = {"x_axis" => []}
    competitors = BenchmarkCompetitor.where('social_network_id = ?', social_id).order("name ASC")
    report_data['competitors'] = competitors.map(&:name)
    competitors.each do |competitor|
      competitor_data = data_of_competitor(competitor.id, start_date, end_date)
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
    data = data_of_competitor(competitors.first.id, start_date, end_date)
    data.each do |datum|
      report_data['x_axis'].concat(x_axis_array)
    end
    return report_data
  end

  def add_charts(sheet, size)
    size = size * 7
    add_rows(sheet, 7)
    sheet.add_row ["","GRAFICOS BENCHMAR"], :style => 3
    @row = @row + 1
    add_rows(sheet, 2)
    insert_distribution_chart(sheet, size)
    add_rows(sheet, 14)
    insert_totals_chart(sheet, size)
    header(sheet, 54, 1267)
    footer(sheet, 110, 1267)
    header(sheet, 111, 1267)
    footer(sheet, 167, 1267)
  end

  def insert_distribution_chart(sheet, size)
    chart = create_chart(sheet, 64, "Distribucion", size)
    @report_data['x_axis'].shift
    @report_data['x_axis'].shift
    @report_data['competitors'].each do |competitor|
      @report_data[competitor]['data'].shift
      @report_data[competitor]['data'].shift
      add_serie(chart, @report_data[competitor]['data'], @report_data['x_axis'], competitor)
    end
    add_rows(sheet, 24)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows(sheet, 1)
    sheet.add_row ["", @comments.distribution]
    @row = @row + 2
  end

  def insert_totals_chart(sheet, size)
    chart = create_chart(sheet, 118, "Totales", size)
    @report_data['competitors'].each do |competitor|
      add_serie(chart, @report_data[competitor]['totals'], @report_data['dates'], competitor)
    end
    add_rows(sheet, 37)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows(sheet, 1)
    sheet.add_row ["", @comments.totals]
    @row = @row + 2
  end

  def data_of_competitor(id, start_date, end_date)
    if data_in_range?(start_date, end_date) 
      data = BenchmarkDatum.where('start_date >= ? and end_date <= ? and benchmark_competitor_id = ?', 
                                  start_date.to_date, end_date.to_date, id).limit(3).order("start_date ASC") 
    else
      data = BenchmarkDatum.where(:benchmark_competitor_id => id).limit(3).order("start_date ASC")
    end
  end

  def data_in_range?(start_date, end_date)
    (start_date && end_date) ? (true) : (false)
  end

  def benchmark_keys
    ['blogs',
      'forums',
      'videos',
      'twitter',
      'facebook',
      'others'
    ]
  end

  def x_axis_array
    ['Blogs',
      "Foros",
      "Videos",
      "Twitter",
      "Facebook",
      "Otros",
      "Total"
    ]
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

end
