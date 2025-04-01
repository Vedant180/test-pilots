Feature: Account Management

  Scenario: Create a new bank account
    Given a valid user request with unique email and phone number
    When the "/finance/v1/bank/v4/bharat/create-account" endpoint is called with a POST request
    Then a 201 status code is returned
    And a UserResponse containing the new account details is returned
    And a notification is sent to the user

  Scenario: Update existing bank account details
    Given an existing bank account with account number "1234567890"
    And a valid account update request
    When the "/finance/v1/bank/v4/bharat/update-account-details" endpoint is called with a PUT request
    Then a 201 status code is returned
    And an AccountUpdateDetailsResponse confirming the update is returned
    And a notification is sent to the user

  Scenario: Delete a bank account
    Given an existing bank account with account number "1234567890"
    And the correct password
    When the "/finance/v1/bank/v4/bharat/delete-account" endpoint is called with a DELETE request
    Then a 202 status code is returned
    And an AccountDeletedSuccessResponse is returned
    And a notification is sent to the user

  Scenario: Retrieve bank account details
    Given an existing bank account with account number "1234567890", IFSC code "SBIN0000001", and password "password123"
    When the "/finance/v1/bank/v4/bharat/get-account-details/1234567890/SBIN0000001/password123" endpoint is called with a GET request
    Then a 202 status code is returned
    And an AccountDetailsResponse containing the account details is returned

  Scenario: Perform a balance enquiry
    Given an existing bank account with account number "1234567890" and password "password123"
    And a valid BalanceEnquireyRequest
    When the "/finance/v1/bank/v4/bharat/balance-enquiry" endpoint is called with a GET request
    Then a 202 status code is returned
    And a BalanceEnquiryResponse containing the account balance is returned
    And a notification is sent to the user


Feature: Transaction Management

  Scenario: Credit money to an account
    Given an existing bank account with account number "1234567890" and sufficient daily transaction limit
    And a valid CreditCredential
    When the "/finance/v1/bank/v4/bharat/credit-money" endpoint is called with a GET request
    Then a 202 status code is returned
    And a CreditResponse is returned
    And the account balance is updated
    And a notification is sent to the user

  Scenario: Debit money from an account
    Given an existing bank account with account number "1234567890", sufficient balance, and sufficient daily transaction limit
    And a valid DebitCredential
    When the "/finance/v1/bank/v4/bharat/debit-money" endpoint is called with a GET request
    Then a 202 status code is returned
    And a DebitedResponse is returned
    And the account balance is updated
    And a notification is sent to the user

  Scenario: Transfer money between accounts
    Given two existing bank accounts with sufficient balance in the sender account
    And a valid TransferMoneyRequest
    When the "/transfer/v1/banking/v6/process" endpoint is called with a POST request
    Then a 202 status code is returned
    And a TransferMoneyResponse is returned
    And the balances of both accounts are updated
    And a notification is sent to the user (for high value transactions)

  Scenario: Retrieve transaction history
    Given an existing bank account with account number "1234567890"
    When the "/transaction/v1/fetch/transaction-enquiry/1234567890" endpoint is called with a GET request
    Then a 202 status code is returned
    And a List<TransactionResponse> containing the transaction history is returned


Feature: UPI Management

  Scenario: Create a UPI ID
    Given an existing bank account with account number "1234567890" and a valid NetBanking ID
    And a valid UPIRequest
    When the "/finance/upi/v1/upi-create" endpoint is called with a POST request
    Then a 202 status code is returned
    And a UPIResponse containing the new UPI ID is returned
    And a notification is sent to the user

  Scenario: Retrieve UPI details
    Given an existing UPI ID linked to account number "1234567890"
    And the correct password
    When the "/finance/upi/v1/get-upi-details" endpoint is called with a GET request
    Then a 202 status code is returned
    And a UPIResponse containing the UPI details is returned

  Scenario: Add money to UPI from bank account
    Given an existing bank account with sufficient balance and a linked UPI ID
    And a valid AddMoneyToUPIFromAccountRequest
    When the "/finance/v1/bank/v4/bharat/add-money-to-upi-from-bank" endpoint is called with a POST request
    Then a 202 status code is returned
    And an AddMoneyToUPIFromAccountResponse is returned
    And the account and UPI balances are updated

  Scenario: Pay money from UPI to bank account
    Given an existing UPI ID with sufficient balance and a linked bank account
    And a valid AddMoneyFromAccountToUPIRequest
    When the "/finance/v1/bank/v4/bharat/pay-money-from-upi" endpoint is called with a POST request
    Then a 202 status code is returned
    And an AddMoneyFromAccountToUPIResponse is returned
    And the UPI and account balances are updated


Feature: Net Banking

  Scenario: Create a net banking ID
    Given an existing bank account with account number "1234567890"
    And a valid netBankingRequest
    When the "/finance/v1/banking/net-bankingId-create" endpoint is called with a POST request
    Then a 202 status code is returned
    And a NetBankingResponse containing the new net banking ID is returned
    And a notification is sent to the user

  Scenario: Retrieve net banking details
    Given an existing bank account with account number "1234567890"
    And a valid GetNetBankingRequest
    When the "/finance/v1/banking/get-internetBanking-details" endpoint is called with a GET request
    Then a 202 status code is returned
    And a NetBankingResponse containing the net banking details is returned


Feature: Manual Balance Updates

  Scenario: Manually update account balance
    Given an existing bank account with account number "1234567890"
    And a valid UpdateAmountManually request
    When the "/finance/v1/bank/v4/bharat/update/money" endpoint is called with a PUT request
    Then a 202 status code is returned
    And an UpdateAmountResponse is returned
    And the account balance is updated