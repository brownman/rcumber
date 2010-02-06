Feature: Dashboard

  To get a birdseye view of all cukes
  As a stakeholder
  I want a sexy dashboard

  @ok
  Scenario: Viewing when No Cukes Exist
    Given no cukes exist
    When I am on the Dashboard
    Then I should see "You don't have any Cukes in the ./features directory or your project."
    And I should see "Either create some, or you can look at these Demo Cukes"

  Scenario: Viewing when Cukes Exist
    Given the cukes "file1,file2"
    When I am on the dashboard
    Then I should see "name"
    And I should see "State"
    And I should see "Actions"
    And I should see "Run"
    And I should see "file1"
    And I should see "file2"

  Scenario: Viewing when Cukes Exist w/ Tags at Feature Level (Issue #2)
    Given a cuke "feature_tagged":
      """
      @i_shouldn't_break_anything
      Feature: Tagged
      """
    When I am on the Dashboard
    Then I should see "feature_tagged"
    
  Scenario: Selecting a Profile
    Given the profiles "default,empty"
    When I am on the dashboard
    Then I should be able to select "default" from "Run Using Profile"
    And I should be able to select "empty" from "Run Using Profile"
  
  @undefined_scenario  
  Scenario: Selecting a Profile (cucumber.yml contains erb, Issue #7)