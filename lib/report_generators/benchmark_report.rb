class ReportGenerators::BenchmarkReport < ReportGenerators::Base

  def self.can_process? type
    type == BenchmarkDatum
  end

  def add_to(document)
    if !competitors.empty?
      @comments = social_network.benchmark_comment.where("social_network_id = ?", social_network.id).first
      @report_data = select_report_data
      set_headers_and_footers
      create_report(document)
      append_headers_and_footers(1625)
    end
  end


  private

  def create_report(document)
      @workbook = document.workbook
      @workbook.sheet_by_name(social_network.name).nil? ? name = social_network.name : name = "#{social_network.name}-#{Random.rand(1000)}"
      @worksheet =  @workbook.add_worksheet(:name => name, :page_margins => margins, :page_setup => {:orientation => :landscape, :paper_size => 9,  :fit_to_width => 1, 
                                            :fit_to_height => 10})
      size = (@report_data['size'] - 1) * 7
      create_report_styles(@report_data['size'])
      append_rows_to_report(7)
      @worksheet.add_row ['', "PAGINA DE BENCHMARK"], :style => 3
      @row = 8
      append_benchmark_table
      append_rows_to_report(68-@row)
      append_charts_to_report
      append_rows_to_report(36)
      append_images_benchmark_to_report(207)
      @worksheet.column_widths *columns_sizes
  end

  def append_benchmark_table
    append_rows_to_report(2)
    unshift_array(@report_data['x_axis'], ' ', 2)
    dates = dates_array(@report_data['dates'])
    @worksheet.add_row dates, :style => 8, :height => height_cell
    @worksheet.add_row @report_data['x_axis'], :style => 6, :height => height_cell
    @report_data['competitors'].each do |competitor|
      @worksheet.add_row @report_data[competitor]['data'].unshift(competitor).unshift(''), :style => 8, :height => 13 
      @row = @row + 1
    end
    append_rows_to_report
    @worksheet.add_row ["", "Comentario"], :style => 3
    append_rows_to_report
    @worksheet.add_row ["", @comments.table]
    @row = @row + 8
  end

  def append_images_benchmark_to_report position
    images = ImagesSocialNetwork.where(:social_network_id => social_network.id)
    images.each do |image|
      @headers << position
      append_rows_to_report(7)
      @worksheet.add_row ["",image.title], :style => @styles['title'][1]
      append_rows_to_report(2)
      position = position + 10 
      img = File.expand_path(image.attachment.path, __FILE__)
      @worksheet.add_image(:image_src => img) do |sheet_image|
        sheet_image.width = 998
        sheet_image.height = 400
        sheet_image.start_at 1, position
      end
      append_rows_to_report(24)
      @worksheet.add_row ["", "Comentario"], :style => 3
      append_rows_to_report
      @worksheet.add_row ["", image.comment]
      append_rows_to_report(32)
      position = position + 59 
      @footers << (position - 2)
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

  def append_charts_to_report
    size = (@report_data['size'] - 1) * 7
    append_rows_to_report 7
    @worksheet.add_row ["","GRAFICOS BENCHMAR"], :style => 3
    append_rows_to_report 2
    insert_distribution_chart size
    append_rows_to_report 26 
    insert_totals_chart size
  end

  def insert_distribution_chart size
    chart = create_chart(78, "Distribucion", 18)
    shift_array(@report_data['x_axis'], 2)
    @report_data['competitors'].each do |competitor|
      shift_array(@report_data[competitor]['data'], 2)
      add_serie(chart, @report_data[competitor]['data'], @report_data['x_axis'], competitor)
      add_serie(chart, [0], @report_data['x_axis'], "")
    end
    append_rows_to_report 24
    @worksheet.add_row ["", "Comentario"], :style => 3
    append_rows_to_report
    @worksheet.add_row ["", @comments.distribution]
  end

  def insert_totals_chart size
    chart = create_chart(144, "Totales", 18)
    @report_data['competitors'].each do |competitor|
      add_serie(chart, @report_data[competitor]['totals'], @report_data['dates'], competitor)
      add_serie(chart, [0], @report_data['x_axis'], "")
    end
    append_rows_to_report 37
    @worksheet.add_row ["", "Comentario"], :style => 3
    append_rows_to_report
    @worksheet.add_row ["", @comments.totals]
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
      array << ''
      array << date[8,date.size]
      for i in (1..2)
        array << ''
      end
    end
    array
  end

  def set_headers_and_footers
    @headers ||= [0, 68, 137]
    @footers ||= [67, 136, 206]
  end

  def columns_sizes
    sizes = [4, 27]
    for i in (1..21)
      sizes << 7
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
