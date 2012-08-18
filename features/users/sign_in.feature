
Feature: Sign in and Sing out
  In order to get access to protected sections of the site
  A user
  Should be able to sign in

    @sign_in_wrong
    Scenario: User enters wrong password
      Given I am not logged in
      And Exist a User with data, name "user" with an email "user@test.com" and password "password"
      When I go to the sign in page
      And I sign in as "user2@test.com/wrongpassword"
      Then I should see "Email o Contraseña no son correctos."
