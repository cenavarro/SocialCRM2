class ImagesSocialNetwork < ActiveRecord::Base
  belongs_to :social_network
  has_attached_file :attachment
  validates :attachment, :attachment_presence => true

  before_post_process :rename_attachment

  attr_accessible :title, :comment, :attachment, :social_network_id


  def rename_attachment
    name_of_file = File.basename(attachment_file_name).downcase
    self.attachment.instance_write :file_name, "#{name_of_file}"
  end
end
