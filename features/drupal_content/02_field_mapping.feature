@api
Feature: Creating content
  As a developer writing Behat tests
  I want to be able to have step definitions that allow me to create content
  So that I may put Drupal in the desired state for testing

  Scenario: Create a node and using a logged in user as the author
    Given page content:
      | title | Page Content |
      | author | admin |

  Scenario: View the newly created node
    When I am viewing a "page" content:
      | title | Post title         |


  # Works with term reference and entity reference fields.
  Scenario: Creating a node with newly created taxonomy terms.
    Given tags terms:
    | name    |
    | milk    |
    | cereal  |
    Given "isildurs_bane" content:
      | title           | field_taxonomy_reference |
      | The One with tags | milk, cereal |

  #Date fields
  Scenario: Creating a node a date field.
    Given "isildurs_bane" content:
      | title      |   field_date                      |
      | The One with dates | 2015-02-08 17:45:00 - 2015-02-08 19:45:00 |

  #Entity Reference
  Scenario: Creating a node with an entity reference field
    Given page content:
      | title |
      | page1 |
      | page2 |
    Given "isildurs_bane" content:
      | title                  | field_entity_reference |
      | The One with entity reference fields | page1, page2                         |

  #Link Fields
  Scenario: Creating a node with newly created taxonomy terms.
    Given "isildurs_bane" content:
      | title      | field_link                         |
      | The One with the link | XKCD - http://xkcd.com/ |