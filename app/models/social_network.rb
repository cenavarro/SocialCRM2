class SocialNetwork < ActiveRecord::Base
  belongs_to :clients
  belongs_to :info_social_networks
  belongs_to :facebook_data
end
