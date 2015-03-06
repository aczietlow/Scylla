@api
Feature: Homepage.
  As a user of Scylla,
  I want to see Scylla's name on the homepage,
  so that I what website I am using.

  Scenario: I can see the Hello World on the homepage.
    When I am on the homepage
    Then I should see the text "Scylla"