#encoding: utf-8
module ReportGenerators
  class Base
    include ActionView::Helpers::NumberHelper
    include ApplicationHelper

    attr :social_network, :date_range, :worksheet, :workbook, :styles, :headers, :footers, :current_row, :workbook, :chart
    delegate :start_date, :end_date, :to => :date_range

    def initialize(social_network, date_range)
      @social_network = social_network
      @date_range = date_range
      @comments_history = HistoryComment.where(social_network_id: social_network.id)
    end

    def create_chart(position, title, chart_width = 6, height_chart = 14)
      @chart = (@worksheet.add_chart(Axlsx::Line3DChart, :start_at => [0, position], :end_at => [chart_width, position+height_chart], :title => title, :rotX => 0, :rotY => 0))
      @chart.catAxis.gridlines = false
      @chart.serAxis.delete = true
    end

    def add_serie(data, title, labels=default_labels, style = nil)
      @chart.add_series :data => data, :labels => labels, :title => title, :style => style
    end

    def default_labels
      @report_data['dates']
    end

    def append_images position
      append_rows (position - current_row)
      last_period_image = ImagesSocialNetwork.where(:social_network_id => social_network.id).order('start_date DESC').order('end_date DESC').first
      start_date_last_period = last_period_image.start_date if !last_period_image.nil?
      end_date_last_period = last_period_image.end_date if !last_period_image.nil?
      images = ImagesSocialNetwork.where('social_network_id = ? and start_date = ? and end_date = ?', social_network.id, start_date_last_period, end_date_last_period)
      images.each do |image|
        header current_row, 934
        append_rows 4
        append_row_with [image.title], @styles['title']
        append_rows 1
        img = File.expand_path(image.attachment.path, __FILE__)
        @worksheet.add_image(:image_src => img) do |sheet_image|
          sheet_image.width = 755 
          sheet_image.height = 333
          sheet_image.start_at 0, current_row
        end
        append_rows 14
        append_row_with ["Comentario"], @styles['title']
        append_rows 1
        append_row_with [image.comment]
        position = position + 32
        append_rows (position - current_row)
        footer (position - 1), 934
      end
    end

    def create_report_styles
      no_style = @workbook.styles.add_style()
      title_style = @workbook.styles.add_style(:b => true, :sz => 14, :font_name => "Calibri")
      header_style = @workbook.styles.add_style(:bg_color => "FF0000", :border => {:style => :thin, :color => "FFFF0000"}, :font_name => "Calibri")
      dates_style = @workbook.styles.add_style(:b => true, :bg_color => "000000", :fg_color => "FFFFFF", 
                                     :border => {:style => :thin, :color => "#FF000000"}, :sz => 9, :font_name => "Calibri")
      basic = {:border => {:style => :thin, :color => "#00000000"}, :sz => 11, :font_name => "Calibri", 
              :alignment => {:horizontal => :right, :vertical => :center}}
      basic_style = @workbook.styles.add_style(basic)
      euro_style = @workbook.styles.add_style(basic)
      percentage_style = @workbook.styles.add_style(basic)
      @styles = {"none" => no_style, "title"=> title_style, "header"=> header_style, "dates"=> dates_style, 
                 "basic"=> basic_style, "euro" => euro_style, "percent" => percentage_style}
    end

    def append_table spaces=2
      append_rows spaces
      @report_data.each do |key, data|
        if key.include?("header") || (key=="actions")
          append_row_with data, @styles['header']
        elsif key.include?("dates")
          append_row_with data, @styles['dates']
        elsif percentage_rows.include?(key)
          append_percetage_symbol(data)
          append_row_with data, @styles['percent']
          clear_symbols(data)
        elsif euro_rows.include?(key)
          append_euro_symbol(data)
          append_row_with data, @styles['euro']
          clear_symbols(data)
        else
          append_row_with data, @styles['basic']
        end
      end
      append_rows 1
      append_row_with ["Comentario del consultor"], @styles['title']
      append_rows 1
      append_row_with [history_comment_for(1).content] if !history_comment_for(1).nil?
    end

    def append_percetage_symbol data
      for i in (1..data.size-1) do
        data[i] = "#{data[i]} %"
      end
    end

    def append_euro_symbol data
      for i in (1..data.size-1) do
        data[i] = "#{data[i]} €"
      end
    end

    def clear_symbols data
      for i in (1..data.size-1) do
        data[i] = data[i].split(' ')[0]
      end
    end

    def header(y_axis, width = 820)
      image_header = File.expand_path(Rails.root.join("public/assets/images/header.jpg"), __FILE__)
      @worksheet.add_image(:image_src => image_header) do |image|
        image.height = 87
        image.width = width
        image.start_at 0, y_axis
      end
    end

    def footer(y_axis, width = 820)
      image_header = File.expand_path(Rails.root.join("public/assets/images/footer.gif"), __FILE__)
      @worksheet.add_image(:image_src => image_header) do |image|
        image.height = 22
        image.width = width
        image.start_at 0, y_axis
      end
    end

    def append_row_with data, style=nil, height=height_cell
      @worksheet.add_row data, :style => style, :height => height
      @current_row += 1
    end

    def append_rows rows
      (1..rows).each do
        append_row_with []
      end
    end

    def remove_table_legends
      @report_data.each do |key, data|
        data.shift
      end
    end

    def initialize_variables document
      @current_row = 0
      @workbook = document.workbook
      @workbook.sheet_by_name(social_network.name[0..30]).nil? ? name = social_network.name[0..30] : name = "#{social_network.name[0..25]}-#{Random.rand(1000)}"
      @worksheet = @workbook.add_worksheet(:name => name, :page_margins => margins, :page_setup => page_setup)
      create_report_styles
      set_headers_and_footers
      @report_data = select_report_data
    end

    def append_headers_and_footers width=821
      for i in (0..@headers.size-1)
        header(@headers[i], width)
        footer(@footers[i], width)
      end
    end

    def history_comment_for type
      @comments_history.where(comment_id: type).order("start_date DESC").order("end_date DESC").first
    end

    def append_comment_chart_for type
      append_row_with ["Comentario"], @styles['title']
      append_rows 1
      append_row_with (!history_comment_for(type).nil? ? [history_comment_for(type).content] : ["Sin comentarios"])
    end

    def change_comma_by_period_for array
      for i in (0...array.size)
        array[i] = array[i].gsub(/,/, ".")
      end
    end

    def margins
      {:left => 0.3, :top => 0, :right => 0, :bottom => 0}
    end

    def page_setup
      {:orientation => :landscape, :paper_size => 9}
    end

    def height_cell
      return 19
    end

    def columns_widths
      [31, 11, 11, 12, 11, 12, 11, 12]
    end

    def is_header_or_dates_row? key
      ['costs_header', 'community_header', 'visits_header', 'percentage_header', 
       'interactions_header', 'interactivity_header', 'investment_header', 'actions',
       'dates', 'campaign_header', 'fans_header', 'page_header', 'interaction_header'].include?(key)
    end

    def percentage_rows
      ['get_percentage_difference_from_previous_view_pages', 'get_percentage_difference_from_previous_unique_visits',
      'get_percentage_difference_from_previous_total_fans', 'get_percentage_difference_from_previous_total_reach', 
       'get_percentage_difference_from_previous_total_prints', 'get_percentage_difference_from_previous_total_interactions',
       'get_percentage_difference_from_previous_clients', 'get_percentage_difference_from_previous_likes',
       'get_percentage_difference_from_previous_total_unlocks', 'get_percentage_difference_from_previous_total_visits',
       'get_percentage_difference_from_previous_checkins', 'get_percentage_difference_from_previous_total_followers',
       'get_percentage_difference_from_previous_liked', 'get_percentage_difference_from_previous_repin',
       'get_percentage_difference_from_previous_comments', 'get_percentage_difference_from_previous_community_boards',
       'get_percentage_difference_from_previous_real_fans', 'get_percentage_difference_from_previous_total_mentions',
       'get_percentage_difference_from_previous_ret_tweets', 'get_percentage_difference_from_previous_total_clicks',
       'get_percentage_difference_from_previous_interactions_ads', 
       'inserted_player', 'mobile_devise', 'youtube_search', 'youtube_suggestion', 'youtube_page', 'external_web_site',
       'google_search', 'youtube_others', 'youtube_subscriptions',
       'ctr_anno', 'interest'
      ]
    end

    def euro_rows
      ['agency_investment', 'new_stock_investment', 'anno_investment', 'total_investment', 'cpm_anno',
       'investment_agency', 'investment_actions', 'investment_ads', 'investment_anno',
       'cpc_anno', 'cpm_general', 'coste_interactions', 'fan_cost', 'coste_fan', 'cost_fan',
       'cost_twitter_ads', 'cost_per_prints', 'cost_per_interaction', 'cost_follower']
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
