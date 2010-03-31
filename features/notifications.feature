Feature: Proposal Notifications
  In order to actively engage visitors of the site
  An admin
  Should receive email notifications on proposal activity
  
  Scenario: A visitor submits a proposal
    Given Ignite "Baltimore"
    When a visitor submits a proposal
    Then Ignite "Baltimore" admins receive a proposal notification email
    And the submitter receives a thank you email
    
  Scenario: A visitor submits a proposal to an Ignite that is not set up to receive notifications
    Given Ignite "Baltimore" without notification emails
    When a visitor submits a proposal
    Then no one receives a proposal notification email