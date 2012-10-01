class Client < ActiveRecord::Base
  has_attached_file :attachment, :default_url => "/assets/images/missing.png"
  validate :attachment, :attachment_presence => true

  has_many :social_networks, :dependent => :destroy
  has_many :facebook_data, :dependent => :destroy
  has_many :twitter_data, :dependent => :destroy
  has_many :users, :dependent => :destroy
  has_many :linkedin_data, :dependent => :destroy


end
