class BenchmarkDatum < ActiveRecord::Base
  extend ApplicationHelper
  belongs_to :social_network

  def self.generate_excel(document, social_id, start_date, end_date)
    document.workbook do | wb |
      wb.add_worksheet(:name => "Benchmark", :page_margins => margins, :page_setup => {:orientation => :landscape, :paper_size => 9,  :fit_to_width => 1, 
                       :fit_to_height => 10}) do |sheet|
        @comments = BenchmarkComment.find_by_social_network_id(social_id)
        @report_data = select_report_data(social_id, start_date, end_date)
        styles = create_report_styles(wb, @report_data['size'])
        add_rows_report(sheet, 2)
        sheet.add_row ['', "PAGINA DE BLOG"], :style => 3
        add_table_benchmark(sheet, @report_data, styles)
        add_rows_report(sheet, 5)
        add_charts(sheet, @report_data['size'] - 1)
        add_rows_report(sheet, 4)
        add_images_benchmark_report(sheet, 100, social_id, styles)
      end
    end
  end

  private

  def self.add_table_benchmark(sheet, report_data, styles)
    add_rows_report(sheet, 2)
    report_data['x_axis'].unshift('')
    report_data['x_axis'].unshift('')
    create_widths_table(report_data)
    dates = dates_array(report_data['dates'])
    sheet.add_row dates, :style => 8, :height => height_cell
    sheet.add_row report_data['x_axis'], :style => 4, :height => height_cell
    report_data['competitors'].each do |competitor|
      sheet.add_row report_data[competitor]['data'].unshift(competitor).unshift(''), :style => 6, :height => height_cell, :widths => report_data['widths']
    end
    add_rows_report(sheet, 1)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.table]
  end

  def self.add_images_benchmark_report(document, y_pos, social_id, styles)
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
      report_data['x_axis'].concat(x_axis_array(datum.start_date, datum.end_date))
    end
    return report_data
  end

  def self.add_charts(sheet, size)
    size = size * 7
    sheet.add_row ["","GRAFICOS BLOG"], :style => 3
    add_rows_report(sheet, 2)
    insert_distribution_chart(sheet, size)
    insert_totals_chart(sheet, size)
  end

  def self.insert_distribution_chart(sheet, size)
    chart = create_chart(sheet, 21, "Distribucion", size)
    @report_data['x_axis'].shift
    @report_data['x_axis'].shift
    @report_data['competitors'].each do |competitor|
      @report_data[competitor]['data'].shift
      @report_data[competitor]['data'].shift
      add_serie(chart, @report_data[competitor]['data'], @report_data['x_axis'], competitor)
    end
    add_rows_report(sheet, 23)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.distribution]
  end

  def self.insert_totals_chart(sheet, size)
    chart = create_chart(sheet, 66, "Totales", size)
    @report_data['competitors'].each do |competitor|
      add_serie(chart, @report_data[competitor]['totals'], @report_data['dates'], competitor)
    end
    add_rows_report(sheet, 42)
    sheet.add_row ["", "Comentario"], :style => 3
    add_rows_report(sheet, 1)
    sheet.add_row ["", @comments.totals]
  end

  def self.data_of_competitor(id, start_date, end_date)
    if get_data_in_range?(start_date, end_date) 
      data = BenchmarkDatum.where('start_date >= ? and end_date <= ? and benchmark_competitor_id = ?', 
                                  start_date.to_date, end_date.to_date, id).order("start_date ASC") 
    else
      data = BenchmarkDatum.where(:benchmark_competitor_id => id).order("start_date ASC")
    end
  end

  def self.get_data_in_range?(start_date, end_date)
    (start_date && end_date) ? (true) : (false)
  end

  def self.benchmark_keys
    ['blogs',
      'forums',
      'videos',
      'twitter',
      'facebook',
      'others'
    ]
  end

  def self.x_axis_array_with_dates(start_date, end_date)
    ['Blogs', 
      "Foros      #{start_date.strftime("%d %b")}",
      "Videos   al",
      "Twitter     #{end_date.strftime("%d %b")}",
      "Facebook",
      "Otros"
    ]
  end

  def self.x_axis_array(start_date, end_date)
    ['Blogs',
      "Foros",
      "Videos",
      "Twitter",
      "Facebook",
      "Otros",
      "Total"
    ]
  end

  def self.create_widths_table(report_data)
    competitor_name = report_data['competitors'].first
    data = report_data[competitor_name]['data']
    report_data['widths'] = [1, 3]
    data.each do
      report_data['widths'] << 5
    end
    pos = 4
    for i in (1..report_data['dates'].size)
      report_data['widths'][pos] = 11
      pos = pos + 7
    end
  end

  def self.dates_array(dates)
    array = ['','','','']
    dates.each do |date|
      array << date
      for i in (1..6)
        array << ''
      end
    end
    array
  end
end
