class TwitterDatum < ActiveRecord::Base
	belongs_to :client
	def self.get_followers_growth(datum)
		diff_followers = esCero(datum.total_followers-datum.new_followers)
		(datum.new_followers.to_f/diff_followers.to_f)*100
	end

	def self.get_diff_mentions(datum)
		if datum.id == all.first.id
			nil
		else
			prevDataMentions = TwitterDatum.where('id < ?',datum.id).first.total_mentions
			if prevDataMentions == 0
				100.0
			else
				totalMentions = esCero(datum.total_mentions)
				((datum.total_mentions-prevDataMentions).to_f/totalMentions.to_f)*100
			end
		end
	end

	def esCero(valor)
		if valor == 0 
			return 1
		end
		return valor
	end

	def self.get_diff_retweets(datum)
		if datum.id == all.first.id
			nil
		else
			prevDataRetweets = TwitterDatum.where('id < ?',datum.id).first.total_mentions
		end
	end

	def self.get_diff_clicks(datum)
		1
	end

	def self.get_diff_total_iteractions()
		1
	end
end
