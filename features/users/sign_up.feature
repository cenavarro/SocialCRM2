Feature: Sign up
  In order to get access to protected sections of the site
  As a user
  I want to be able to sign up


    Background:
      Given I am not logged in
      And I am on the home page
      And I go to the sign up page

    @SignUpValid
    Scenario: User signs up with valid data
      And I fill in the following:
        | Nombre                  | Testy McUserton |
        | Email                 | user@test.com   |
        | Contraseña              | please          |
        | Confirmación de Contraseña | please          |
      And I select "Administrador" from "user_rol_id"
      And I press "Sign up"
      Then I should see "Pagina Principal"
      And I should see "Salir" 
      
    @SignUpInvalidEmail
    Scenario: User signs up with invalid email
      And I fill in the following:
        | Nombre                  | Testy McUserton |
        | Email                 | invalidemail    |
        | Contraseña              | please          |
        | Confirmación de Contraseña | please          |
      And I select "Administrador" from "user_rol_id"
      And I press "Sign up"
      Then I should see "Email is invalid"

    @SignUpInvalidPass
    Scenario: User signs up without password
      And I fill in the following:
        | Nombre                  | Testy McUserton |
        | Email                 | user@test.com   |
        | Contraseña              |                 |
        | Confirmación de Contraseña | please          |

      And I select "Administrador" from "user_rol_id"
      And I press "Sign up"
      Then I should see "Password can't be blank"

    @SignUpInvalidPassConfirm
    Scenario: User signs up without password confirmation
      And I fill in the following:
        | Nombre                  | Testy McUserton |
        | Email                 | user@test.com   |
        | Contraseña              | please          |
        | Confirmación de Contraseña |                 |
        
      And I select "Administrador" from "user_rol_id"
      And I press "Sign up"
      Then I should see "Password doesn't match confirmation"

    @SignUpMismatchPassConfirm
    Scenario: User signs up with mismatched password and confirmation
      And I fill in the following:
        | Nombre                  | Testy McUserton |
        | Email                 | user@test.com   |
        | Contraseña              | please          |
        | Confirmación de Contraseña | please1         |
      And I select "Administrador" from "user_rol_id"
      And I press "Sign up"
      Then I should see "Password doesn't match confirmation"

