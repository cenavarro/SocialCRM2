Feature: Sign in/out
  In order to get access with Administrative privileges and also sign out
  A admin user
  Should be able to sign in/out

    Background: Admin User registered
      Given Exist a Admin User with data, name "admin" and email "admin@test.com" and password "adminadmin"

  	@admin_invalid_sing_in
  	Scenario: Admin user enter invalid data.
  	  When I sign in as "admin@test.com/badpassword"
  	  Then I should see "Email o Contraseña no son correctos."


    @admin_sign_in_success
    Scenario: Admin user sign in successfully.
      Given I am not logged in
      When I go to the sign in page
      And I sign in as "admin@test.com/adminadmin"
      Then I should be logged in as an Admin User

    @admin_sign_out_success
    Scenario: Admin user sign out successfully.
      Given I am logged in as "admin@test.com/adminadmin"
      When I go to the home page
      Then I should see "Salir"
      When I follow "Salir"
      Then I should see "Se ha cerrado la sesión correctamente"
      And I should be logged out

