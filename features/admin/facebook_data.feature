Feature: Manage Facebook Data
  As a Admin User,
  I should be able to manage Facebook Data of a client

  Background: I am on the Facebook Data Page of a client named Client1
    Given Exist a Admin User with data, name "admin" and email "admin@test.com" and password "adminadmin"
    And I am logged in as "admin@test.com/adminadmin"
    And Exist a Client User with data, name "Client1" with an email "client1@test.com" and password "123456"
    And Exist a Social Network named "Facebook" and its description is "Facebook Description"
    And Exist a Social Network named "Twitter" and its description is "Twitter Description"
    And Exist a Client named "Client1" with a Social Network named "Facebook Client 1" and associated to "Facebook"

  @new_facebook_data_success
  Scenario: Add New Facebook Data
    When I visit the new facebook data page of client "Client1"
    Then I should see "Nueva Entrada Datos Facebook"
    When I fill in the following:
      | facebook_datum_actions | acciones test |
      | facebook_datum_new_fans | 10|
      | facebook_datum_goal_fans | 10 |
      | facebook_datum_prints | 10 |
      | facebook_datum_total_interactions | 10 |
      | facebook_datum_total_reach | 10 |
      | facebook_datum_potential_reach | 10 |
      | facebook_datum_total_prints_per_anno | 10 |
      | facebook_datum_total_prints | 10 |
      | facebook_datum_total_clicks_anno | 10 |
      | facebook_datum_fans_through_anno | 10 |
      | facebook_datum_agency_investment | 10 |
      | facebook_datum_new_stock_investment | 10 |
      | facebook_datum_anno_investment | 10 |
      | facebook_datum_ctr_anno | 10 |
      | facebook_datum_cpm_anno | 10 |
      | facebook_datum_cpc_anno | 10 |
    When I press "Guardar Datos"
    Then I should see "La Nueva Entrada de Datos se creo satisfactoriamente."

  @delete_facebook_data_success
  Scenario: Remove Facebook Data of a client
    Given Exist Facebook Data of Client named "Client1"
    When I visit the facebook data page of the client "Client1"
    Then I should see "Facebook Client 1"
    When I follow "delete_1"
    Then I should see "La informacion ha sido borrada exitosamente."

  @edit_twitter_data_success
  Scenario: Edit Facebook Data of a client
    Given Exist Facebook Data of Client named "Client1"
    When I visit the facebook data page of the client "Client1"
    Then I should see "Facebook Client 1"
    When I follow "edit_1"
    Then I should see "Editando Entrada Datos Facebook"
    When I press "Guardar Datos"
    Then I should see "La informacion ha sido actualizada con exitosamente."

  @select_data_in_date_range
  Scenario: Select Facebook Data in range date
    Given Exist Facebook Data of Client named "Client1"
    When I visit the facebook data page of the client "Client1"
    Then I should see "Facebook Client 1"
    When I select "1" from "fi_fi_3i"
    And I select "Aug" from "fi_fi_2i"
    And I select "2012" from "fi_fi_1i"
    And I select "15" from "ff_ff_3i"
    And I select "Aug" from "ff_ff_2i"
    And I select "2012" from "ff_ff_1i"
    And I press "Obtener Datos"
    Then I should see "1-15 August"

