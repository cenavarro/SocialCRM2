class InfoSocialNetwork < ActiveRecord::Base
  def self.get_name_social_network(id)
  	case id
  		when 1
  			@return = "facebook_data"
  		when 2
  			@return = "twitter_data"
      when 3
        @return = "tuenti_data"
  	end
  end
end
