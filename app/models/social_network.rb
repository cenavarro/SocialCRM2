class SocialNetwork < ActiveRecord::Base
  has_attached_file :image
  validate :image, :attachment_presence => true

  has_many :facebook_comment, :dependent => :destroy
  has_many :images_social_network, :dependent => :destroy
  has_many :twitter_comment, :dependent => :destroy

  attr_accessible :name, :client_id, :info_social_network_id, :id_object, :image

end
