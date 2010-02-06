Feature: Managing Cukes

  So that I can manage my cukes in a browser
  As a stakeholder
  I want a sexy web interface

  Background:
    Given a cuke "basic":
      """
      Feature: Basic Feature

        As a feature
        I have a preamble

        Scenario: Number 1
          Given I am a step
      """

  @ok
  Scenario: View Existing Cuke
    Given I am on Show Cuke for basic
    Then I should see "Basic Feature"
    And I should see "run"
    And I should see "see all features"
    And I should see the full feature text for "basic"

  @ok
  Scenario: Create Cuke
    Given I am on Show Cuke for basic
    When I follow "new feature"
    And I fill in "Enter the base filename" with "my_feature"
    And I fill in "Enter the Feature name:" with "My Feature"
    And I press "Create"
    Then I should be on Edit Cuke for my_feature
    And I should see "/My Feature"
    And the field "rcumber[raw_content]" should contain "Feature: My Feature"

  Scenario: Edit Existing Cuke
    Given I am on Show Cuke for basic
    When I follow "edit"
    Then I should be on Edit Cuke for my_feature
    When I fill in "rcumber[raw_content]" with
      """
      Feature: Basic Feature

        Is now really basic
      """
    And I press "Pickle It!"
    Then I should be on Show Cuke for basic
    And I should see "Cucumber was pickled!"
    And I should see "Is now really basic"
    And I should not see "Scenario: Number 1"

  @undefined_scenario @needs_selenium
  Scenario: Delete Existing Cuke
