Feature: Manage Clients
  As a Admin User,
  I should be able to create/delete/edit clients

  Background: Admin User is logged in
    Given Exist a Admin User with data, name "admin" and email "admin@test.com" and password "adminadmin"
    And I am logged in as "admin@test.com/adminadmin"
    And I am on the home page


  @new_client_register
  Scenario: Register New Client
    When I follow "Crear Cliente"
    Then I should see "Nuevo Cliente"
    And I fill in the following:
      | Nombre:						| Client1 			|
      | Email:						| client@test.com 	|
      | Contraseña: 				| 123456			|
      | Confirmación de Contraseña: | 123456 			|
      | Descripcion Cliente:		| Client Description|
      | Imagen Cliente:				| image.png			|
    When I press "Crear Cliente"
    Then I should see "El Cliente se ha ingresado correctamente."

  @fail_register_client_no_name
  Scenario: Register Client fails(no name)
    When I follow "Crear Cliente"
    Then I should see "Nuevo Cliente"
    And I fill in the following:
      | Nombre:						| 		 			|
      | Email:						| client@test.com 	|
      | Contraseña: 				| 123456			|
      | Confirmación de Contraseña: | 123456 			|
      | Descripcion Cliente:		| Client Description|
      | Imagen Cliente:				| image.png			|
    When I press "Crear Cliente"
    Then I should see "El Cliente NO se pudo ingresar correctamente."

  @fail_register_client_no_password
  Scenario: Register Client fails(no email)
    When I follow "Crear Cliente"
    Then I should see "Nuevo Cliente"
    And I fill in the following:
      | Nombre:						| Client		 	|
      | Email:						|  					|
      | Contraseña: 				| 123456			|
      | Confirmación de Contraseña: | 123456 			|
      | Descripcion Cliente:		| Client Description|
      | Imagen Cliente:				| image.png			|
    When I press "Crear Cliente"
    Then I should see "El Cliente NO se ha ingresado correctamente."