class InfoSocialNetwork < ActiveRecord::Base
  has_attached_file :attachment, :default_url => "/assets/images/missing.png"
  validate :attachment, :attachment_presence => true

  def self.get_name_social_network(id)
    id_name = InfoSocialNetwork.find(id).id_name
    return "#{id_name}_data"
  end
end
