Feature: resolve package
  Scenario: Resolve Schema
    Given I am viewing "/"
    And a schema file
    When I click resolve
    Then I should see a premis report
    
  Scenario: Resolve Stylesheet
    Given I am viewing "/"
    And a stylesheet file
    When I click resolve
    Then I should see a premis report
    
  Scenario: Resolve DTD
    Given I am viewing "/"
    And a dtd file
    When I click resolve
    Then I should see a premis report
    
  Scenario: Resolve A Binary file
    Given I am viewing "/"
    And a binary file
    When I click resolve
    Then I should see a premis report
    
  Scenario: Resolve a random data file  
    Given I am viewing "/"
    And a random data file
    When I click resolve
    Then I should see a premis report
    
  Scenario: Resolve leads to success event
    Given I am viewing "/"
    And a successful file
    When I click resolve
    Then I should see eventOutcome "success"
    
  Scenario: Resolve leads to mixed event
    Given I am viewing "/"
    And a mixed file
    When I click resolve
    Then I should see eventOutcome "mixed"
  
  Scenario: Resolve leads to failure event
    Given I am viewing "/"
    And a failure file
    When I click resolve
    Then I should see eventOutcome "failure"
    
  Scenario: Resolve links with redirects
    Given I am viewing "/"
    And a file with redirects
    When I click resolve
    Then I should see a premis report  
  
    
  