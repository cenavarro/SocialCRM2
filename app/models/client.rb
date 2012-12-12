class Client < ActiveRecord::Base
  has_attached_file :attachment, :default_url => "/assets/images/missing.png"
  validate :attachment, :attachment_presence => true

  has_many :social_networks, :dependent => :destroy
  has_many :users, :dependent => :destroy

  def build_reports(date_range, social_network_id=nil)
    report = ::Axlsx::Package.new
    social_network_id ? (client_social_networks = social_networks.where("id = ?", social_network_id)) :
      client_social_networks = social_networks
    client_social_networks.map do |social_network|
      build_reporters_for(social_network, date_range)
    end.flatten.each do |reporter|
      reporter.add_to(report)
    end
    report
  end

  def build_reporters_for(social_network, date_range)
    social_network.data_types.map do |data_type|
      ReportGenerators.for(data_type).map do |generator|
        generator.new(social_network, date_range)
      end
    end.flatten
  end

end
