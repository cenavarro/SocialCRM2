class TwitterDatum < ActiveRecord::Base
	belongs_to :client
	def self.get_followers_growth(datum)
		(datum.new_followers.to_f/(datum.total_followers-datum.new_followers).to_f)*100
	end

	def self.get_diff_mentions(datum)
		if datum.id == all.first.id
			nil
		else
			prevDataMentions = TwitterDatum.where('id < ?',datum.id).first.total_mentions
			if prevDataMentions == 0
				100.0
			else
				((datum.total_mentions-prevDataMentions).to_f/datum.total_mentions.to_f)*100
			end
		end
	end

	def self.get_diff_rettweets(datum)
		if datum.id == all.first.id
			0
		else
			prevDataMentions = TwitterDatum.where('id < ?',datum.id).first.total_mentions
		end
	end

	def self.get_diff_clicks(datum)
		1
	end

	def self.get_diff_total_iteractions()
		1
	end
end
