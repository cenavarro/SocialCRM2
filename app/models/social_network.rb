class SocialNetwork < ActiveRecord::Base
  has_many :facebook_comment, :dependent => :destroy
end
