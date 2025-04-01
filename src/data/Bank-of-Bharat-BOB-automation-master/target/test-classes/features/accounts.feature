Feature: Create a new user account
  @test
  Scenario: Successfully create an account
    Given the user provides valid account details
    When the user sends a request to create an account
    Then the account should be created successfully
    And the response status should be 201