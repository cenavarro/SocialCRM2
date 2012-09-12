class ImagesSocialNetwork < ActiveRecord::Base
  has_attached_file :attachment
  validates :attachment, :attachment_presence => true
end
