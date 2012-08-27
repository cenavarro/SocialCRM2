Feature: Manage Twitter Data
  As a Admin User,
  I should be able to magane Twitter Data of the clients

  Background: I am on the Twitter Data Page of a client named Client1
    Given Exist a Admin User with data, name "admin" and email "admin@test.com" and password "adminadmin"
    And I am logged in as "admin@test.com/adminadmin"
    And Exist a Client User with data, name "Client1" with an email "client1@test.com" and password "123456"
    And Exist a Social Network named "Facebook" and its description is "Facebook Description"
    And Exist a Social Network named "Twitter" and its description is "Twitter Description"
    And Exist a Client named "Client1" with a Social Network named "Twitter Client 1" and associated to "Twitter"

  @add_new_twitter_data_success
  Scenario: Add New Twitter Data
    When I visit the new twitter data page of client "Client1"
    Then I should see "Nueva Entrada Datos Twitter"
    When I fill in the following:
      | twitter_datum_new_followers | 10 |
      | twitter_datum_total_followers |10 |
      | twitter_datum_goal_followers | Objetivo Followers Text |
      | twitter_datum_amount_tweets | 10|
      | twitter_datum_total_tweets | 10 |
      | twitter_datum_total_mentions | 10 |
      | twitter_datum_ret_tweets | 10 |
      | twitter_datum_total_clicks | 10 |
      | twitter_datum_total_interactions | 10 |
      | twitter_datum_agency_investment | 10.5|
    And I press "Guardar Datos"
    Then I should see "La informacion se ha ingresado exitosamente."

  @select_data_in_date_range
  Scenario: Select Twitter Data in range date
    Given Exist Twitter Data of Client named "Client1"
    When I visit the twitter data page of the client "Client1"
    Then I should see "Twitter Client 1"
    When I select "1" from "fi_fi_3i"
    And I select "Aug" from "fi_fi_2i"
    And I select "2012" from "fi_fi_1i"
    And I select "15" from "ff_ff_3i"
    And I select "Aug" from "ff_ff_2i"
    And I select "2012" from "ff_ff_1i"
    And I press "Obtener Datos"
    Then I should see "1-15 August"

  @delete_twitter_data_success
  Scenario: Remove Twitter Data of Client
    Given Exist Twitter Data of Client named "Client1"
    When I visit the twitter data page of the client "Client1"
    Then I should see "Twitter Client 1"
    When I follow "delete_1"
    Then I should see "La informacion ha sido borrada exitosamente."
  
  @edit_twitter_data_success
  Scenario: Edit Twitter Data of Client
    Given Exist Twitter Data of Client named "Client1"
    When I visit the twitter data page of the client "Client1"
    Then I should see "Twitter Client 1"
    When I follow "edit_1"
    Then I should see "Editando Entrada Datos Twitter"
    When I press "Guardar Datos"
    Then I should see "La informacion ha sido actualizada exitosamente."



