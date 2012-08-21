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