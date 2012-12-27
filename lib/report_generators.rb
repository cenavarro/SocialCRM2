module ReportGenerators
  class Base
    attr :social_network, :date_range, :comments, :worksheet, :workbook, :styles, :headers, :footers
    delegate :start_date, :end_date, :to => :date_range

    def initialize(social_network, date_range)
      @social_network = social_network
      @date_range = date_range
    end

    def create_chart(position, title, chart_width = 9, height_chart = 23)
      new_chart = (@worksheet.add_chart(Axlsx::Line3DChart, :start_at => [1, position], :end_at => [chart_width, position+height_chart], 
                                        :title => title, :rotX => 0, :rotY => 0))
      new_chart.catAxis.gridlines = false
      new_chart.serAxis.delete = true
      new_chart
    end

    def add_serie(chart, data, labels, title, style = nil)
      chart.add_series :data => data, :labels => labels, :title => title, :style => style
    end

    def add_images_report position
      images = ImagesSocialNetwork.where(:social_network_id => social_network.id)
      images.each do |image|
        header position
        position = position + 10
        @worksheet.add_row ["",image.title], :style => @styles['title'][1]
        img = File.expand_path(image.attachment.path, __FILE__)
        @worksheet.add_image(:image_src => img) do |sheet_image|
          sheet_image.width = 755 
          sheet_image.height = 400
          sheet_image.start_at 1, position
        end
        append_rows_to_report 26
        @worksheet.add_row ["", "Comentario"], :style => 3
        append_rows_to_report 1
        @worksheet.add_row ["", image.comment]
        append_rows_to_report 12
        position = position + 32
        footer position-1
      end
    end

    def create_report_styles size
      title_style = @workbook.styles.add_style(:b => true, :sz => 14, :font_name => "Calibri")
      cell_header = @workbook.styles.add_style(:bg_color => "FF0000", :border => {:style => :thin, :color => "FFFF0000"}, :font_name => "Calibri")
      dates_style = @workbook.styles.add_style(:b => true, :bg_color => "000000", :fg_color => "FFFFFF", 
                                     :border => {:style => :thin, :color => "#FF000000"}, :sz => 9, :font_name => "Calibri")
      basic_style = @workbook.styles.add_style(:border => {:style => :thin, :color => "#00000000"}, :sz => 11, :font_name => "Calibri")
      none_style = @workbook.styles.add_style()
      date_benchmark_style = @workbook.styles.add_style(:size => 5, :font_name => "Calibri")
      @styles = {"title"=> [none_style], "header"=> [none_style], "dates"=> [none_style], "basic"=> [none_style]}
      for i in (1..size) do
        @styles['title'] << title_style
        @styles['header'] << cell_header
        @styles['dates'] << dates_style
        @styles['basic'] << basic_style
      end
    end

    def margins
      {:left => 0, :top => 0, :right => 0, :bottom => 0}
    end

    def page_setup
      {:orientation => :landscape, :paper_size => 9}
    end

    def height_cell
      return 20
    end

    def add_table_to_report
      append_rows_to_report 2
      @report_data.each do |key, data|
        if key.include?("header") || (key=="actions")
          @worksheet.add_row data, :style => @styles['header'], :height => height_cell
        elsif key.include?("dates")
          @worksheet.add_row data, :style => @styles['dates'], :height => height_cell
        else
          @worksheet.add_row data, :style => @styles['basic'], :height => height_cell
        end
      end
      append_rows_to_report 1
      @worksheet.add_row ["", "Comentario"], :style => 3
      append_rows_to_report 1
      @worksheet.add_row ["", @comments.table]
    end

    def header(y_axis, width = 934)
      image_header = File.expand_path(Rails.root.join("public/assets/images/header.jpg"), __FILE__)
      @worksheet.add_image(:image_src => image_header) do |image|
        image.height = 87
        image.width = width
        image.start_at 1, y_axis
      end
    end

    def footer(y_axis, width = 934)
      image_header = File.expand_path(Rails.root.join("public/assets/images/footer.gif"), __FILE__)
      @worksheet.add_image(:image_src => image_header) do |image|
        image.height = 16
        image.width = width
        image.start_at 1, y_axis
      end
    end

    def append_rows_to_report rows=1
      for i in (1..rows)
        @worksheet.add_row
      end
    end

    def remove_cells_report_table
      @report_data.each do |key, data|
        2.times do
          data.shift
        end
      end
    end

    def set_workbook_and_worksheet(document)
      @workbook = document.workbook
      @worksheet = @workbook.add_worksheet(:name => social_network.name, :page_margins => margins, :page_setup => page_setup)
    end

    def append_headers_and_footers width=934
      for i in (0..@headers.size-1)
        header(@headers[i], width)
        footer(@footers[i], width)

      end
    end

  end

  def self.all
    [FacebookReport, 
      TwitterReport,
      LinkedinReport,
      BlogReport,
      TuentiReport,
      YoutubeReport,
      FoursquareReport,
      PinterestReport,
      GooglePlusReport,
      FlickrReport,
      TumblrReport,
      MonitoringReport,
      BenchmarkReport,
      CampaignReport,
      CommentReport,
      SummaryReport
    ]
  end

  def self.for(data_type)
    all.select do |report_generator|
      report_generator.can_process? data_type
    end
  end
end

require 'report_generators/facebook_report'
require 'report_generators/monitoring_report'
require 'report_generators/blog_report'
require 'report_generators/flickr_report'
require 'report_generators/foursquare_report'
require 'report_generators/google_plus_report'
require 'report_generators/linkedin_report'
require 'report_generators/pinterest_report'
require 'report_generators/tuenti_report'
require 'report_generators/tumblr_report'
require 'report_generators/twitter_report'
require 'report_generators/youtube_report'
require 'report_generators/benchmark_report'
require 'report_generators/campaign_report'
require 'report_generators/summary_report'
require 'report_generators/comment_report'
