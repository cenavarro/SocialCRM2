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


  @edit_client
  Scenario: Edit Information of a exist client
    Given I should see "Editar/Borrar"
    And Exist a Client User with data, name "Client1" with an email "client1@test.com" and password "123456"
    When I follow "Editar/Borrar"
    Then I should see "Listado de Clientes"
    And I should see "Client1"
    When I follow "edit_1"
    Then I should see "Editar Cliente"
    And I fill in "client_description" with "Description Client 1"
    And I press "Guardar Cambios"
    Then I should see "El Cliente fue actualizado correctamente."
    And I should see "Description Client 1"
  
  @delete_client
  Scenario: Delete client
    Given I should see "Editar/Borrar"
    And Exist a Client User with data, name "Client1" with an email "client1@test.com" and password "123456"
    When I follow "Editar/Borrar"
    Then I should see "Listado de Clientes"
    And I should see "Client1"
    When I follow "delete_1"
    Then I should see "Cliente se elimino correctamente."

  @list_socialNetworks
  Scenario: Show social networks
    Given Exist a Client User with data, name "Client1" with an email "client1@test.com" and password "123456"
    And Exist a Social Network named "Facebook" and its description is "Facebook Description"
    And Exist a Client named "Client1" with a Social Network named "Facebook Client 1" and associated to "Facebook"
    When I visit the list page of social networks of the client "Client1"
    Then I should see "Anterior"
    And I should see "Siguiente"
    When I visit the facebook data page of the client "Client1"
    Then I should see "Facebook Client 1"