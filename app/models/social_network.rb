class SocialNetwork < ActiveRecord::Base
  has_many :facebook_comment, :dependent => :destroy
  has_many :images_social_network, :dependent => :destroy
  has_many :twitter_comment, :dependent => :destroy
end
