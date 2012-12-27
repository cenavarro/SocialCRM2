class ReportGenerators::CommentReport < ReportGenerators::Base

  def self.can_process? type
    type == Comment
  end

  def comments
    social_network.comments
  end

  def add_to(document)
    if !comments.empty?
      sets_workbook_and_worksheet(document)
      create_report
      append_header(0)
    end
  end

  def create_report
    create_report_styles_for_comment
    append_rows_to_report 7
    @worksheet.add_row ["", "COMENTARIOS"], :style => 3
    append_comments_to_report
    @worksheet.column_widths 4, 90, 30, 10, 10, 10, 10, 10

  end

  def append_comments_to_report
    append_rows_to_report 2
    append_positive_comments
    append_negative_comments
  end

  def append_positive_comments
    @worksheet.add_row ["", "Comentarios positivos", "Link al comentario"], :style => [nil, @positive_title_style, @positive_title_style], :height => height_cell
    positive_comments = comments.where("comment_type = 1")
    positive_comments.each do |positive_comment|
      @worksheet.add_row ["", positive_comment.social_network_name, ""], :style => [nil, @positive_subtitle_style, @positive_subtitle_style], :height => height_cell
      positive_comment.list_comments.each do |comment|
        @worksheet.add_row ["", comment.content, comment.link], :style => [nil, @basic_style, @basic_style], :height => height_cell
      end
    end
  end

  def append_negative_comments
    @worksheet.add_row ["", "Comentarios negativos", "Link al comentario"], :style => [nil, @negative_title_style, @negative_title_style], :height => height_cell
    negative_comments = comments.where("comment_type = 2")
    negative_comments.each do |negative_comment|
      @worksheet.add_row ["", negative_comment.social_network_name, ""], :style => [nil, @negative_subtitle_style, @negative_subtitle_style], :height => height_cell
      negative_comment.list_comments.each do |comment|
        @worksheet.add_row ["", comment.content, comment.link], :style => [nil, @basic_style, @basic_style], :height => height_cell
      end
    end
  end

  def create_report_styles_for_comment
    @positive_title_style = @workbook.styles.add_style(:b => true, :sz => 14, :font_name => "Calibri", :border => {:style => :thin, :color => "#00000000"}, :bg_color => "4FD15A", :fg_color => "FFFFFF")
    @positive_subtitle_style = @workbook.styles.add_style(:sz => 14, :font_name => "Calibri", :border => {:style => :thin, :color => "#00000000"}, :bg_color => "3AF249")
    @negative_title_style = @workbook.styles.add_style(:b => true, :sz => 14, :font_name => "Calibri", :border => {:style => :thin, :color => "#00000000"}, :bg_color => "F52A2A", :fg_color => "FFFFFF")
    @negative_subtitle_style = @workbook.styles.add_style(:sz => 14, :font_name => "Calibri", :border => {:style => :thin, :color => "#00000000"}, :bg_color => "FCA2A2")
    @basic_style = @workbook.styles.add_style(:border => {:style => :thin, :color => "#00000000"})
  end

  def sets_workbook_and_worksheet(document)
    @workbook = document.workbook
    @worksheet = @workbook.add_worksheet(:name => social_network.name, :page_margins => margins, :page_setup => { :orientation => :landscape, :paper_size => 9, :fit_to_width => 1, :fit_to_height => 10})
  end

  def append_header(y_axis, width = 1100)
    image_header = File.expand_path(Rails.root.join("public/assets/images/header.jpg"), __FILE__)
    @worksheet.add_image(:image_src => image_header) do |image|
      image.height = 87
      image.width = width
      image.start_at 1, y_axis
    end
  end
end
