Feature: Manage Clients
  As a Admin User,
  I should be able to create/delete/edit social networks
  which the clients will be associated

  Background: Admin User is logged in and configure previous data
    Given Exist a Admin User with data, name "admin" and email "admin@test.com" and password "adminadmin"
    And Exist a Social Network named "Facebook" and its description is "Red Social Facebook"
    And Exist a Client User with data, name "Client1" with an email "client1@test.com" and password "clientpass"
    And I am logged in as "admin@test.com/adminadmin"
    And I am on the home page



  @add_social_network_to_client
  Scenario: Add new social network to client
    Given I should see "Agregar Red Social a Cliente"
    Then I follow "Agregar Red Social a Cliente"
    And I should be in Agregar Red Social page
    When I fill in the following:
      | social_network_name | Facebook Client 1 |
    And I select "Client1" from "social_network_client_id"
    And I select "Facebook" from "social_network_info_social_network_id"
    And I press "Guardar Cambios"
    Then I should see "La Red Social se creo satisfactoriamente."

  @delete_social_network_from_client
  Scenario: Remove social network from client
    Given Exist a Client named "Client1" with a Social Network named "Facebook Client 1" and associated to "Facebook"
    And I should see "Listar Redes Sociales"
    When I follow "Listar Redes Sociales"
    Then I should be in Lista Redes Sociales page
    And I should see "Client1"
    When I follow "delete_client_1"
    Then I should see "La Red Social fue eliminada correctamente."

  @edit_social_network_from_client
  Scenario: Edit social network from client
    Given Exist a Client named "Client1" with a Social Network named "Facebook Client 1" and associated to "Facebook"
    And I should see "Listar Redes Sociales"
    When I follow "Listar Redes Sociales"
    Then I should be in Lista Redes Sociales page
    And I should see "Client1"
    When I follow "edit_client_1"
    Then I should be in Editar Red Social page
    When I fill in "social_network_name" with "Facebook 2"
    And I press "Guardar Cambios"
    Then I should see "La Red Social se actualizo correctamente."
    And I should see "Facebook 2"
