class Client < ActiveRecord::Base
  has_attached_file :attachment, :default_url => "/assets/images/missing.png"
  validate :attachment, :attachment_presence => true

  has_many :social_networks, :dependent => :destroy
  has_one :user, :dependent => :destroy
  accepts_nested_attributes_for :user, :allow_destroy => true

  def build_reports(date_range, social_networks_ids=[])
    report = ::Axlsx::Package.new
    client_social_networks = sorter_social_networks(social_networks_ids)
    client_social_networks.map do |social_network|
      build_reporters_for(social_network, date_range)
    end.flatten.each do |reporter|
      reporter.add_to(report)
    end
    add_front_page(report, date_range)
    add_cover_page(report)
    report
  end

  def build_reporters_for(social_network, date_range)
    social_network.data_types.map do |data_type|
      ReportGenerators.for(data_type).map do |generator|
        generator.new(social_network, date_range)
      end
    end.flatten
  end

  def sorter_social_networks social_networks_ids
    sorter_social_networks = []
    order_social_networks.each do |id|
      sorter_social_networks.concat(social_networks.where('id in (?) and info_social_network_id = ?',social_networks_ids, id))
    end
    sorter_social_networks
  end

  def order_social_networks
    [1, 2, 3, 9, 6, 5, 12, 4, 8, 7, 10, 13, 14, 11, 16, 15]
  end

  def add_front_page(report, date_range)
    @workbook = report.workbook
    @worksheet = @workbook.insert_worksheet(0, {:name => "Portada", :page_margins => {:left => 0, :top => 0, :right => 0, :bottom => 0}, :page_setup => {:orientation => :landscape, :paper_size => 9}})
    if attachment.file?
      logo_customer = File.expand_path(Rails.root.join("#{attachment.path}"), __FILE__)
    else
      logo_customer = File.expand_path(Rails.root.join("public/assets/images/missing.png"), __FILE__)
    end
    p logo_customer
    logo_hydra_social = File.expand_path(Rails.root.join("public/assets/images/logoHydra.png"),__FILE__)
    @title_style = @workbook.styles.add_style(:b => true, :sz => 24, :font_name => "Calibri")
    @subtitle_style = @workbook.styles.add_style(:b => true, :sz => 16, :font_name => "Calibri")
    @date_style = @workbook.styles.add_style(:b => true, :font_name => "Calibri")
    for i in (1..5) do
      @worksheet.add_row
    end
    @worksheet.add_row
    @worksheet.add_row ["","","","Reporte Mensual Social Media"], :style => @title_style
    @worksheet.add_row
    @worksheet.add_row ["","","",""," Cliente: #{name}"], :style => @subtitle_style
    @worksheet.add_row
    @worksheet.add_row ["","","","","Periodo del : #{date_range.start_date} al #{date_range.end_date}"], :style => @date_style
    @worksheet.add_image(:image_src => logo_hydra_social) do |image|
      image.width = 272
      image.height = 114
      image.start_at 7, 14
    end
    @worksheet.add_image(:image_src => logo_customer) do |image|
      image.width = 272
      image.height = 181
      image.start_at 2, 14
    end
    @worksheet.column_widths 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9
  end

  def add_cover_page(report)
    @workbook = report.workbook
    @worksheet = @workbook.insert_worksheet(@workbook.worksheets.size, {:name => "Contraportada", :page_margins => {:left => 0, :top => 0, :right => 0, :bottom => 0}, :page_setup => {:orientation => :landscape, :paper_size => 9}})
    if attachment.file?
      logo_customer = File.expand_path(Rails.root.join("#{attachment.path}"), __FILE__)
    else
      logo_customer = File.expand_path(Rails.root.join("public/assets/images/missing.png"), __FILE__)
    end
    logo_hydra_social = File.expand_path(Rails.root.join("public/assets/images/logoHydra.png"),__FILE__)
    @title_style = @workbook.styles.add_style(:b => true, :sz => 24, :font_name => "Calibri")
    @subtitle_1_style = @workbook.styles.add_style(:b => true, :sz =>  20, :font_name => "Calibri")
    @subtitle_2_style = @workbook.styles.add_style(:b => true, :sz => 16, :font_name => "Calibri")
    @date_style = @workbook.styles.add_style(:b => true, :font_name => "Calibri")
    for i in (1..5) do
      @worksheet.add_row
    end
    @worksheet.add_row ["","", "Reporte preparado por "], :style => @title_style
    @worksheet.add_row
    @worksheet.add_row ["","","","Social Media Manager"], :style => @subtitle_1_style
    @worksheet.add_row
    @worksheet.add_row ["","",""," Cliente: #{name}"], :style => @subtitle_2_style
    @worksheet.add_image(:image_src => logo_hydra_social) do |image|
      image.width = 272
      image.height = 114
      image.start_at 6, 14
    end
    @worksheet.add_image(:image_src => logo_customer) do |image|
      image.width = 272
      image.height = 181
      image.start_at 1, 14
    end
    @worksheet.column_widths 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9
  end

end
