Feature: Submit proposals
  In order to have a large inventory of speaking proposals to choose from
  Visitors should be able to submit speaking proposals
  
  Scenario: A visitor submits a proposal
    Given Ignite "Baltimore"
    When I submit a proposal "How to give an Ignite Talk"
    And I visit the proposals page
    Then I should see "How to give an Ignite Talk"

  Scenario: A visitor submits an incomplete proposal
    Given Ignite "Baltimore"
    When I submit an incomplete proposal "How to give an Ignite Talk"
    Then I should see "There were problems with the following fields"
    
    When I visit the proposals page
    Then I should not see "How to give an Ignite Talk"
    
  Scenario: A proposal submitter edits their proposal
    Given Ignite "Baltimore"
    And a proposal "How to give an Ignite Talk" exists for the featured event
    When I view the edit proposal page with its edit key
    Then I should see "How to give an Ignite Talk"
    
    When I fill in the following:
      | Description  | I just changed the description |
    And I press "Update Proposal"
    And I view the proposal
    Then I should see "Your proposal has been updated"
    And I should see "I just changed the description"
    
  Scenario: A proposal submitter edits their proposal with invalid data
    Given Ignite "Baltimore"
    And a proposal "How to give an Ignite Talk" exists for the featured event
    When I view the edit proposal page with its edit key
    And I fill in the following:
      | Description |  |
    And I press "Update Proposal"
    Then I should see "There were problems with the following fields"
    
  Scenario: A proposal submitter edits a proposal with an invalid key
    Given Ignite "Baltimore"
    And a proposal "How to give an Ignite Talk" exists for the featured event
    When I view the edit proposal page
    Then I should be redirected
    
    When I follow the redirect
    Then I should see "Invalid key"
    
  Scenario: A proposal submitter tries to edit a proposal after the deadline has passed
    Given Ignite "Baltimore"
    And a proposal "How to give an Ignite Talk" exists for the featured event
    And the featured event is no longer accepting proposals
    When I view the edit proposal page with its edit key
    Then I should be redirected
    
    When I follow the redirect
    Then I should see "Proposal submission is no longer open, you can no longer edit this proposal."