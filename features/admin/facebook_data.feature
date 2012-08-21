Feature: Select Facebook Data
  As a Admin User,
  I should be see Facebook Data in a date range

  @wip
  Scenario: Show Facebook data in a range
  	Given a client named "Starbucks"
  	And a Facebook datum for client "Starbucks" with the following stats:
  		| start_date | end_date  | new_fans |
  		| 8/14/2012  | 8/20/2012 | 1000     |
  	When I find Facebook datum for "Starbucks" between "8/14/2012" and "8/20/2012"
  	Then I should have the following information:
  		| new_fans |
  		| 1000     |
