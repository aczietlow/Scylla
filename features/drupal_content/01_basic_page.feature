@api
Feature: Basic page nodes
  As a admin user
  I want to have the ability to create basic page nodes
  So that I can populate the site with content.

  Scenario: I have permission to create a basic page
    Given I am logged in as a user with the administrator role
    Then I should see the text "Log out"
    When I visit "node/add/page"
    Then I should get a 200 HTTP response
    And I should see "Create Basic page"

  Scenario: Newly created page nodes appear on the homepage.
    Given "page" content:
      | title |
      | Page Content |
    When I go to the homepage
    Then I should see "Page Content"