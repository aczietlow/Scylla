# Behat

Behavior Driven Development - an â€œoutside-inâ€ methodology. It starts at the outside by identifying business outcomes, and then drills down into the feature set that will achieve those outcomes. - Dan North*

Their docs are great! http://docs.behat.org/en/v2.5/

## Benefits

* Better code quality
* Less Regression
* Better Acceptance Criteria
* Greater understanding of code base

Case studies conducted at Microsoft and IBM indicate that teams that adopt TDD experience 40% to 90% bugs, which results in 15-35% additional development time.

## Installation

* Composer

        "require": {
                "behat/behat": "2.5.*@stable",
                "behat/mink": "1.5.*@stable",
                "behat/mink-extension": "*",
                "behat/mink-goutte-driver": "*",
                "behat/mink-selenium2-driver": "*"
            }

* behat.yml

        default:
          paths:
            features: 'acceptance'
          extensions:
            Behat\MinkExtension\Extension:
              goutte: ~
              selenium2:
                wd_host: "http://127.0.0.1:8643/wd/hub"
              base_url: http://scylla.dev

## Toolchain

* Browser

Firefox

* Drivers
  * Emulators - Glorified http clients; can send http requests and parse the response
     * Goutte
     * Browser Kit
  * Controllers - controls real browser (like firefox)
     * Selenium2
     * PhantomJS
* Mink Abstraction layer that sits on top of drivers
  * Allows a common interface for describing behaviors using different drivers
* Behat - Behavior driven testing framework of awesomeness
  * Written in Gherkin language and saved in a .feature file


### Difference between Browser Emulators and controllers

Emulators - Glorified http clients; can send http requests and parse the response

* Fast
* Can't run javascript, or AJAX support

Controllers - controls real browser (like firefox)

* Simulates user interactions in actual browser
* Supports javascript/AJAX
* Supports screenshots
* Slow
* Additional configuration
* Require browser

## Behat: Writing features

In BDD everything starts with defining a feature, and then implementing it in code. Features are written using gherkin syntax and saved in a .feature file

    # acceptance/homepage.feature
    
    @api
    Feature: Homepage.
      As a user of Scylla,
      I want to see Hello world on the homepage,
      so that I know who is responsible for such an awesome product.
    
    
Every feature starts with the same format: 

    As a <user role>,
    I want <some feature>, 
    so that <some benefit>.

This section isn't parsed by Behat during testing, but is important in describing the feature in a readable format. Each feature is described by multiple "scenarios" or how that feature will behave under various conditions.

    Scenario: I can see the Hello World on the homepage.
       When I am on the homepage
       Then I should see the text "Hello World"
         
Executing tests

     bin/behat
     bin/behat acceptance/homepage.feature
     bin/behat --name='I can see the Hello World on the homepage'

     >output
     @api
     Feature: Homepage.
       As a user of Scylla,
       I want to see the Scylla on the homepage,
       so that I know who is responsible for such an awesome product.
     
       Scenario: I can see the Scylla name on the homepage. # acceptance/homepage.feature:7
         When I am on the homepage                                   # FeatureContext::iAmOnHomepage()
         Then I should see the text "Scylla"       # FeatureContext::assertTextVisible()
     
     1 scenario (1 passed)
     2 steps (2 passed)
     0m5.685s


## Behat: Step definitions
  
Behat needs to know how to perform each step defined in our features. The mink extensions has added several common step definitions for us out of the box. To see a list of available step definitions run the following:

    bin/behat -dl
    
    >output
    Given /^(?:|I )am on (?:|the )homepage$/
    When /^(?:|I )go to (?:|the )homepage$/

Custom step definitions can go in FeatureContext which extends BehatContext given us access to all the defined step definitions from Mink. Consider the following feature scenario.

     Scenario: I can log in to my account.
       Given I am on the homepage
       When I go to the login page
       Then I should see the text "Username"
       And I should see the text "Password"
       
If you were to run this test, Behat would tell us that we don't have a step definition for this yet.

      Scenario: I can log in to my account.                         # acceptance/homepage.feature:13
        Given I am on the homepage                                  # FeatureContext::iAmOnHomepage()
        When I go to the login page
        Then I should see the text "Username"                       # FeatureContext::assertTextVisible()
        And I should see the text "Password"                        # FeatureContext::assertTextVisible()
    
    1 scenarios (1 undefined)
    4 steps (1 passed, 2 skipped, 1 undefined)
    0m9.051s
    
    You can implement step definitions for undefined steps with these snippets:
    
      /**
       * @When /^I go to the login page$/
       */
      public function iGoToTheLoginPage() {
        throw new PendingException();
      }

Behat will generate a code scaffolding to use for our test. which we can further define.

      /**
       * @When /^I go to the login page$/
       */
      public function iGoToTheLoginPage() {
        $this->getSession()->visit('user');
      }
      
This is a good place to highlight how awesome mink is for us. Here's just some examples of how to navigate to pages with drivers:

    // Selenium2 WebDriver
    $driver->get('http://google.com');
    $driver->navigate()->to('http://google.com');
   
    // Goutte
    $crawler = $client->request('GET', 'http://google.com');

Some common usages of the Mink API

    $element = $session->getPage();

    $element->findAll($selector, $locator);
    $element->getText();
    $element->getHtml();
    
    $element->isVisible();
    $element->click();
    $element->press();
    $element->check();
    $element->uncheck();
    
[Mink Cheat sheet](http://blog.lepine.pro/images/2012-03-behat-cheat-sheet-en.pdf)

## Behat: Drupal Extension

We're using the Drupal Extension, which is an integration layer between Mink and Drupal. It provides step definitions specific to Drupal as well as gives us access to making calls to the Drupal code base within tests.
 
    Scenario Outline: Confirm the migrations for the homepage content are complete.
        Given the "migrate" module is installed
        Then the "migration" migration is complete
     
    
    // FeatureContext.php
        /**
         * Asserts that a given module exists and is enabled.
         *
         * @Given /^the "([^"]*)" module is installed$/
         */
        public function assertModuleExists($module)
        {
            if (module_exists($module)) {
                return TRUE;
            }
            $message = sprintf('Module "%s" is not installed.', $module);
            throw new \Exception($message);
        }
        
        /**
        * Asserts the given migration is complete.
        *
        * @Then /^the "([^"]*)" migration is complete$/
        */
        public function assertMigrationIsComplete($name)
        {
        $migration = Migration::getInstance($name);
        if ($migration->isComplete()) {
          return TRUE;
        }
        $message = sprintf('The "%s" migration is not complete.', $name);
        throw new \Exception($message);
        }
        
### Behat: Writing tests in Drupal

Often times we need to create content (nodes) to test expected behaviors in Drupal. Using the Drupal extension and Nodetables Consider the following scenario:

    Scenario: Add a page node and verify that the necessary fields exist.
        Given A "page" node:
          | title       | body      | updated               | author |
          | Page title  | page body | 2015-02-19 20:30:00   | 1      |
        When I go to the node url
        Then I should see the heading "Page title"

Testing specific user roles.

    Scenario: Community Manager can add news nodes
      Given I am logged in as a user with the "Editor" role
      When I am at "node/add/news"
      Then I should get a "200" HTTP response
      
Creates a new user with a random username and name, and assigns them the role "community manager"

All content (users, nodes, taxonomies, and user roles) that were created during testing, will be deleted.