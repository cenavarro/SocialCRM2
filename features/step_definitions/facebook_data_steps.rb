# encoding: utf-8

Given /^a client named "(.*?)"$/ do |client_name|
	Client.create!(:name => client_name, :description => "test", :image => "logo.png")
end

Given /^a Facebook datum for client "(.*?)" with the following stats:$/ do |client_name, table|
	client = Client.find_by_name(client_name)

	facebook_datum = FacebookDatum.new

	attributes = table.hashes.first
	facebook_datum.start_date = Date.strptime(attributes['start_date'], '%m/%d/%Y')
	facebook_datum.end_date = Date.strptime(attributes['end_date'], '%m/%d/%Y')
	facebook_datum.new_fans = attributes['new_fans'].to_i
	facebook_datum.client_id = client.id
	facebook_datum.save!
end

When /^I find Facebook datum for "(.*?)" between "(.*?)" and "(.*?)"$/ do |client_name, start_date, end_date|
	client = Client.find_by_name(client_name)
	results = Facebook::Query.find(client.id, start_date, end_date)
	@facebook_view = Facebook::Presenter.new(results)
end

Then /^I should have the following information:$/ do |table|
	expected = table.hashes.first
	expected['new_fans'].should eq(@facebook_view[:new_fans])
end

When /^I visit the facebook data page of the client "([^\"]*)"$/ do |client|
  visit(path_facebook_data_client(client))
end

When /^I visit the new facebook data page of client "([^\"]*)"$/ do |client|
  visit(path_new_facebook_data_manually(client))
end

Given /^Exist Facebook Data of Client named "([^\"]*)"$/ do |client|
  facebook_datum = FacebookDatum.new
  facebook_datum.client_id = Client.find_by_name(client).id
  facebook_datum.actions = "Actions Test Client 1"
  facebook_datum.new_fans = 10
  facebook_datum.total_fans = 10
  facebook_datum.goal_fans = 10
  facebook_datum.prints = 10
  facebook_datum.total_interactions = 10
  facebook_datum.total_reach = 10
  facebook_datum.potential_reach = 10
  facebook_datum.total_prints_per_anno = 10
  facebook_datum.total_prints = 10
  facebook_datum.total_clicks_anno = 10
  facebook_datum.fans_through_anno = 10
  facebook_datum.agency_investment = 10.5
  facebook_datum.start_date = "2012/08/01".to_date
  facebook_datum.end_date = "2012/08/15".to_date
  facebook_datum.new_stock_investment = 10.5
  facebook_datum.anno_investment = 10.5
  facebook_datum.ctr_anno = 10.5
  facebook_datum.cpm_anno = 10.5
  facebook_datum.cpc_anno = 10.5
  facebook_datum.save!

  facebook_datum = FacebookDatum.new
  facebook_datum.client_id = Client.find_by_name(client).id
  facebook_datum.actions = "Actions 2 Test Client 1"
  facebook_datum.new_fans = 20
  facebook_datum.total_fans = 20
  facebook_datum.goal_fans = 20
  facebook_datum.prints = 20
  facebook_datum.total_interactions = 20
  facebook_datum.total_reach = 20
  facebook_datum.potential_reach = 20
  facebook_datum.total_prints_per_anno = 20
  facebook_datum.total_prints = 20
  facebook_datum.total_clicks_anno = 20
  facebook_datum.fans_through_anno = 20
  facebook_datum.agency_investment = 20.5
  facebook_datum.start_date = "2012/08/16".to_date
  facebook_datum.end_date = "2012/08/30".to_date
  facebook_datum.new_stock_investment = 20.5
  facebook_datum.anno_investment = 20.5
  facebook_datum.ctr_anno = 20.5
  facebook_datum.cpm_anno = 20.5
  facebook_datum.cpc_anno = 20.5
  facebook_datum.save!
end