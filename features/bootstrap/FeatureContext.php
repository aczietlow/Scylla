<?php

use Drupal\DrupalExtension\Context\RawDrupalContext;
use Behat\Behat\Context\SnippetAcceptingContext;
use Behat\Gherkin\Node\PyStringNode;
use Behat\Gherkin\Node\TableNode;

/**
 * Defines application features from the specific context.
 */
class FeatureContext extends RawDrupalContext implements SnippetAcceptingContext
{

    /**
     * Initializes context.
     *
     * Every scenario gets its own context instance.
     * You can also pass arbitrary arguments to the
     * context constructor through behat.yml.
     */
    public function __construct()
    {

    }

    /**
     * Asserts that a given module exists and is enabled.
     *
     * @Given /^the "(?P<module>[^"]*)" module is installed$/
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
     * @When /^I visit the login page$/
     */
    public function iAmOnThe()
    {
        $this->getSession()->visit('user');
    }
}
