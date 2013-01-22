#encoding: utf-8
class ReportGenerators::BenchmarkReport < ReportGenerators::Base

  def self.can_process? type
    type == BenchmarkDatum
  end

  def add_to(document)
    if !competitors.empty?
      add_information_to document
    end
  end


  private

  def add_information_to document
      @current_row = 0
      @workbook = document.workbook
      @workbook.sheet_by_name(social_network.name[0..30]).nil? ? name = social_network.name[0..30] : name = "#{social_network.name[0..25]}-#{Random.rand(1000)}"
      @worksheet =  @workbook.add_worksheet(:name => name, :page_margins => margins, :page_setup => {:orientation => :landscape, :paper_size => 9,  :fit_to_width => 1, 
                                            :fit_to_height => 10})
      @report_data = select_report_data
      set_headers_and_footers
      create_report_styles
      append_rows 4
      append_row_with ["PÁGINA DE BENCHMARK"], @styles['title']
      append_benchmark_table
      append_rows (66-@current_row)
      append_charts
      append_rows 36
      append_images_benchmark_to_report 180
      @worksheet.column_widths *columns_sizes
      append_headers_and_footers 2033
  end

  def append_benchmark_table
    append_rows 1
    unshift_array(@report_data['x_axis'], ' ', 1)
    dates = dates_array(@report_data['dates'])
    append_row_with dates.take(dates.size - 1), @styles['header']
    append_row_with @report_data['x_axis'], @styles['dates']
    @report_data['competitors'].each do |competitor|
      append_row_with @report_data[competitor]['data'].unshift(competitor), @styles['basic'] 
    end
    append_rows 1
    append_row_with ["Comentario del consultor"], @styles['title']
    append_rows 1
    append_row_with [history_comment_for(1).content] if !history_comment_for(1).nil?
  end

  def append_images_benchmark_to_report position
    last_period_image = ImagesSocialNetwork.where(:social_network_id => social_network.id).order('start_date DESC').order('end_date DESC').first
    start_date_last_period = last_period_image.start_date if !last_period_image.nil?
    end_date_last_period = last_period_image.end_date if !last_period_image.nil?
    images = ImagesSocialNetwork.where('social_network_id = ? and start_date = ? and end_date = ?', social_network.id, start_date_last_period, end_date_last_period)
    images.each do |image|
      @headers << position
      append_rows 5
      append_row_with [image.title], @styles['title']
      append_rows 2
      position = position + 6
      img = File.expand_path(image.attachment.path, __FILE__)
      @worksheet.add_image(:image_src => img) do |sheet_image|
        sheet_image.width = 998
        sheet_image.height = 400
        sheet_image.start_at 0, position
      end
      append_rows 16
      append_row_with ["Comentario"], @styles['title']
      append_rows 1
      append_row_with [image.comment]
      append_rows 33
      position = position + 54
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

  def append_charts
    append_rows 5
    append_row_with ["GRÁFICOS BENCHMAR"], @styles['title']
    append_rows 2
    insert_distribution_chart
    append_rows 28
    insert_totals_chart
  end

  def insert_distribution_chart
    create_chart(66, "Distribución", 18)
    shift_array(@report_data['x_axis'], 2)
    @report_data['competitors'].each do |competitor|
      shift_array(@report_data[competitor]['data'], 2)
      add_serie(@report_data[competitor]['data'], competitor, @report_data['x_axis'])
      add_serie([0],  "", @report_data['x_axis']) if @report_data['competitors'].size == 1
    end
    append_rows 14
    append_comment_chart_for 2
  end

  def insert_totals_chart
    create_chart(125, "Totales", 18)
    @report_data['competitors'].each do |competitor|
      add_serie(@report_data[competitor]['totals'], competitor)
      add_serie([0], "", @report_data['x_axis']) if @report_data['competitors'].size == 1
    end
    append_rows 28
    append_comment_chart_for 3
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
    array = ['','']
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
    @headers ||= [0, 60, 120]
    @footers ||= [59, 119, 179]
  end

  def columns_sizes
    sizes = [27]
    for i in (1..21)
      sizes << 9
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
