#Given /^no campaign exists for client "(\d+)"$/ do |client|
#  FacebookDatum.find(:first, :conditions => { :client => client }).should be_nil
#end

#Given /^I am a user named "([^"]*)" with an email "([^"]*)" and password "([^"]*)"$/ do |name, email, password|
#  User.new(:name => name,
#            :email => email,
#            :password => password,
#            :password_confirmation => password).save!
#end

Given /^no campaign exist for client (\d+)$/ do |n|
  FacebookDatum.find(:first, :conditions => { :client_id => n}).should be_nil
end

When /^I go to 'facebook data page'$/ do |/facebook_data|
end

Then /^I should see new facebook datum$/ do
end