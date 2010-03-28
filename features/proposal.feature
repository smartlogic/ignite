Feature: Submit proposals
  In order to have a large inventory of speaking proposals to choose from
  Visitors should be able to submit speaking proposals
  
  Scenario: Submit a proposal
    Given Ignite Baltimore exists
    When I submit a proposal "How to give an Ignite Talk"
    And I visit the proposals page
    Then I should see "How to give an Ignite Talk"