module ReportGenerators
  class Base
    attr :social_network, :date_range, :comments, :worksheet, :workbook
    delegate :start_date, :end_date, :to => :date_range

    def initialize(social_network, date_range)
      @social_network = social_network
      @date_range = date_range
    end

    def create_chart(document, y_pos,title, chart_width = 9, height_chart = 23)
      new_chart = (document.add_chart(Axlsx::Line3DChart, :start_at => [1, y_pos], :end_at => [chart_width, y_pos+height_chart], :title => title, :rotX => 0, :rotY => 0))
      new_chart.catAxis.gridlines = false
      new_chart.serAxis.delete = true
      return new_chart
    end

    def add_serie(chart, data, labels, title, style = nil)
      chart.add_series :data => data, :labels => labels, :title => title, :style => style
    end

    def add_rows_report(document, amount = 1)
      for i in (1..amount)
        document.add_row
      end
    end

    def add_images_report(document, y_pos, styles)
      images = ImagesSocialNetwork.where(:social_network_id => social_network.id)
      images.each do |image|
        header(document, y_pos)
        y_pos = y_pos + 10
        document.add_row ["",image.title], :style => styles['title'][1]
        img = File.expand_path(image.attachment.path, __FILE__)
        document.add_image(:image_src => img) do |sheet_image|
          sheet_image.width = 755 
          sheet_image.height = 400
          sheet_image.start_at 1, y_pos
        end
        add_rows_report(document, 26)
        document.add_row ["", "Comentario"], :style => 3
        add_rows_report(document, 1)
        document.add_row ["", image.comment]
        add_rows_report(document, 12)
        y_pos = y_pos + 32
        footer(document, y_pos-1)
      end
    end

    def create_report_styles(workbook, size)
      styles = workbook.styles
      title_style = styles.add_style(:b => true, :sz => 14, :font_name => "Calibri")
      cell_header = styles.add_style(:bg_color => "FF0000", :border => {:style => :thin, :color => "FFFF0000"}, :font_name => "Calibri")
      dates_style = styles.add_style(:b => true, :bg_color => "000000", :fg_color => "FFFFFF", 
                                     :border => {:style => :thin, :color => "#FF000000"}, :sz => 9, :font_name => "Calibri")
      basic_style = styles.add_style(:border => {:style => :thin, :color => "#00000000"}, :sz => 11, :font_name => "Calibri")
      none_style = styles.add_style()
      date_benchmark_style = styles.add_style(:size => 5, :font_name => "Calibri")
      styles_hash = {"title"=> [none_style], "header"=> [none_style], "dates"=> [none_style], "basic"=> [none_style]}
      for i in (1..size) do
        styles_hash['title'] << title_style
        styles_hash['header'] << cell_header
        styles_hash['dates'] << dates_style
        styles_hash['basic'] << basic_style
      end
      return styles_hash
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

    def add_table(sheet, report_data, styles)
      add_rows_report(sheet, 2)
      report_data['table'].each do |key, data|
        if key.include?("header") || (key=="actions")
          sheet.add_row data, :style => styles['header'], :height => height_cell
        elsif key.include?("dates")
          sheet.add_row data, :style => styles['dates'], :height => height_cell
        else
          sheet.add_row data, :style => styles['basic'], :height => height_cell
        end
      end
      add_rows_report(sheet, 1)
      sheet.add_row ["", "Comentario"], :style => 3
      add_rows_report(sheet, 1)
      sheet.add_row ["", comments.table]
    end

    def header(sheet, y_axis, width = 934)
      image_header = File.expand_path(Rails.root.join("public/assets/images/header.jpg"), __FILE__)
      sheet.add_image(:image_src => image_header) do |image|
        image.height = 87
        image.width = width
        image.start_at 1, y_axis
      end
    end

    def footer(sheet, y_axis, width = 934)
      image_header = File.expand_path(Rails.root.join("public/assets/images/footer.gif"), __FILE__)
      sheet.add_image(:image_src => image_header) do |image|
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

  end

  def self.all
    [FacebookReport, 
      MonitoringReport,
      BlogReport,
      FlickrReport,
      FoursquareReport,
      GooglePlusReport,
      LinkedinReport,
      PinterestReport,
      TuentiReport,
      TumblrReport,
      TwitterReport,
      YoutubeReport,
      BenchmarkReport,
      CampaignReport
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
