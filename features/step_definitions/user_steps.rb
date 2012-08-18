# encoding: utf-8

Given /^no user exists with an email of "(.*)"$/ do |email|
  User.find(:first, :conditions => { :email => email }).should be_nil
end

Given /^Exist a Admin User with data, name "([^\"]*)" and email "([^\"]*)" and password "([^\"]*)"$/ do |name, email, password|
  User.new(:name => name,
    :email => email,
    :password => password,
    :rol_id => 1,
    :password_confirmation => password).save!
end

Given /^Exist a User with data, name "([^\"]*)" with an email "([^\"]*)" and password "([^\"]*)"$/ do |name, email, password|
  User.new(:name => name,
    :email => email,
    :password => password,
    :rol_id => 2,
    :password_confirmation => password).save!
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
