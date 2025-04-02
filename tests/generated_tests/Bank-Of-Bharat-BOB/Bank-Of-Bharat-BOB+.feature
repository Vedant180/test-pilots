Feature: Money Transfer API

  Scenario Outline: Successful Money Transfer
    Given a user with account number "<senderAccountNumber>" and sufficient balance of <senderBalance>
    And a recipient with account number "<recipientAccountNumber>"
    When a transfer of <amount> USD is requested from "<senderAccountNumber>" to "<recipientAccountNumber>"
    Then the transfer should be successful with status code 202
    And the response should include a TransferMoneyResponse
    Examples:
      | senderAccountNumber | recipientAccountNumber | senderBalance | amount |
      | 1234567890         | 9876543210         | 500           | 100    |
      | 1122334455         | 5544332211         | 1000          | 50     |


  Scenario: Insufficient Funds
    Given a user with account number "1234567890" and sufficient balance of 100
    And a recipient with account number "9876543210"
    When a transfer of 200 USD is requested from "1234567890" to "9876543210"
    Then the transfer should fail with status code 403
    And the response should include an ErrorResponses object indicating insufficient funds


  Scenario: Sender Account Not Found
    Given a user with account number "9999999999" and sufficient balance of 500  
    And a recipient with account number "9876543210"
    When a transfer of 100 USD is requested from "9999999999" to "9876543210"
    Then the transfer should fail with status code 403
    And the response should include an ErrorResponses object indicating sender account not found


  Scenario: Recipient Account Not Found
    Given a user with account number "1234567890" and sufficient balance of 500
    And a recipient with account number "0000000000"
    When a transfer of 100 USD is requested from "1234567890" to "0000000000"
    Then the transfer should fail with status code 403
    And the response should include an ErrorResponses object indicating recipient account not found


  Scenario:  Both Sender and Recipient Accounts Not Found
    Given a user with account number "9999999999" and sufficient balance of 500
    And a recipient with account number "0000000000"
    When a transfer of 100 USD is requested from "9999999999" to "0000000000"
    Then the transfer should fail with status code 403
    And the response should include an ErrorResponses object indicating both accounts not found (or appropriate error message)


  Scenario: Transfer with Zero Amount
      Given a user with account number "1234567890" and sufficient balance of 500
      And a recipient with account number "9876543210"
      When a transfer of 0 USD is requested from "1234567890" to "9876543210"
      Then the transfer should fail with an appropriate error message.