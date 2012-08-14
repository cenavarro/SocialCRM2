
Feature: Sign in
  In order to get access to protected sections of the site
  A user
  Should be able to sign in

    @sign_up
    Scenario: User is not signed up
      Given I am not logged in
      And no user exists with an email of "user@test.com"
      When I go to the sign in page
      And I sign in as "user@test.com/please"
      Then I should see "Iniciar Sesion"
      And I go to the home page
      And I should be signed out

    @wrong_password
    Scenario: User enters wrong password
      Given I am not logged in
      And I am a user named "foo" with an email "user@test.com" and password "please" and rolID "1"
      When I go to the sign in page
      And I sign in as "user@test.com/wrongpassword"
      Then I should see "Ovidaste tu contraseña?"
      And I go to the home page
      And I should be signed out

    @sign_success
    Scenario: User signs in successfully with email
      Given I am on the sign in page
      And I should see "Iniciar Sesion"
      And I should see "Email"
      And I should see "Contraseña"
      When I sign in as "user2@test.com/please"
      Then I should be signed in
