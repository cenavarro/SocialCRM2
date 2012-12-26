class Comment < ActiveRecord::Base
  belongs_to :social_network
  has_many :list_comments, :dependent => :destroy
end
