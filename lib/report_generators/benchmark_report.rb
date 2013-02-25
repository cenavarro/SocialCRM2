#encoding: utf-8
class ReportGenerators::BenchmarkReport < ReportGenerators::Base

  attr :auxiliar_row

  def self.can_process? type
    type == BenchmarkDatum
  end

  def add_to document
    if !competitors.empty?
      add_information_to document
    end
  end


  private

  def add_information_to document
    initialize_varialbes_benchmark document
    @headers << 0
    append_rows 4
    append_row_with ["PÁGINA DE BENCHMARK"], @styles['title']
    append_benchmark_table
    (current_row >= page_size) ? append_rows((page_size * 2) - current_row) : append_rows(page_size - current_row)
    @auxiliar_row = current_row
    @footers << (auxiliar_row - 1)
    append_charts
    current_row = auxiliar_row
    append_images current_row 
    append_headers_and_footers
    @worksheet.column_widths *columns_widths
  end

  def append_charts
    @report_data['dates'].shift
    @report_data['columns'][1].shift
    for i in (0...@report_data['size']) do
      @headers << auxiliar_row
      insert_distribution_chart i
      append_rows ((auxiliar_row + page_size) - current_row)
      @auxiliar_row = auxiliar_row + page_size
      @footers << (auxiliar_row - 1)
    end
    @headers << auxiliar_row
    insert_totals_chart
    @auxiliar_row = auxiliar_row + page_size
    @footers << (auxiliar_row - 1)
  end

  def create_report_data
    @report_data = {'columns' => []}
    @report_data['competitors'] = competitors.map(&:name)
    competitors.each do |competitor|
      competitor_data = data_of_competitor(competitor)
      @report_data['dates'] ||= competitor_data.collect { |datum| "#{datum.start_date.strftime("%d %b")} - #{datum.end_date.strftime("%d %b")}"}
      @report_data[competitor.name] = {"data" => [], "totals" => []}
      competitor_data.each do |datum|
        @report_data[competitor.name]['data'] << (datum['values'][1..-2].split(",").collect{|v| v.to_i})
        total = datum['values'][1..-2].split(",").inject(0){|result, value| result += value.to_i}
        @report_data[competitor.name]['totals'].push(total)
      end
    end
    @report_data['dates'].each do |d|
      @report_data['columns'] << (columns.map(&:name))
    end
    @report_data['size'] = @report_data['dates'].size
    !@report_data['columns'][0].nil? ? @report_data['num_columns'] = @report_data['columns'][0].size : @report_data['num_columns'] = 0
  end

  def append_benchmark_table
    append_rows 1
    unshift_array(@report_data['columns'], ' ', 1)
    unshift_array(@report_data['dates'], ' ', 1)
    @report_data['competitors'].each do |competitor|
      @report_data[competitor]['data'].unshift(competitor)
    end
    for i in (1..@report_data['size']) do
      date = create_dates_header(@report_data['dates'][i])
      append_row_with date, @styles['dates']
      unshift_array(@report_data['columns'][i], ' ', 1)
      append_row_with @report_data['columns'][i], @styles['header']
      @report_data['competitors'].each do |competitor|
        unshift_array(@report_data[competitor]['data'][i], competitor, 1)
        append_row_with @report_data[competitor]['data'][i], @styles['basic']
      end
      if (i >= 2)
        append_rows ((page_size - 1) - current_row) if current_row >= 20
      end
      append_rows 1
    end
    append_rows (33 - current_row) if current_row >= 28
    append_row_with ["Comentario del consultor"], @styles['title']
    append_rows 1
    append_comment(history_comment_for(1).content) if !history_comment_for(1).nil?
  end

  def insert_distribution_chart position
    append_rows 4
    append_row_with ["Periodo: #{@report_data['dates'][position]}"], @styles['title']
    append_rows 1
    create_chart(current_row, "Distribución #{position + 1}")
    @report_data['competitors'].each do |competitor|
      @report_data[competitor]['data'][position+1].shift
      add_serie(@report_data[competitor]['data'][position+1], competitor, @report_data['columns'][1])
      add_serie([0],  "") if @report_data['competitors'].size == 1
    end
    append_rows 15
    append_comment_chart_for 2
  end

  def insert_totals_chart
    append_rows 5
    create_chart(current_row, "Totales")
    @report_data['competitors'].each do |competitor|
      add_serie(@report_data[competitor]['totals'], competitor)
      add_serie([0], "") if @report_data['competitors'].size == 1
    end
    append_rows 15
    append_comment_chart_for 3
  end

  def create_dates_header date
    date_header = ['', date]
    for i in (1..@report_data['num_columns'] - 1) do
      date_header << ''
    end
    date_header
  end

  def competitors
    social_network.benchmark_competitor.order("name ASC")
  end

  def columns
    social_network.benchmark_columns.order("id ASC")
  end

  def where_conditions
    @where_conditions = "start_date >= '#{start_date.to_date}' and end_date <= '#{end_date.to_date}'"
  end

  def data_of_competitor competitor
    competitor.benchmark_data.where(where_conditions).limit(3).order("start_date ASC")
  end

  def unshift_array(array, value, times = 1)
    for i in (1..times)
      array.unshift(value)
    end
  end

  def initialize_varialbes_benchmark document
    @headers ||= []
    @footers ||= []
    @current_row = 0
    @auxiliar_row = 0
    @workbook = document.workbook
    @workbook.sheet_by_name(social_network.name[0..30]).nil? ? name = social_network.name[0..30] : name = "#{social_network.name[0..25]}-#{Random.rand(1000)}"
    @worksheet = @workbook.add_worksheet(name: name, page_margins: margins, page_setup: {orientation: :landscape, paper_size: 9})
    create_report_data
    create_report_styles
  end

end
