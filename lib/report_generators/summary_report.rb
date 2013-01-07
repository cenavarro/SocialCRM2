class ReportGenerators::SummaryReport < ReportGenerators::Base

  def self.can_process? type
    type == Summary
  end

  def add_to(document)
    if summary_has_data?
      start_date_comments = summary.summary_comments.order("start_date DESC").order('end_date DESC').first.start_date
      end_date_comments = summary.summary_comments.order("start_date DESC").order('end_date DESC').first.end_date
      @summary_comments = summary.summary_comments.where("start_date = ? and end_date = ?", start_date_comments, end_date_comments)
      sets_workbook_and_worksheet(document)
      create_report
      append_header(0)
    end
  end

  private

  def summary
    social_network.summaries.first
  end

  def summary_has_data?
    !summary.nil? && !summary.summary_comments.empty?
  end

  def sets_workbook_and_worksheet(document)
    @workbook = document.workbook
    @workbook.sheet_by_name(social_network.name[0..30]).nil? ? name = social_network.name[0..30] : name = "#{social_network.name[0..25]}-#{Random.rand(1000)}"
    @worksheet = @workbook.add_worksheet(:name => name, :page_margins => margins, :page_setup => { :orientation => :landscape, :paper_size => 9, :fit_to_width => 1, :fit_to_height => 10})
  end

  def create_report
    create_report_styles_for_summary
    append_rows_to_report 7
    @worksheet.add_row ["", "PAGINA DE REPORTE"], :style => 3
    add_summary_comments_to_report
    @worksheet.column_widths 4, 10, 10, 10, 10, 10, 10, 10
  end

  def add_summary_comments_to_report
    append_rows_to_report 2
    @summary_comments.each do |comment|
      @worksheet. add_row ["", comment.title], :style => 3
      append_rows_to_report 1
      comment.content.split(/\n/).each do |substring|
        @worksheet. add_row ["", substring[0..130]]
      end
      append_rows_to_report 2
    end
  end

  def create_report_styles_for_summary
    @workbook.styles.add_style(:b => true, :sz => 14, :font_name => "Calibri")
    @workbook.styles.add_style(:sz => 12, :font_name => "Calibri")
  end

  def append_header(y_axis, width = 934)
    image_header = File.expand_path(Rails.root.join("public/assets/images/header.jpg"), __FILE__)
    @worksheet.add_image(:image_src => image_header) do |image|
      image.height = 87
      image.width = width
      image.start_at 1, y_axis
    end
  end

end
