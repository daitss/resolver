Feature: Collection Manager
  Scenario: Checksum
    Given a "test" file
    When I resolve
    Then I should have checksum
  
  Scenario: Broken Links
    Given a "test" file
    When I resolve
    Then I should have broken links
  
  Scenario: Redirects
    Given a "redirect" file
    When I resolve
    Then I should have redirects
    
  Scenario: Create Collection
    Given a "test" file
    When I create a collection
    And I resolve
    Then I should have a manifest list  
  
  Scenario: Create Manifest
    Given a "test" file
    When I create a collection
    And I resolve
    Then I should have a manifest
  
  Scenario: Create Tarball
    Given a "test" file
    When I create a collection
    And I resolve
    And I create a tarball
    Then I should have a tarball location
    And I should remove the tarball