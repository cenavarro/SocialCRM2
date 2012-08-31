# encoding: utf-8

When /^I visit the twitter data page of the client "([^\"]*)"$/ do |client|
  visit(path_twitter_data_client(client))
end

When /^I visit the new twitter data page of client "([^\"]*)"$/ do |client|
  visit(path_new_twitter_data_manually(client))
end

Given /^Exist Twitter Data of Client named "([^\"]*)"$/ do |client|
  twitter_datum = TwitterDatum.new
  twitter_datum.client_id = Client.find_by_name(client).id
  twitter_datum.global_goal = "Objetivo Followers Text"
  twitter_datum.new_followers = 10
  twitter_datum.total_followers = 10
  twitter_datum.goal_followers = 10
  twitter_datum.amount_tweets = 10
  twitter_datum.total_tweets = 10
  twitter_datum.total_mentions = 10
  twitter_datum.ret_tweets = 10
  twitter_datum.total_clicks = 10
  twitter_datum.total_interactions = 10
  twitter_datum.agency_investment = 10.5
  twitter_datum.cost_follower = 0.1
  twitter_datum.start_date = "2012/08/01".to_date
  twitter_datum.end_date = "2012/08/15".to_date
  twitter_datum.save!

  twitter_datum = TwitterDatum.new
  twitter_datum.client_id = Client.find_by_name(client).id
  twitter_datum.global_goal = "Objetivo Followers Text 2"
  twitter_datum.new_followers = 20
  twitter_datum.total_followers = 20
  twitter_datum.goal_followers = 20
  twitter_datum.amount_tweets = 20
  twitter_datum.total_tweets = 20
  twitter_datum.total_mentions = 20
  twitter_datum.ret_tweets = 20
  twitter_datum.total_clicks = 20
  twitter_datum.total_interactions = 20
  twitter_datum.agency_investment = 20.5
  twitter_datum.cost_follower = 0.2
  twitter_datum.start_date = "2012/08/16".to_date
  twitter_datum.end_date = "2012/08/30".to_date
  twitter_datum.save!
end