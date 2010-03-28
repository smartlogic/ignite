Feature: Proposal Notifications
  In order to actively engage visitors of the site
  An admin
  Should receive email notifications on proposal activity
  
  Scenario: A visitor submits a proposal
    Given Ignite "Baltimore"
    And "john@localhost" is receiving email notifications
    When a visitor submits a proposal
    Then "john@localhost" receives a notification email
    And the submitter receives a thank you email