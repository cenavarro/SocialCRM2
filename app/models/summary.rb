class Summary < ActiveRecord::Base
  belongs_to :social_network
  has_many :summary_comments
end
