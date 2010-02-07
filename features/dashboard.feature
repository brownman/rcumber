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

  @ok
  Scenario: Viewing when Cukes Exist
    Given the cukes "file1,file2"
    When I am on the dashboard
    Then I should see "name"
    And I should see "State"
    And I should see "Actions"
    And I should see "Run"
    And I should see "file1"
    And I should see "file2"

  @ok
  Scenario: Viewing when Cukes Exist w/ Tags at Feature Level (Issue #2)
    Given a cuke "feature_tagged":
      """
      @i_shouldn't_break_anything
      Feature: Tagged
      """
    When I am on the Dashboard
    Then I should see "feature_tagged"
  
  @ok  
  Scenario: Selecting a Profile (Issue #6)
    Given the profiles "default,empty"
    When I am on the dashboard
    Then I should be able to select "default" from "Run Using Profile"
    And I should be able to select "empty" from "Run Using Profile"
  
  @ok
  Scenario: Viewing Demo Cukes
    Given no cukes exist
    And I am on the Dashboard
    When I follow "Demo Cukes"
    Then I should see "/Dashboard"
    When I go to Show Demo for dashboard
    Then I should see "Feature: Dashboard"
    And I should see "Scenario: Viewing Demo Cukes"
  
  @ok
  Scenario: Running Demo Cukes (Issue #8)
    Given no cukes exist
    And I am on the dashboard
    When I follow "Demo Cukes"
    And I check "uids_dashboard"
    And I press "Run Selected"
    Then I should see "passing"
  