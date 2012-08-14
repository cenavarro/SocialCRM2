Feature: Sign out
  To protect my account from unauthorized access
  A signed in user
  Should be able to sign out

    @userSignOut
    Scenario: User signs out
      Given I am a user named "foo" with an email "user@test.com" and password "please" and rolID "1"
      And I go to the sign in page
      When I sign in as "user@test.com/please"
      And I sign out
      Then I should see "Iniciar Sesion"
      When I return next time
      Then I should be signed out
