class Client < ActiveRecord::Base
  has_many :social_networks, :dependent => :destroy
  has_many :facebook_data, :dependent => :destroy
  has_many :twitter_data, :dependent => :destroy
  has_many :users, :dependent => :destroy
  has_many :linkedin_data, :dependet => :destroy

end
