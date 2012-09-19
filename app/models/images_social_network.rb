class ImagesSocialNetwork < ActiveRecord::Base
  has_attached_file :attachment
  validates :attachment, :attachment_presence => true

  attr_accessible :title, :comment, :attachment, :social_network_id
end
