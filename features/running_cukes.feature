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
  
  @undefined_scenario
  Scenario: From Show Cuke

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