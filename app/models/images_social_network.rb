class ImagesSocialNetwork < ActiveRecord::Base
  belongs_to :social_network
  has_attached_file :attachment
  validates :attachment, :attachment_presence => true

  attr_accessible :title, :comment, :attachment, :social_network_id
end
