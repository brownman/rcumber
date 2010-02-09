Feature: Running Cukes

  So that I can be free of the command line
  As a less tech savvy stakeholder
  I want to run my cukes in a sexy web interface

  Background:
    Given I create the cuke "torun":
      """
      Feature: To Run
      
        Some Preamble
      """
  
  @ok
  Scenario: From Show Cuke
    Given I am on Show Cuke for torun
    When I follow "run"
    Then I should be on Ran Cuke for torun
    And I should see "passing"
    And the run log for "torun" should contain "Feature: To Run"
    And the run log for "torun" should contain "Some Preamble"

  @ok
  Scenario: From Dashboard (1 cuke checked)
    When I am on the Dashboard
    And I check "uids_torun"
    When I press "Run Selected"
    Then I should see "passing"
    And the run log for "torun" should contain "Feature: To Run"
    And the run log for "torun" should contain "Some Preamble"

  @undefined_scenario
  Scenario: From Dashboard (2 cukes checked)