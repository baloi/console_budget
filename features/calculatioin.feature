Feature: calculation
  In order to budget my salary
  As a moronic spender
  I want to be able to track my expenses and plan accordingly

  Scenario: calculate expenses time period
    Given I have an expense of 50 on 9/28/10 and 60 on 10/1/10
    And I choose 9/27/10 to 10/4/10 as the date range
    When I press calculate 
    Then the result should be 110
