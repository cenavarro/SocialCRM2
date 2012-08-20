Feature: Social Networks Standards
  As a Admin User,
  I should be able to edit the information of social networks
  which the system manages

  Background: Admin User is logged in and configure previous data
    Given Exist a Admin User with data, name "admin" and email "admin@test.com" and password "adminadmin"
    And Exist a Social Network named "Facebook" and its description are "Red Social Facebook"
    And I am logged in as "admin@test.com/adminadmin"
    And I am on the home page

  @edit_info_social_network
  Scenario: Admin User edits static social network
    Given I should see "Editar Info Red Social"
    When I follow "Editar Info Red Social"
    Then I should see "Informacion Redes Sociales"
    And I should see "Facebook"
    When I follow "edit_info_1"
    And I should see "Editar Informacion Red Social"
    Then I fill in "info_social_network_description" with "Description Test"
    When I press "Guardar Cambios"
    Then I should see "La Informacion de la Red Social se actualizo correctamente."
    And I should see "Description Test"