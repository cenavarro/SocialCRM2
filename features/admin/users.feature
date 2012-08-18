Feature: Manage Users
  As a Admin User,
  I should be able to create/delete/edit users

  Background: Admin User is logged in
    Given Exist a Admin User with data, name "admin" and email "admin@test.com" and password "adminadmin"
    And I am logged in as "admin@test.com/adminadmin"
    And I am on the home page

  @new_user_admin_register
  Scenario: Register New Admin User
    When I follow "Nuevo Usuario"
    Then I should see "Nuevo Usuario Administrador"
    And I fill in the following:
      | Nombre:						           | Admin2		 	|
      | Email:						          | admin2@test.com 	|
      | Contraseña: 				        | 123456			|
      | Confirmación de Contraseña: | 123456 			|
    When I press "Crear Usuario"
    Then I should see "El Usuario se ha ingresado correctamente."

  @fail_user_admin_register
  Scenario: Register New Admin User
    When I follow "Nuevo Usuario"
    Then I should see "Nuevo Usuario Administrador"
    And I fill in the following:
      | Nombre:						          | admin2				 	  |
      | Email:						          | admin2@test.com 	|
      | Contraseña: 				        |       			      |
      | Confirmación de Contraseña: | 123456 			      |
    When I press "Crear Usuario"
    Then I should see "El Usuario NO se ha ingresado correctamente."

  @delete_user_admin
  Scenario: Delete an existing user
    Given Exist a Admin User with data, name "admin2" and email "admin2@test.com" and password "adminadmin"
    When I follow "Eliminar Usuarios"
    Then I should see "Eliminar Usuarios"
    And I select "admin2" from "id"
    Then I press "Eliminar"
    And I should see "El usuario se ha eliminado correctamente."