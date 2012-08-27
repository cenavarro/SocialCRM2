# encoding: utf-8
Given /^Exist a Admin User with data, name "([^\"]*)" and email "([^\"]*)" and password "([^\"]*)"$/ do |name, email, password|
  User.new(:name => name,
    :email => email,
    :password => password,
    :rol_id => 1,
    :password_confirmation => password).save!
end

Given /^Exist a Client User with data, name "([^\"]*)" with an email "([^\"]*)" and password "([^\"]*)"$/ do |name, email, password|
  u = User.new
  u.name = name
  u.email = email
  u.password = password
  u.rol_id = 2
  u.password_confirmation = password
  u.save!
  c = Client.new
  c.name = name
  c.description = "description"
  c.image = "image.png"
  c.save!
  u.client_id = c.id
  u.save!
end

Given /^Exist a Social Network named "([^\"]*)" and its description is "([^\"]*)"$/ do |name, description|
  InfoSocialNetwork.new(:name => name, :description => description, :image=> "image.png").save!
end

Given /^Exist a Client named "([^\"]*)" with a Social Network named "([^\"]*)" and associated to "([^\"]*)"$/ do |client_name, social_network_name,social_network|
  social_id = InfoSocialNetwork.find_by_name(social_network.to_s).id
  client_id = Client.find_by_name(client_name.to_s).id
  SocialNetwork.new(:name => social_network_name, :client_id => client_id.to_i, :info_social_network_id => social_id.to_i).save!
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

Then /^I should be already signed in$/ do
  step 'I should see "Salir"'
end

Given /^I am logged in as "(.*)\/(.*)"$/ do |email, password|
  step %{I sign in as "#{email}/#{password}"}
end

Then /^I sign out$/ do
  visit('/users/sign_out')
end

Given /^I am logout$/ do
  step "I sign out"
end

Given /^I am not logged in$/ do
  step "I sign out"
end

When /^I sign in as "(.*)\/(.*)"$/ do |email, password|
  step 'I go to the sign in page'
  step %{I fill in "Email" with "#{email}"}
  step %{I fill in "user_password" with "#{password}"}
  step 'I press "Iniciar Sesion"'
end

Then /^I should be signed in$/ do
  step 'I go to the home page'
  step 'I should see "Salir"'
end

When /^I return next time$/ do
  step 'I go to the home page'
end

Then /^I should be logged out$/ do
  step 'I should see "Email"'
  step 'I should see "Contraseña"'
  step 'I should see "Iniciar Sesion"'
  step 'I should not see "Salir"'
end

Then /^I should be logged in as an Admin User$/ do
  step 'I should see "Home"'
  step 'I should see "Clientes"'
  step 'I should see "Redes Sociales"'
  step 'I should see "Salir"'
end

Then /^I should be in Agregar Red Social page$/ do
  step 'I should see "Asociar Red Social"'
  step 'I should see "Nombre(id)"'
  step 'I should see "Cliente"'
end

Then /^I should be in Lista Redes Sociales page$/ do
  step 'I should see "Redes Sociales"'
  step 'I should see "Nombre"'
  step 'I should see "Cliente"'
  step 'I should see "Red Social Asociada"'
end

Then /^I should be in Editar Red Social page$/ do
  step 'I should see "Editar Red Social"'
  step 'I should see "Nombre(id)"'
  step 'I should see "Cliente"'
  step 'I should see "Red social"'
end

Then /^I should be in Home Page$/ do
  step 'I should see "Pagina Principal"'
end

When /^I visit the list page of social networks of the client "([^\"]*)"$/ do |client|
  visit(path_list_socialNetworks(client))
end

When /^I visit the facebook data page of the client "([^\"]*)"$/ do |client|
  visit(path_facebook_data_client(client))
end

When /^I visit the twitter data page of the client "([^\"]*)"$/ do |client|
  visit(path_twitter_data_client(client))
end

When /^I visit the new twitter data page of client "([^\"]*)"$/ do |client|
  visit(path_new_twitter_data_manually(client))
end