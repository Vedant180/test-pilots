Feature: Create Bank Account

  Scenario: Successful Account Creation
    Given a user provides valid account details including a unique email and phone number
    When the user sends a POST request to "/finance/v1/bank/v4/bharat/create-account" with the user details
    Then the response status code should be 201
    And the response should contain the newly created account details (UserResponse)


  Scenario: Account Creation Failure - Duplicate Email
    Given a user provides account details with an email address that already exists
    When the user sends a POST request to "/finance/v1/bank/v4/bharat/create-account" with the user details
    Then the response status code should be 403
    And the response should contain an error message indicating the email address is already in use (ErrorResponses)


  Scenario: Account Creation Failure - Duplicate Phone Number
    Given a user provides account details with a phone number that already exists
    When the user sends a POST request to "/finance/v1/bank/v4/bharat/create-account" with the user details
    Then the response status code should be 403
    And the response should contain an error message indicating the phone number is already in use (ErrorResponses)


  Scenario: Account Creation Failure - Missing Required Fields
    Given a user provides incomplete account details, missing a required field (e.g., email)
    When the user sends a POST request to "/finance/v1/bank/v4/bharat/create-account" with the incomplete details
    Then the response status code should be [Error Code -  specify appropriate code based on API design]
    And the response should contain an error message indicating the missing required field(s) (ErrorResponses)


  Scenario: Account Creation - Automatic Account Number Generation
    Given a user provides valid account details
    When the user sends a POST request to "/finance/v1/bank/v4/bharat/create-account" with the user details
    Then the response should contain a newly generated account number
    And the account number should not be provided by the user in the request.


  Scenario Outline: Account Creation with various data types
    Given a user provides valid account details with <data_type> for <field>
    When the user sends a POST request to "/finance/v1/bank/v4/bharat/create-account" with the user details
    Then the response status code should be 201
    Examples:
      | data_type | field         |
      | String     | email         |
      | Integer    | phone number  |
      | String     | address       |


  Scenario Outline: Error Handling with Invalid Data
      Given a user provides account details with an invalid <field> of type <data_type>
      When the user sends a POST request to "/finance/v1/bank/v4/bharat/create-account" with the user details
      Then the response status code should not be 201
      And the response should include an error message indicating the invalid input.
      Examples:
        | field         | data_type |
        | email         | invalid_email@.com |
        | phone number  | 12345678901234567890 |  
        | address       |  invalid address       |

Feature: Update Bank Account Details

  Scenario: Successful Account Update
    Given an existing bank account with account number "1234567890" and IFSC code "SBIN0000001"
    And the user provides valid updated details including account name "John Doe" and mobile number "+15551234567"
    When the user sends a PUT request to "/finance/v1/bank/v4/bharat/update-account-details" with the updated details
    Then the response status code should be 201
    And the response body should match the expected AccountUpdateDetailsResponse schema
    And a successful update notification should be sent

  Scenario: Account Not Found
    Given a non-existent bank account with account number "9876543210" and IFSC code "HDFC0000001"
    And the user provides updated details
    When the user sends a PUT request to "/finance/v1/bank/v4/bharat/update-account-details" with the incorrect details
    Then the response status code should be 403
    And the response body should match the expected ErrorResponses schema
    And an error notification (if applicable) should be sent


  Scenario: Account Update Failure - Incorrect IFSC Code
    Given an existing bank account with account number "1234567890" and IFSC code "SBIN0000001"
    And the user provides updated details with an incorrect IFSC code "ICICI0000001"
    When the user sends a PUT request to "/finance/v1/bank/v4/bharat/update-account-details" with the incorrect IFSC code
    Then the response status code should be 403
    And the response body should match the expected ErrorResponses schema
    And an error notification (if applicable) should be sent


  Scenario: Account Update Failure - Missing Account Number
    Given an existing bank account with account number "1234567890" and IFSC code "SBIN0000001"
    And the user provides updated details missing the account number
    When the user sends a PUT request to "/finance/v1/bank/v4/bharat/update-account-details" with missing account number
    Then the response status code should be 400  (Assuming bad request for missing required field)
    And the response body should indicate the missing account number


  Scenario Outline: Account Update with Different Data Types
    Given an existing bank account with account number "1234567890" and IFSC code "SBIN0000001"
    And the user provides updated details with <invalid_data>
    When the user sends a PUT request to "/finance/v1/bank/v4/bharat/update-account-details" with the invalid data
    Then the response status code should be 400 # or appropriate error code
    And the response body should indicate the data type error

    Examples:
      | invalid_data                               |
      | Account name with special characters  ~!@#$%^&*()_+=-`|
      | Mobile number with alphabets           |
      | Account number as a string with letters |

Feature: Delete Bank Account

  Scenario: Successful Account Deletion
    Given an existing account with account number "1234567890" and password "password123"
    When the API endpoint "/finance/v1/bank/v4/bharat/delete-account" is called with a DELETE request and valid "accountDetailsRequest"
    Then the response status code should be 202
    And the response body should match the "AccountDeletedSuccessResponse" schema

  Scenario: Account Deletion Failure - Account Not Found
    Given an account with account number "9876543210" and password "wrongpassword" that does not exist
    When the API endpoint "/finance/v1/bank/v4/bharat/delete-account" is called with a DELETE request and a valid "accountDetailsRequest"  for the non-existent account.
    Then the response status code should be 403
    And the response body should match the "ErrorResponses" schema
    And the response body should contain an error message indicating the account was not found


  Scenario: Account Deletion Failure - Incorrect Password
    Given an existing account with account number "1234567890" and password "wrongpassword"
    When the API endpoint "/finance/v1/bank/v4/bharat/delete-account" is called with a DELETE request and a valid "accountDetailsRequest"
    Then the response status code should be 403
    And the response body should match the "ErrorResponses" schema
    And the response body should contain an error message indicating incorrect password or similar.


  Scenario: Account Deletion Failure - Invalid Account Details Request
    Given an invalid "accountDetailsRequest" is provided.
    When the API endpoint "/finance/v1/bank/v4/bharat/delete-account" is called with a DELETE request and the invalid "accountDetailsRequest"
    Then the response status code should be a non-2xx code (e.g., 400)  
    And the response body should contain an error message indicating invalid input.


  Scenario Outline: Account Deletion with Various Account Numbers and Passwords <accountNumber> <password> <expectedStatusCode> <expectedMessage>
    Given an account with account number "<accountNumber>" and password "<password>"
    When the API endpoint "/finance/v1/bank/v4/bharat/delete-account" is called with a DELETE request and a valid "accountDetailsRequest"
    Then the response status code should be <expectedStatusCode>
    And the response body should contain "<expectedMessage>"


Examples:
| accountNumber | password     | expectedStatusCode | expectedMessage                                      |
|---------------|--------------|--------------------|------------------------------------------------------|
| 1234567890    | password123  | 202                | Account deleted successfully                          |
| 9876543210    | wrongpassword | 403                | Account not found or similar error message           |
| 1111111111    | password123  | 403                | Account not found or similar error message           |
| 1234567890    | wrongpass    | 403                | Incorrect password or similar error message           |

Feature: Retrieve Bank Account Details

  Scenario: Successful Account Details Retrieval
    Given an account with account number "1234567890"
    And the IFSC code is "SBIN0000001"
    And the password is "Password123"
    When I request account details using the GET /finance/v1/bank/v4/bharat/get-account-details/{accountNumber}/{IFSCCode}/{password} endpoint
    Then the response status code should be 202
    And the response should contain the account details

  Scenario: Account Not Found - Incorrect Account Number
    Given an account with account number "9876543210"  
    And the IFSC code is "SBIN0000001"
    And the password is "Password123"
    When I request account details using the GET /finance/v1/bank/v4/bharat/get-account-details/{accountNumber}/{IFSCCode}/{password} endpoint
    Then the response status code should be 403
    And the response should indicate that the account was not found

  Scenario: Account Not Found - Incorrect IFSC Code
    Given an account with account number "1234567890"
    And the IFSC code is "WrongIFSC"
    And the password is "Password123"
    When I request account details using the GET /finance/v1/bank/v4/bharat/get-account-details/{accountNumber}/{IFSCCode}/{password} endpoint
    Then the response status code should be 403
    And the response should indicate that the account was not found


  Scenario: Account Not Found - Incorrect Password
    Given an account with account number "1234567890"
    And the IFSC code is "SBIN0000001"
    And the password is "WrongPassword"
    When I request account details using the GET /finance/v1/bank/v4/bharat/get-account-details/{accountNumber}/{IFSCCode}/{password} endpoint
    Then the response status code should be 403
    And the response should indicate that the account was not found


  Scenario: Account Not Found - All Incorrect Credentials
    Given an incorrect account number "9876543210"
    And an incorrect IFSC code "WrongIFSC"
    And an incorrect password "WrongPassword"
    When I request account details using the GET /finance/v1/bank/v4/bharat/get-account-details/{accountNumber}/{IFSCCode}/{password} endpoint
    Then the response status code should be 403
    And the response should indicate that the account was not found

  Scenario Outline:  Account Details Retrieval with different valid inputs
    Given an account with account number "<accountNumber>"
    And the IFSC code is "<IFSCCode>"
    And the password is "<password>"
    When I request account details using the GET /finance/v1/bank/v4/bharat/get-account-details/{accountNumber}/{IFSCCode}/{password} endpoint
    Then the response status code should be 202
    And the response should contain the account details

    Examples:
      | accountNumber | IFSCCode     | password     |
      | 1234567890    | SBIN0000001  | Password123  |
      | 0987654321    | SBIN0000002  | SecurePass1  |

Feature: Balance Enquiry

  Scenario: Successful Balance Enquiry
    Given an existing account with valid account number, IFSC code, and password
    When a balance enquiry request is made
    Then the API should return a 202 status code
    And the response should contain the account balance in "BalanceEnquiryResponse" format

  Scenario: Account Not Found
    Given an account with an invalid account number or IFSC code or password
    When a balance enquiry request is made
    Then the API should return a 403 status code
    And the response should contain an error message in "ErrorResponses" format

  Scenario: Account Number Missing
    Given a balance enquiry request is made without an account number
    When the API is called
    Then the API should return an error indicating a missing account number

  Scenario: IFSC Code Missing
    Given a balance enquiry request is made without an IFSC code
    When the API is called
    Then the API should return an error indicating a missing IFSC code

  Scenario: Password Missing
    Given a balance enquiry request is made without a password
    When the API is called
    Then the API should return an error indicating a missing password


  Scenario Outline: Invalid Input - Various Error Conditions
    Given a balance enquiry request is made with an <invalid_input>
    When the API is called
    Then the API should return a 403 status code
    And the response should contain an appropriate error message

    Examples:
      | invalid_input |
      | Invalid Account Number |
      | Invalid IFSC Code |
      | Invalid Password |
      | Empty Account Number |
      | Empty IFSC Code |
      | Empty Password |


  Scenario: System Error - Handling Dependencies Failure
    Given the "AccountDetailsRepositories" dependency fails
    When a balance enquiry request is made with valid credentials
    Then the API should return an appropriate error message indicating a system failure.


  Scenario: System Error - Handling Notifications Failure
    Given the "NotificationsUtility" dependency fails
    When a balance enquiry request is made with valid credentials
    Then the API should return a 202 status code and the balance enquiry should be processed successfully.  #We assume notification is not critical to the primary function.

Feature: Credit Money to Account

  Scenario: Successful Money Credit
    Given a valid "creditCredential" object with sufficient account balance
    And the account number, IFSC code, and password are correct
    And the daily transaction limit has not been reached
    When a GET request is sent to "/finance/v1/bank/v4/bharat/credit-money" with the "creditCredential" object
    Then the response status code should be 202
    And the response body should be a valid "CreditResponse" object

  Scenario: Account Not Found
    Given a "creditCredential" object with an invalid account number
    When a GET request is sent to "/finance/v1/bank/v4/bharat/credit-money" with the "creditCredential" object
    Then the response status code should be 403
    And the response body should be a valid "ErrorResponses" object
    And the response body should indicate "Account not found"

  Scenario: Insufficient Balance
    Given a valid "creditCredential" object with insufficient account balance
    And the account number, IFSC code, and password are correct
    When a GET request is sent to "/finance/v1/bank/v4/bharat/credit-money" with the "creditCredential" object
    Then the response status code should be 403
    And the response body should be a valid "ErrorResponses" object
    And the response body should indicate "Insufficient balance"

  Scenario: Incorrect Password
    Given a valid "creditCredential" object with an incorrect password
    When a GET request is sent to "/finance/v1/bank/v4/bharat/credit-money" with the "creditCredential" object
    Then the response status code should be 403
    And the response body should be a valid "ErrorResponses" object
    And the response body should indicate an authentication error

  Scenario: Daily Transaction Limit Reached
    Given a valid "creditCredential" object with sufficient balance
    And the account number, IFSC code, and password are correct
    And the daily transaction limit has been reached
    When a GET request is sent to "/finance/v1/bank/v4/bharat/credit-money" with the "creditCredential" object
    Then the response status code should be 403
    And the response body should be a valid "ErrorResponses" object
    And the response body should indicate that the daily transaction limit has been reached


  Scenario Outline: Handling Invalid CreditCredential Objects
    Given a "creditCredential" object with <invalid_field>
    When a GET request is sent to "/finance/v1/bank/v4/bharat/credit-money" with the "creditCredential" object
    Then the response status code should be 403
    And the response body should be a valid "ErrorResponses" object

    Examples:
      | invalid_field          |
      | missing account number |
      | invalid IFSC code      |
      | missing password       |
      | invalid amount         |

Feature: Debit Money from Account

  Scenario: Successful Debit
    Given a valid debitCredential with sufficient balance
    When a debit request is made using the `/finance/v1/bank/v4/bharat/debit-money` endpoint
    Then the response status code should be 202
    And the response should match the "DebitedResponse" schema

  Scenario: Insufficient Balance
    Given a valid debitCredential with insufficient balance
    When a debit request is made using the `/finance/v1/bank/v4/bharat/debit-money` endpoint
    Then the response status code should be 403
    And the response should match the "ErrorResponses" schema
    And the response body should contain an error message indicating insufficient balance

  Scenario: Invalid Account Number
    Given a debitCredential with an invalid account number
    When a debit request is made using the `/finance/v1/bank/v4/bharat/debit-money` endpoint
    Then the response status code should be 403
    And the response should match the "ErrorResponses" schema
    And the response body should contain an error message indicating an invalid account number

  Scenario: Invalid IFSC Code
    Given a debitCredential with an invalid IFSC code
    When a debit request is made using the `/finance/v1/bank/v4/bharat/debit-money` endpoint
    Then the response status code should be 403
    And the response should match the "ErrorResponses" schema
    And the response body should contain an error message indicating an invalid IFSC code

  Scenario: Incorrect Password
    Given a debitCredential with an incorrect password
    When a debit request is made using the `/finance/v1/bank/v4/bharat/debit-money` endpoint
    Then the response status code should be 403
    And the response should match the "ErrorResponses" schema
    And the response body should contain an error message indicating an incorrect password

  Scenario: Daily Transaction Limit Exceeded
    Given a valid debitCredential with sufficient balance but daily transaction limit exceeded
    When a debit request is made using the `/finance/v1/bank/v4/bharat/debit-money` endpoint
    Then the response status code should be 403
    And the response should match the "ErrorResponses" schema
    And the response body should contain an error message indicating daily transaction limit exceeded


  Scenario: High Value Transaction - Notification Sent
    Given a valid debitCredential with sufficient balance and a high value transaction amount
    When a debit request is made using the `/finance/v1/bank/v4/bharat/debit-money` endpoint
    Then the response status code should be 202
    And the response should match the "DebitedResponse" schema
    And a notification should be sent (This step may require mocking the NotificationsUtility dependency)


  Scenario: Missing DebitCredential
    When a debit request is made using the `/finance/v1/bank/v4/bharat/debit-money` endpoint without debitCredential
    Then the response status code should be 400  // Assuming a bad request
    And the response should contain an error message indicating missing debitCredential

Feature: Make UPI Payment

  Scenario: Successful UPI Payment
    Given a user with a valid account and sufficient balance
    And a valid UPI ID is provided
    When the user initiates a UPI payment
    Then the payment should be successful
    And a 202 status code should be returned
    And the response should contain the payment details


  Scenario: Insufficient Funds
    Given a user with a valid account and insufficient balance
    And a valid UPI ID is provided
    When the user initiates a UPI payment
    Then the payment should fail
    And a 403 status code should be returned
    And the error response should indicate insufficient balance


  Scenario: Invalid UPI ID
    Given a user with a valid account and sufficient balance
    And an invalid UPI ID is provided
    When the user initiates a UPI payment
    Then the payment should fail
    And a 403 status code should be returned
    And the error response should indicate an invalid UPI ID


  Scenario: Invalid Account Number
    Given a user with an invalid account number and sufficient balance
    And a valid UPI ID is provided
    When the user initiates a UPI payment
    Then the payment should fail
    And a 403 status code should be returned
    And the error response should indicate an invalid account number


  Scenario: Account Limit Reached
    Given a user with a valid account and sufficient balance but account limit reached.
    And a valid UPI ID is provided
    When the user initiates a UPI payment
    Then the payment should fail
    And a 403 status code should be returned
    And the error response should indicate account limit reached


  Scenario Outline:  Payment with various amounts
    Given a user with a valid account and a balance of <balance>
    And a valid UPI ID is provided
    When the user initiates a UPI payment of <amount>
    Then the payment should <result>
    And a <status_code> status code should be returned

    Examples:
      | balance | amount | result      | status_code |
      | 500     | 100    | be successful | 202         |
      | 100     | 200    | fail         | 403         |
      | 1000    | 500    | be successful | 202         |

Feature: Add Money to UPI from Bank Account

  Scenario: Successful Money Transfer to UPI
    Given a valid bank account with sufficient balance
    And a valid UPI ID
    And a correct account password
    When the user requests to add 100 USD to the UPI ID from the bank account
    Then the API returns a 202 status code
    And the API returns an AddMoneyToUPIFromAccountResponse indicating successful transaction

  Scenario: Insufficient Funds in Bank Account
    Given a valid bank account with insufficient balance
    And a valid UPI ID
    And a correct account password
    When the user requests to add 100 USD to the UPI ID from the bank account
    Then the API returns an error response (status code other than 202)
    And the error message indicates insufficient funds

  Scenario: Invalid Bank Account Number
    Given an invalid bank account number
    And a valid UPI ID
    And a correct account password (assuming password check happens after account validation)
    When the user requests to add 100 USD to the UPI ID from the bank account
    Then the API returns a 403 status code
    And the error message indicates an invalid account number or UPI not found

  Scenario: Invalid UPI ID
    Given a valid bank account with sufficient balance
    And an invalid UPI ID
    And a correct account password
    When the user requests to add 100 USD to the UPI ID from the bank account
    Then the API returns a 403 status code
    And the error message indicates an invalid account number or UPI not found

  Scenario: Incorrect Account Password
    Given a valid bank account with sufficient balance
    And a valid UPI ID
    And an incorrect account password
    When the user requests to add 100 USD to the UPI ID from the bank account
    Then the API returns an error response (status code other than 202)
    And the error message indicates an incorrect password


  Scenario: Account Limit Reached
    Given a valid bank account with sufficient balance
    And a valid UPI ID
    And a correct account password
    And the account has reached its daily/monthly transfer limit
    When the user requests to add 100 USD to the UPI ID from the bank account
    Then the API returns an error response (status code other than 202)
    And the error message indicates that the account limit has been reached.


  Scenario Outline:  Testing various amounts
    Given a valid bank account with sufficient balance of <balance> USD
    And a valid UPI ID
    And a correct account password
    When the user requests to add <amount> USD to the UPI ID from the bank account
    Then the API returns a 202 status code
    And the API returns an AddMoneyToUPIFromAccountResponse indicating successful transaction

    Examples:
      | balance | amount |
      | 200     | 100    |
      | 500     | 400    |
      | 1000    | 50     |

Feature: Manually Update Account Balance

  Scenario: Successful Manual Balance Update
    Given an account with account number "1234567890" exists
    And the current balance is 500 USD
    When a manual update is requested with an amount of 100 USD
    Then the API should return a 202 status code
    And the response should be a valid "UpdateAmountResponse"
    And the new account balance should be 600 USD

  Scenario: Manual Balance Update with Invalid Account Number
    Given an account with account number "9876543210" does not exist
    When a manual update is requested with an amount of 100 USD
    Then the API should return a 403 status code
    And the response should be a valid "ErrorResponses"
    And the error message should indicate "Account not found"

  Scenario: Manual Balance Update with Negative Amount
    Given an account with account number "1234567890" exists
    And the current balance is 500 USD
    When a manual update is requested with an amount of -100 USD  
    Then the API should return a 400 status code  #(Assuming a 400 for bad request - this should be clarified in the API documentation)
    And the response should be a valid "ErrorResponses"
    And the error message should indicate an invalid amount.


  Scenario: Manual Balance Update exceeding limits (Example)
    Given an account with account number "1234567890" exists
    And the current balance is 500 USD
    And the daily deposit limit is 500 USD
    When a manual update is requested with an amount of 600 USD
    Then the API should return a 400 status code #(Assuming a 400 for exceeding limits - this should be clarified in the API documentation)
    And the response should be a valid "ErrorResponses"
    And the error message should indicate exceeding the daily deposit limit.


  Scenario Outline: Manual Balance Update with various amounts
    Given an account with account number "1234567890" exists
    And the current balance is 500 USD
    When a manual update is requested with an amount of <amount> USD
    Then the API should return a 202 status code
    And the new account balance should be <new_balance> USD

    Examples:
      | amount | new_balance |
      | 100    | 600         |
      | 250    | 750         |
      | 0      | 500         |


Note:  These scenarios assume the existence of  `UpdateAmountResponse` and `ErrorResponses` schemas and  appropriate error handling within the API. The specific error codes and messages (e.g., 400 for invalid input) should be verified against the actual API implementation and documentation.  The scenario about exceeding limits is an example and needs to be adapted to the actual limitations of the API.

Feature: Create UPI ID

  Scenario: Successful UPI ID Creation
    Given a user with an existing account and a NetBanking ID
    And the user does not have an existing UPI ID
    When the user requests a UPI ID creation via POST request to "/finance/upi/v1/upi-create" with a valid UPIRequest payload
    Then the API should respond with status code 202
    And the response should be a valid UPIResponse object
    And a new UPI ID should be generated and associated with the user's account

  Scenario: Account Not Found
    Given a user with a non-existent account
    When the user requests a UPI ID creation via POST request to "/finance/upi/v1/upi-create" with a valid UPIRequest payload
    Then the API should respond with status code 403
    And the response should be a valid ErrorResponses object
    And the response should indicate that the account was not found

  Scenario: UPI ID Already Exists
    Given a user with an existing account, a NetBanking ID, and an existing UPI ID
    When the user requests a UPI ID creation via POST request to "/finance/upi/v1/upi-create" with a valid UPIRequest payload
    Then the API should respond with status code 403
    And the response should be a valid ErrorResponses object
    And the response should indicate that the UPI ID already exists

  Scenario: Missing NetBanking ID
    Given a user with an existing account and no NetBanking ID
    When the user requests a UPI ID creation via POST request to "/finance/upi/v1/upi-create" with a valid UPIRequest payload
    Then the API should respond with status code 403
    And the response should be a valid ErrorResponses object
    And the response should indicate that the NetBanking ID is missing

  Scenario: Invalid UPIRequest Payload
    Given a user with an existing account and a NetBanking ID
    When the user requests a UPI ID creation via POST request to "/finance/upi/v1/upi-create" with an invalid UPIRequest payload
    Then the API should respond with a status code indicating an error (e.g., 400 Bad Request)
    And the response should contain details about the validation error.


  Scenario: System Error during UPI Creation
    Given a user with an existing account and a NetBanking ID
    And the UPIDGenerater service is temporarily unavailable
    When the user requests a UPI ID creation via POST request to "/finance/upi/v1/upi-create" with a valid UPIRequest payload
    Then the API should respond with a status code indicating a server error (e.g., 500 Internal Server Error)

Feature: Retrieve UPI Details

  Scenario: Successful UPI Details Retrieval
    Given a valid UPI request is submitted
    When the API endpoint "/finance/upi/v1/get-upi-details" is called with the request
    Then the API should return a 202 status code
    And the response should be a valid UPIResponse object
    And the response should contain the UPI details

  Scenario: UPI Details Not Found
    Given an invalid UPI request is submitted (e.g., incorrect account number or password)
    When the API endpoint "/finance/upi/v1/get-upi-details" is called with the request
    Then the API should return a 403 status code
    And the response should be a valid ErrorResponses object
    And the response should contain an appropriate error message indicating that the details were not found

  Scenario: Invalid Request Format
    Given an invalid request format is submitted (e.g., missing required fields in the GetUPIRequest)
    When the API endpoint "/finance/upi/v1/get-upi-details" is called with the request
    Then the API should return an appropriate error status code (e.g., 400 Bad Request)
    And the response should contain an error message describing the invalid request format


  Scenario Outline:  Handling Different Error Conditions <error_code> <error_message>
    Given a request that will trigger error <error_code>
    When the API endpoint "/finance/upi/v1/get-upi-details" is called with the request
    Then the API should return status code <error_code>
    And the response should contain an error message including "<error_message>"

    Examples:
      | error_code | error_message |
      | 403        | Details not found |
      | 400        | Invalid request format |
      | 500        | Internal Server Error |  #(Example of a potential server-side error)


  Scenario:  System under high load.
    Given the system is under a high load of requests
    When the API endpoint "/finance/upi/v1/get-upi-details" is called with a valid request
    Then the API should respond within an acceptable timeframe (e.g., under 2 seconds)
    And the response should be a valid UPIResponse object


These scenarios cover successful retrieval, various error conditions, and performance considerations.  Remember to define the `GetUPIRequest` and `UPIResponse` and `ErrorResponses` schemas appropriately for more detailed test cases.

Feature: NetBanking ID Creation

  Scenario: Successful NetBanking ID Creation
    Given an existing account with ID "12345"
    And the account has not already been linked to NetBanking
    When a NetBanking ID creation request is submitted for account ID "12345"
    Then the response status code should be 202
    And the response should contain a valid NetBanking ID
    And a notification should be sent to the account holder

  Scenario: NetBanking ID Creation Failure - Account Not Found
    Given an account with ID "67890" does not exist
    When a NetBanking ID creation request is submitted for account ID "67890"
    Then the response status code should be 403
    And the response should contain an error message indicating the account was not found

  Scenario: NetBanking ID Creation Failure - ID Already Exists
    Given an existing account with ID "12345"
    And the account is already linked to NetBanking with ID "NB12345"
    When a NetBanking ID creation request is submitted for account ID "12345"
    Then the response status code should be 403
    And the response should contain an error message indicating the NetBanking ID already exists

  Scenario: NetBanking ID Creation Failure - Invalid Request
    Given an invalid NetBanking creation request
    When a NetBanking ID creation request is submitted
    Then the response status code should be 4XX  //More specific error code could be added if known.
    And the response should contain an error message indicating the request was invalid


  Scenario Outline: NetBanking ID Creation with different Account Statuses <Account Status>
    Given an account with ID "98765" and status <Account Status>
    When a NetBanking ID creation request is submitted for account ID "98765"
    Then the response status code should be <Response Code>
    And the response message should indicate <Message>

    Examples:
    | Account Status | Response Code | Message                                   |
    | Active         | 202            | NetBanking ID created successfully          |
    | Suspended      | 403            | Account is suspended, cannot create NetBanking ID |
    | Closed         | 403            | Account is closed, cannot create NetBanking ID   |


  Scenario:  Successful NetBanking ID Creation - Verify Dependencies
    Given an existing account with ID "12345"
    And the AccountDetailsRepositories, NetBankingRepositories, InternetBankingIdGenerator, and NotificationsUtility are functioning correctly
    When a NetBanking ID creation request is submitted for account ID "12345"
    Then the response status code should be 202
    And the NetBanking ID should be generated correctly
    And the ID should be persisted in NetBankingRepositories
    And a notification should be sent successfully using NotificationsUtility


These scenarios cover various aspects of the API, including successful and unsuccessful cases, error handling, and dependency verification.  The use of Scenario Outlines allows for efficient testing of different account statuses.  More specific error codes can be added if the API documentation provides them.

Feature: Retrieve NetBanking Details

  Scenario: Successful NetBanking Details Retrieval
    Given a valid "netBankingRequest" with a matching account number and IFSC code
    When a GET request is sent to "/finance/v1/banking/get-internetBanking-details" with the valid "netBankingRequest"
    Then the response status code should be 202
    And the response should be a valid "NetBankingResponse" object

  Scenario: NetBanking Details Not Found
    Given a "netBankingRequest" with an invalid account number or IFSC code
    When a GET request is sent to "/finance/v1/banking/get-internetBanking-details" with the invalid "netBankingRequest"
    Then the response status code should be 403
    And the response should be a valid "ErrorResponses" object

  Scenario: Missing Required Parameter
    When a GET request is sent to "/finance/v1/banking/get-internetBanking-details" without the "netBankingRequest" parameter
    Then the response should indicate a missing required parameter.  *(Note:  The specific HTTP status code and error message will depend on the API implementation.)*


  Scenario Outline:  Testing Various Invalid Inputs
    Given a "netBankingRequest" with an invalid <input_type>
    When a GET request is sent to "/finance/v1/banking/get-internetBanking-details" with the invalid "netBankingRequest"
    Then the response status code should be 403
    And the response should be a valid "ErrorResponses" object

    Examples:
      | input_type |
      | Account Number (too short) |
      | Account Number (invalid characters) |
      | IFSC Code (invalid format) |
      | IFSC Code (non-existent) |


  Scenario:  Error Handling for Unforeseen Exceptions  *(Note: This scenario tests robustness)*
      Given a "netBankingRequest" with a valid account number and IFSC code
      When a GET request is sent to "/finance/v1/banking/get-internetBanking-details" with the valid "netBankingRequest" and the `NetBankingRepositories` is temporarily unavailable
      Then the response should indicate a server error  *(Note: The specific HTTP status code and error message will depend on the API implementation.)*


These scenarios cover successful retrieval, various failure cases due to invalid input,  missing parameters, and also consider error handling for situations outside the explicitly defined error responses, which is important for robust BDD.  The specific error messages and HTTP status codes in the "Then" clauses need to be defined based on the actual API implementation.

Feature: Fetch Transaction History

  Scenario: Successful Transaction History Retrieval
    Given an account with account number "1234567890" exists
    When a GET request is sent to "/transaction/v1/fetch/transaction-enquiry/1234567890"
    Then the response status code should be 202
    And the response body should be a list of TransactionResponse objects

  Scenario: Account Not Found
    Given an account with account number "9876543210" does NOT exist
    When a GET request is sent to "/transaction/v1/fetch/transaction-enquiry/9876543210"
    Then the response status code should be 403
    And the response body should be an ErrorResponses object

  Scenario: Invalid Account Number Format
    Given an invalid account number "abcdefg"
    When a GET request is sent to "/transaction/v1/fetch/transaction-enquiry/abcdefg"
    Then the response status code should be 403  # Or potentially a different error code depending on the implementation.  Consider adding a specific error code in the API spec.
    And the response body should contain an error message indicating invalid account number format.


  Scenario: Empty Transaction History
    Given an account with account number "1122334455" exists and has no transactions
    When a GET request is sent to "/transaction/v1/fetch/transaction-enquiry/1122334455"
    Then the response status code should be 202
    And the response body should be an empty list of TransactionResponse objects


  Scenario Outline:  Handling Different Account Numbers
    Given an account with account number "<accountNumber>" exists
    When a GET request is sent to "/transaction/v1/fetch/transaction-enquiry/<accountNumber>"
    Then the response status code should be 202

    Examples:
      | accountNumber |
      | 1234567890    |
      | 0987654321    |

Feature: Money Transfer API

  Scenario: Successful Money Transfer
    Given a sender account with sufficient balance exists
    And a recipient account exists
    When a transfer of 100 USD is requested from the sender to the recipient
    Then the transfer should be successful
    And a 202 status code is returned
    And a TransferMoneyResponse is returned

  Scenario: Insufficient Funds
    Given a sender account with insufficient balance exists
    And a recipient account exists
    When a transfer of 1000 USD is requested from the sender to the recipient
    Then the transfer should fail
    And a 403 status code is returned
    And an ErrorResponse is returned
    And the error message should indicate insufficient funds

  Scenario: Sender Account Not Found
    Given a sender account does not exist
    And a recipient account exists
    When a transfer of 100 USD is requested from the sender to the recipient
    Then the transfer should fail
    And a 403 status code is returned
    And an ErrorResponse is returned
    And the error message should indicate sender account not found

  Scenario: Recipient Account Not Found
    Given a sender account with sufficient balance exists
    And a recipient account does not exist
    When a transfer of 100 USD is requested from the sender to the recipient
    Then the transfer should fail
    And a 403 status code is returned
    And an ErrorResponse is returned
    And the error message should indicate recipient account not found


  Scenario: High-Value Transfer Notification
    Given a sender account with sufficient balance exists
    And a recipient account exists
    When a transfer of 10000 USD is requested from the sender to the recipient
    Then the transfer should be successful
    And a 202 status code is returned
    And a TransferMoneyResponse is returned
    And a notification should be sent


  Scenario: Invalid Transfer Amount (Negative)
    Given a sender account with sufficient balance exists
    And a recipient account exists
    When a transfer of -100 USD is requested from the sender to the recipient
    Then the transfer should fail
    And a 403 status code or other appropriate error code is returned
    And an ErrorResponse is returned
    And the error message should indicate an invalid transfer amount.


  Scenario: Invalid Transfer Amount (Zero)
    Given a sender account with sufficient balance exists
    And a recipient account exists
    When a transfer of 0 USD is requested from the sender to the recipient
    Then the transfer should fail
    And a 403 status code or other appropriate error code is returned
    And an ErrorResponse is returned
    And the error message should indicate an invalid transfer amount.