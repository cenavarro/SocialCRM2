class InfoSocialNetwork < ActiveRecord::Base
  has_attached_file :attachment
  validate :attachment, :attachment_presence => true

  def self.get_name_social_network(id)
    id_name = InfoSocialNetwork.find(id).id_name
  	case id_name
  		when 'facebook'
  			return  "facebook_data"
  		when 'twitter'
  			return  "twitter_data"
      when 'linkedin'
        return  "linkedin_data"
      when 'pinterest'
        return "pinterest_data"
  	end
  end
end
