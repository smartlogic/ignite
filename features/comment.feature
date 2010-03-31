Feature: Commenting
  In order to generate interest around proposals within the site
  A visitor
  Should be able to comment on proposals
  
  Scenario: A visitor comments on a proposal
    Given Ignite "Baltimore"
    And a proposal exists for the featured event
    When I view the proposal
    And I fill in the following:
      | Name    | John |
      | Email   | john@localhost |
      | Comment | This talk looks like it's going to rock |
    And I press "Submit Comment"
    Then the submitter receives a comment notification email
    And Ignite "Baltimore" admins receive a comment notification email
    
    When I view the proposal
    Then I should see "Your comment has been posted"
    And I should see "This talk looks like it's going to rock"
  