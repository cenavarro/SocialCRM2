class InfoSocialNetwork < ActiveRecord::Base
  has_attached_file :attachment
  validate :attachment, :attachment_presence => true

  def self.get_name_social_network(id)
  	case id
  		when 1
  			@return = "facebook_data"
  		when 2
  			@return = "twitter_data"
      when 3
        @return = "linkedin_data"
  	end
  end
end
