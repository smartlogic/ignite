Feature: Submit proposals
  In order to have a large inventory of speaking proposals to choose from
  Visitors should be able to submit speaking proposals
  
  Scenario: A visitor submits a proposal
    Given Ignite "Baltimore"
    When I submit a proposal "How to give an Ignite Talk"
    And I visit the proposals page
    Then I should see "How to give an Ignite Talk"

  Scenario: A visitor submits an incomplete proposal
