class TwitterDatum < ActiveRecord::Base
	belongs_to :client
	def self.get_followers_growth(datum)
		diff_followers = isZero(datum.total_followers-datum.new_followers)
		(datum.new_followers.to_f/diff_followers.to_f)*100
	end

	def self.get_diff_mentions(datum)
		if !isFirstData?(datum)
			return getPercentDiffMentions(datum)
		end
		return nil
	end

	def self.getPercentDiffMentions(datum)
		prevDataMentions = TwitterDatum.where('id < ?',datum.id).last.total_mentions
		if prevDataMentions != 0
			return ((datum.total_mentions-prevDataMentions).to_f/prevDataMentions.to_f)*100		
		end
		return 100.0
	end

	def self.get_diff_retweets(datum)
		if !isFirstData?(datum)
			return getPercentDiffRetweets(datum)
		end
		return nil
	end

	def self.getPercentDiffRetweets(datum)
		prevDataRetweets = TwitterDatum.where('id < ?',datum.id).last.ret_tweets
		if prevDataRetweets != 0
		  return ((datum.ret_tweets-prevDataRetweets).to_f/prevDataRetweets.to_f)*100
		end
		return 100.0
	end

	def self.get_diff_clicks(datum)
		if !isFirstData?(datum)
			return getPercentDiffClicks(datum)
		end
		return nil
	end

	def self.getPercentDiffClicks(datum)
		prevDataClicks = TwitterDatum.where('id < ?',datum.id).last.total_clicks
		if prevDataClicks != 0
		  return ((datum.total_clicks-prevDataClicks).to_f/prevDataClicks.to_f)*100
		end
		return 100.0
	end

	def self.get_diff_total_iteractions(datum)
		if !isFirstData?(datum)
			return getPercentDiffIte(datum)
		end
		return nil
	end

	def self.getPercentDiffIte(datum)
		prevDataIterations = TwitterDatum.where('id < ?',datum.id).last.total_interactions
		if prevDataIterations != 0
		  return ((datum.total_interactions-prevDataIterations).to_f/prevDataIterations.to_f)*100
		end
		return 100.0
	end

	def self.isFirstData?(datum)
		if(datum.id == all.first.id)
			return true
		end
		return false
	end

	def self.isZero(value)
		if value == 0 
			return 1
		end
		return value
	end

	def self.get_cost_follower(datum)
		if datum.new_followers != 0
			return (datum.agency_investment.to_f/datum.new_followers.to_f) 
		end
		return 0
	end

end
