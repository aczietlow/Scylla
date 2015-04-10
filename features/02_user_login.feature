@api
Feature: Homepage.
  As a user of Scylla,
  I want to be able to log into the site
  so that may access features specific to my user account.

  Scenario: I can log in.
    Given I am an anonymous user
    When I am at "user/login"
    And I fill in "name" with "admin"
    And I fill in "pass" with "admin"
    And press "Log in"
    Then I should see the link "Log out"
