```java
import io.cucumber.java.After;
import io.cucumber.java.Before;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import io.restassured.response.Response;

import java.util.Map;

public class StepDefinitions {

    private Response response;
    private Requests requests;


    @Before
    public void setUp() {
        requests = new Requests(); // Assuming Requests class handles API calls
        System.out.println("Setup complete");
    }

    @After
    public void tearDown() {
        System.out.println("Tear down complete");
    }


    //Feature: Create Bank Account
    @Given("a user provides valid account details including a unique email and phone number")
    public void userProvidesValidAccountDetails() {
        System.out.println("Given: User provides valid account details");
        //  Implement logic to create a valid User object
    }

    @When("the user sends a POST request to \\\"/finance/v1/bank/v4/bharat/create-account\\\" with the user details")
    public void userSendsPostRequest( ) {
        System.out.println("When: User sends POST request to /finance/v1/bank/v4/bharat/create-account");
        // Assuming you have a User object created in the previous step.  Replace with your actual User object creation.
        response = requests.post("/finance/v1/bank/v4/bharat/create-account", /*Your User Object*/ null);
    }

    @Then("the response status code should be {int}")
    public void responseStatusCodeShouldBe(int statusCode) {
        System.out.println("Then: Response status code should be " + statusCode);
        if(response == null) {
            throw new RuntimeException("Response is null.  Check previous steps.");
        }
        int actualStatusCode = response.getStatusCode();
        assert actualStatusCode == statusCode : "Expected status code: " + statusCode + ", Actual status code: " + actualStatusCode;
    }


    @And("the response should contain the newly created account details \\(UserResponse\\)")
    public void responseShouldContainNewlyCreatedAccountDetails() {
        System.out.println("And: Response should contain newly created account details");
        // Add assertions to validate UserResponse schema
        // Example using JSON Schema validation (requires a JSON schema library)
        // JsonSchemaValidator.matchesJsonSchemaInClasspath( "path/to/schema.json", response.getBody().asString());
    }

    @Given("a user provides account details with an email address that already exists")
    public void userProvidesAccountDetailsWithEmailThatAlreadyExists() {
        System.out.println("Given: User provides account details with duplicate email");
        // Implement logic to create a User object with a duplicate email
    }

    @Given("a user provides account details with a phone number that already exists")
    public void userProvidesAccountDetailsWithPhoneNumberThatAlreadyExists() {
        System.out.println("Given: User provides account details with duplicate phone number");
        // Implement logic to create a User object with a duplicate phone number
    }

    @Given("a user provides incomplete account details, missing a required field \\(e.g., email\\)")
    public void userProvidesIncompleteAccountDetails() {
        System.out.println("Given: User provides incomplete account details");
        // Implement logic to create a User object with missing required fields
    }

    @Given("a user provides valid account details")
    public void userProvidesValidAccountDetails2() {
        System.out.println("Given: User provides valid account details");
    }

    @Then("the response should contain a newly generated account number")
    public void responseShouldContainANewlyGeneratedAccountNumber() {
        System.out.println("Then: Response should contain a newly generated account number");
        // Add assertions to validate account number generation and uniqueness
    }

    @And("the account number should not be provided by the user in the request")
    public void accountNumberShouldNotBeProvidedByUserInRequest() {
        System.out.println("And: Account number should not be provided by user in request");
    }


    @Given("a user provides valid account details with {string} for {string}")
    public void userProvidesValidAccountDetailsWithStringFor(String dataType, String field) {
        System.out.println("Given: User provides valid account details with " + dataType + " for " + field);
    }

    @Given("a user provides account details with an invalid {string} of type {string}")
    public void userProvidesAccountDetailsWithInvalidOfType(String field, String dataType) {
        System.out.println("Given: User provides account details with an invalid " + field + " of type " + dataType);
    }

    @Then("the response status code should not be {int}")
    public void theResponseStatusCodeShouldNotBe(int statusCode) {
        System.out.println("Then: Response status code should not be " + statusCode);
        assert response.getStatusCode() != statusCode : "Response status code should not be " + statusCode;
    }

    @And("the response should include an error message indicating the invalid input")
    public void theResponseShouldIncludeAnErrorMessageIndicatingTheInvalidInput() {
        System.out.println("And: The response should include an error message");
        // Add assertions to validate error message content
    }

    //Feature: Update Bank Account Details

    @Given("an existing bank account with account number {string} and IFSC code {string}")
    public void anExistingBankAccountWithAccountNumberAndIFSCCode(String accountNumber, String ifscCode) {
        System.out.println("Given: Existing bank account with account number " + accountNumber + " and IFSC code " + ifscCode);
    }

    @And("the user provides valid updated details including account name {string} and mobile number {string}")
    public void theUserProvidesValidUpdatedDetailsIncludingAccountNameAndMobileNumber(String accountName, String mobileNumber) {
        System.out.println("And: User provides valid updated details");
    }

    @When("the user sends a PUT request to \\\"/finance/v1/bank/v4/bharat/update-account-details\\\" with the updated details")
    public void theUserSendsAPUTRequestToWithTheUpdatedDetails() {
        System.out.println("When: User sends PUT request");
        response = requests.put("/finance/v1/bank/v4/bharat/update-account-details", null); // Replace null with updated details object
    }

    @And("the response body should match the expected AccountUpdateDetailsResponse schema")
    public void theResponseBodyShouldMatchTheExpectedAccountUpdateDetailsResponseSchema() {
        System.out.println("And: Response body should match schema");
        // Add schema validation here
    }

    @And("a successful update notification should be sent")
    public void aSuccessfulUpdateNotificationShouldBeSent() {
        System.out.println("And: Successful update notification sent");
    }

    @Given("a non-existent bank account with account number {string} and IFSC code {string}")
    public void aNonExistentBankAccountWithAccountNumberAndIFSCCode(String accountNumber, String ifscCode) {
        System.out.println("Given: Non-existent bank account");
    }

    @And("the user provides updated details")
    public void theUserProvidesUpdatedDetails() {
        System.out.println("And: User provides updated details");
    }

    @When("the user sends a PUT request to \\\"/finance/v1/bank/v4/bharat/update-account-details\\\" with the incorrect details")
    public void theUserSendsAPUTRequestToWithTheIncorrectDetails() {
        System.out.println("When: User sends PUT request with incorrect details");
        response = requests.put("/finance/v1/bank/v4/bharat/update-account-details", null); // Replace null with incorrect details
    }


    @And("the response body should match the expected ErrorResponses schema")
    public void theResponseBodyShouldMatchTheExpectedErrorResponsesSchema() {
        System.out.println("And: Response body matches ErrorResponses schema");
        // Add schema validation
    }


    @And("an error notification \\(if applicable\\) should be sent")
    public void anErrorNotificationIfApplicableShouldBeSent() {
        System.out.println("And: Error notification sent (if applicable)");
    }

    @And("the user provides updated details with an incorrect IFSC code {string}")
    public void theUserProvidesUpdatedDetailsWithAnIncorrectIFSCCode(String ifscCode) {
        System.out.println("And: User provides updated details with incorrect IFSC code: " + ifscCode);
    }

    @When("the user sends a PUT request to \\\"/finance/v1/bank/v4/bharat/update-account-details\\\" with the incorrect IFSC code")
    public void theUserSendsAPUTRequestToWithTheIncorrectIFSCCode() {
        System.out.println("When: User sends PUT request with incorrect IFSC code");
        response = requests.put("/finance/v1/bank/v4/bharat/update-account-details", null); // Replace null with updated details object containing incorrect IFSC code.
    }

    @And("the user provides updated details missing the account number")
    public void theUserProvidesUpdatedDetailsMissingTheAccountNumber() {
        System.out.println("And: User provides updated details missing account number");
    }

    @When("the user sends a PUT request to \\\"/finance/v1/bank/v4/bharat/update-account-details\\\" with missing account number")
    public void theUserSendsAPUTRequestToWithMissingAccountNumber() {
        System.out.println("When: User sends PUT request with missing account number");
        response = requests.put("/finance/v1/bank/v4/bharat/update-account-details", null); // Replace null with updated details object missing account number.
    }


    @And("the response body should indicate the missing account number")
    public void theResponseBodyShouldIndicateTheMissingAccountNumber() {
        System.out.println("And: Response indicates missing account number");
        // Add assertion to validate error message
    }

    @Given("an existing bank account with account number {string} and IFSC code {string}")
    public void anExistingBankAccountWithAccountNumberAndIFSCCode(String arg0, String arg1) {
        // Write code here that turns the phrase above into concrete actions
    }

    @And("the user provides updated details with {string}")
    public void theUserProvidesUpdatedDetailsWith(String invalidData) {
        // Write code here that turns the phrase above into concrete actions
        System.out.println("And: User provides updated details with invalid data: " + invalidData);
    }

    @When("the user sends a PUT request to \\\"/finance/v1/bank/v4/bharat/update-account-details\\\" with the invalid data")
    public void theUserSendsAPUTRequestToWithTheInvalidData() {
        System.out.println("When: User sends PUT request with invalid data");
        response = requests.put("/finance/v1/bank/v4/bharat/update-account-details", null); // Replace null with updated details object with invalid data
    }

    @And("the response body should indicate the data type error")
    public void theResponseBodyShouldIndicateTheDataTypeError() {
        System.out.println("And: Response indicates data type error");
        // Add assertion to validate error message
    }


    //Feature: Delete Bank Account

    @Given("an existing account with account number {string} and password {string}")
    public void anExistingAccountWithAccountNumberAndPassword(String accountNumber, String password) {
        System.out.println("Given: Existing account with account number " + accountNumber + " and password " + password);
    }

    @When("the API endpoint \\\"/finance/v1/bank/v4/bharat/delete-account\\\" is called with a DELETE request and valid \\\"accountDetailsRequest\\\"")
    public void theApiEndpointIsCalledWithADeleteRequestAndValidAccountDetailsRequest() {
        System.out.println("When: DELETE request sent to /finance/v1/bank/v4/bharat/delete-account");
        response = requests.delete("/finance/v1/bank/v4/bharat/delete-account", null);  //Replace null with accountDetailsRequest object
    }


    @Then("the response status code should be {int}")
    public void theResponseStatusCodeShouldBe(int statusCode) {
        System.out.println("Then: Response status code should be " + statusCode);
        assert response.getStatusCode() == statusCode : "Expected status code: " + statusCode + ", Actual status code: " + response.getStatusCode();
    }

    @And("the response body should match the \\\"AccountDeletedSuccessResponse\\\" schema")
    public void theResponseBodyShouldMatchTheAccountDeletedSuccessResponseSchema() {
        System.out.println("And: Response body matches AccountDeletedSuccessResponse schema");
        // Add schema validation
    }

    @Given("an account with account number {string} and password {string} that does not exist")
    public void anAccountWithAccountNumberAndPasswordThatDoesNotExist(String accountNumber, String password) {
        System.out.println("Given: Non-existent account");
    }

    @When("the API endpoint \\\"/finance/v1/bank/v4/bharat/delete-account\\\" is called with a DELETE request and a valid \\\"accountDetailsRequest\\\" for the non-existent account")
    public void theApiEndpointIsCalledWithADeleteRequestAndAValidAccountDetailsRequestForTheNonExistentAccount() {
        System.out.println("When: DELETE request for non-existent account");
        response = requests.delete("/finance/v1/bank/v4/bharat/delete-account", null); //Replace null with accountDetailsRequest
    }

    @And("the response body should contain an error message indicating the account was not found")
    public void theResponseBodyShouldContainAnErrorMessageIndicatingTheAccountWasNotFound() {
        System.out.println("And: Error message indicates account not found");
        // Add assertion to check error message
    }

    @Given("an existing account with account number {string} and password {string}")
    public void anExistingAccountWithAccountNumberAndPassword(String accountNumber, String password) {
        System.out.println("Given: Existing account with account number " + accountNumber + " and password " + password);
    }

    @When("the API endpoint \\\"/finance/v1/bank/v4/bharat/delete-account\\\" is called with a DELETE request and a valid \\\"accountDetailsRequest\\\"")
    public void theApiEndpointIsCalledWithADeleteRequestAndAValidAccountDetailsRequest() {
        System.out.println("When: DELETE request sent");
        response = requests.delete("/finance/v1/bank/v4/bharat/delete-account", null); //Replace null with accountDetailsRequest
    }

    @And("the response body should contain an error message indicating incorrect password or similar")
    public void theResponseBodyShouldContainAnErrorMessageIndicatingIncorrectPasswordOrSimilar() {
        System.out.println("And: Error message indicates incorrect password");
        // Add assertion to check error message
    }

    @Given("an invalid \\\"accountDetailsRequest\\\" is provided")
    public void anInvalidAccountDetailsRequestIsProvided() {
        System.out.println("Given: Invalid accountDetailsRequest provided");
    }

    @When("the API endpoint \\\"/finance/v1/bank/v4/bharat/delete-account\\\" is called with a DELETE request and the invalid \\\"accountDetailsRequest\\\"")
    public void theApiEndpointIsCalledWithADeleteRequestAndTheInvalidAccountDetailsRequest() {
        System.out.println("When: DELETE request with invalid accountDetailsRequest");
        response = requests.delete("/finance/v1/bank/v4/bharat/delete-account", null); //Replace null with invalid accountDetailsRequest object
    }

    @Then("the response status code should be a non-2xx code \\(e.g., 400\\)")
    public void theResponseStatusCodeShouldBeANon2xxCodeEg() {
        System.out.println("Then: Response status code is a non-2xx code");
        int statusCode = response.getStatusCode();
        assert statusCode >= 400 || statusCode < 200 : "Expected non-2xx status code, but got: " + statusCode;
    }

    @And("the response body should contain an error message indicating invalid input")
    public void theResponseBodyShouldContainAnErrorMessageIndicatingInvalidInput() {
        System.out.println("And: Response contains error message indicating invalid input");
        // Add assertion to check error message
    }

    @Given("an account with account number {string} and password {string}")
    public void anAccountWithAccountNumberAndPassword(String accountNumber, String password) {
        System.out.println("Given: Account with account number " + accountNumber + " and password " + password);
    }

    @Then("the response status code should be {int}")
    public void theResponseStatusCodeShouldBe(Integer expectedStatusCode) {
        System.out.println("Then: Response status code should be " + expectedStatusCode);
        assert response.getStatusCode() == expectedStatusCode : "Expected status code: " + expectedStatusCode + ", Actual status code: " + response.getStatusCode();
    }

    @And("the response body should contain {string}")
    public void theResponseBodyShouldContain(String expectedMessage) {
        System.out.println("And: Response body should contain: " + expectedMessage);
        assert response.getBody().asString().contains(expectedMessage) : "Expected message not found in response body";
    }

    //Feature: Retrieve Bank Account Details
    @Given("an account with account number {string}")
    public void anAccountWithAccountNumber(String accountNumber) {
        System.out.println("Given: Account with account number " + accountNumber);
    }

    @And("the IFSC code is {string}")
    public void theIFSCCodeIs(String ifscCode) {
        System.out.println("And: IFSC code is " + ifscCode);
    }

    @And("the password is {string}")
    public void thePasswordIs(String password) {
        System.out.println("And: Password is " + password);
    }

    @When("I request account details using the GET {string} endpoint")
    public void iRequestAccountDetailsUsingTheGETEndpoint(String endpoint) {
        System.out.println("When: GET request sent to " + endpoint);
        String[] parts = endpoint.split("/");
        String accountNumber = parts[parts.length - 3];
        String ifscCode = parts[parts.length - 2];
        String password = parts[parts.length - 1];
        response = requests.get(endpoint, accountNumber, ifscCode, password);
    }

    @And("the response should contain the account details")
    public void theResponseShouldContainTheAccountDetails() {
        System.out.println("And: Response contains account details");
        //Add assertions here to validate the content of the account details
    }

    @And("the response should indicate that the account was not found")
    public void theResponseShouldIndicateThatTheAccountWasNotFound() {
        System.out.println("And: Response indicates account not found");
        // Add assertions to validate error message
    }

    @Given("an incorrect account number {string}")
    public void anIncorrectAccountNumber(String accountNumber) {
        System.out.println("Given: Incorrect account number " + accountNumber);
    }

    @Given("an incorrect IFSC code {string}")
    public void anIncorrectIFSCCode(String ifscCode) {
        System.out.println("Given: Incorrect IFSC code " + ifscCode);
    }

    @Given("an incorrect password {string}")
    public void anIncorrectPassword(String password) {
        System.out.println("Given: Incorrect password " + password);
    }


    //Feature: Balance Enquiry


    @Given("an existing account with valid account number, IFSC code, and password")
    public void anExistingAccountWithValidAccountNumberIFSCCodeAndPassword() {
        System.out.println("Given: Existing account with valid credentials");
    }

    @When("a balance enquiry request is made")
    public void aBalanceEnquiryRequestIsMade() {
        System.out.println("When: Balance enquiry request made");
        response = requests.getBalance(null); // replace null with valid request object
    }

    @Then("the API should return a {int} status code")
    public void theAPIShouldReturnAStatusCode(int statusCode) {
        System.out.println("Then: API returns status code " + statusCode);
        assert response.getStatusCode() == statusCode;
    }

    @And("the response should contain the account balance in \\\"BalanceEnquiryResponse\\\" format")
    public void theResponseShouldContainTheAccountBalanceInBalanceEnquiryResponseFormat() {
        System.out.println("And: Response contains account balance");
        // Add schema validation here
    }

    @Given("an account with an invalid account number or IFSC code or password")
    public void anAccountWithAnInvalidAccountNumberOrIFSCCodeOrPassword() {
        System.out.println("Given: Account with invalid credentials");
    }

    @And("the response should contain an error message in \\\"ErrorResponses\\\" format")
    public void theResponseShouldContainAnErrorMessageInErrorResponsesFormat() {
        System.out.println("And: Response contains error message");
        // Add schema validation here
    }

    @Given("a balance enquiry request is made without an account number")
    public void aBalanceEnquiryRequestIsMadeWithoutAnAccountNumber() {
        System.out.println("Given: Balance enquiry request without account number");
    }


    @Given("a balance enquiry request is made without an IFSC code")
    public void aBalanceEnquiryRequestIsMadeWithoutAnIFSCCode() {
        System.out.println("Given: Balance enquiry request without IFSC code");
    }

    @Given("a balance enquiry request is made without a password")
    public void aBalanceEnquiryRequestIsMadeWithoutAPassword() {
        System.out.println("Given: Balance enquiry request without password");
    }

    @Then("the API should return an error indicating a missing account number")
    public void theAPIShouldReturnAnErrorIndicatingAMissingAccountNumber() {
        System.out.println("Then: Error indicates missing account number");
        // Add assertion to validate error message
    }

    @Then("the API should return an error indicating a missing IFSC code")
    public void theAPIShouldReturnAnErrorIndicatingAMissingIFSCCode() {
        System.out.println("Then: Error indicates missing IFSC code");
        // Add assertion to validate error message
    }

    @Then("the API should return an error indicating a missing password")
    public void theAPIShouldReturnAnErrorIndicatingAMissingPassword() {
        System.out.println("Then: Error indicates missing password");
        // Add assertion to validate error message
    }

    @Given("a balance enquiry request is made with an {string}")
    public void aBalanceEnquiryRequestIsMadeWithAn(String invalidInput) {
        System.out.println("Given: Balance enquiry request with invalid input: " + invalidInput);
    }

    @Then("the API should return a {int} status code")
    public void theAPIShouldReturnAStatusCode(Integer statusCode) {
        System.out.println("Then: API returns status code " + statusCode);
        assert response.getStatusCode() == statusCode;
    }

    @And("the response should contain an appropriate error message")
    public void theResponseShouldContainAnAppropriateErrorMessage() {
        System.out.println("And: Response contains appropriate error message");
        // Add assertion to validate error message
    }

    @Given("the \\\"AccountDetailsRepositories\\\" dependency fails")
    public void theAccountDetailsRepositoriesDependencyFails() {
        System.out.println("Given: AccountDetailsRepositories dependency fails");
    }

    @Given("the \\\"NotificationsUtility\\\" dependency fails")
    public void theNotificationsUtilityDependencyFails() {
        System.out.println("Given: NotificationsUtility dependency fails");
    }

    @Then("the API should return an appropriate error message indicating a system failure")
    public void theAPIShouldReturnAnAppropriateErrorMessageIndicatingASystemFailure() {
        System.out.println("Then: API returns system failure error message");
        // Add assertion to validate error message
    }

    @Then("the API should return a {int} status code and the balance enquiry should be processed successfully")
    public void theAPIShouldReturnAStatusCodeAndTheBalanceEnquiryShouldBeProcessedSuccessfully(Integer statusCode) {
        System.out.println("Then: API returns status code " + statusCode + " and balance enquiry processed");
        assert response.getStatusCode() == statusCode;
        // Add assertions to check balance enquiry success
    }


    //Feature: Credit Money to Account

    @Given("a valid \\\"creditCredential\\\" object with sufficient account balance")
    public void aValidCreditCredentialObjectWithSufficientAccountBalance() {
        System.out.println("Given: Valid creditCredential with sufficient balance");
    }

    @And("the account number, IFSC code, and password are correct")
    public void theAccountNumberIFSCCodeAndPasswordAreCorrect() {
        System.out.println("And: Correct account details");
    }

    @And("the daily transaction limit has not been reached")
    public void theDailyTransactionLimitHasNotBeenReached() {
        System.out.println("And: Daily transaction limit not reached");
    }

    @When("a GET request is sent to {string} with the \\\"creditCredential\\\" object")
    public void aGETRequestIsSentToWithTheCreditCredentialObject(String endpoint) {
        System.out.println("When: GET request sent to " + endpoint);
        response = requests.get(endpoint, null); // Replace null with creditCredential object
    }

    @And("the response body should be a valid \\\"CreditResponse\\\" object")
    public void theResponseBodyShouldBeAValidCreditResponseObject() {
        System.out.println("And: Response is valid CreditResponse");
        // Add schema validation here
    }

    @Given("a \\\"creditCredential\\\" object with an invalid account number")
    public void aCreditCredentialObjectWithAnInvalidAccountNumber() {
        System.out.println("Given: creditCredential with invalid account number");
    }

    @And("the response body should be a valid \\\"ErrorResponses\\\" object")
    public void theResponseBodyShouldBeAValidErrorResponsesObject() {
        System.out.println("And: Response is valid ErrorResponses");
        // Add schema validation here
    }

    @And("the response body should indicate \\\"Account not found\\\"")
    public void theResponseBodyShouldIndicateAccountNotFound() {
        System.out.println("And: Response indicates Account not found");
        // Add assertion to validate error message
    }

    @Given("a valid \\\"creditCredential\\\" object with insufficient account balance")
    public void aValidCreditCredentialObjectWithInsufficientAccountBalance() {
        System.out.println("Given: Valid creditCredential with insufficient balance");
    }

    @And("the response body should indicate \\\"Insufficient balance\\\"")
    public void theResponseBodyShouldIndicateInsufficientBalance() {
        System.out.println("And: Response indicates Insufficient balance");
        // Add assertion to validate error message
    }


    @Given("a valid \\\"creditCredential\\\" object with an incorrect password")
    public void aValidCreditCredentialObjectWithAnIncorrectPassword() {
        System.out.println("Given: Valid creditCredential with incorrect password");
    }


    @And("the response body should indicate an authentication error")
    public void theResponseBodyShouldIndicateAnAuthenticationError() {
        System.out.println("And: Response indicates authentication error");
        // Add assertion to validate error message
    }

    @And("the daily transaction limit has been reached")
    public void theDailyTransactionLimitHasBeenReached() {
        System.out.println("And: Daily transaction limit reached");
    }

    @And("the response body should indicate that the daily transaction limit has been reached")
    public void theResponseBodyShouldIndicateThatTheDailyTransactionLimitHasBeenReached() {
        System.out.println("And: Response indicates daily transaction limit reached");
        // Add assertion to validate error message
    }

    @Given("a \\\"creditCredential\\\" object with {string}")
    public void aCreditCredentialObjectWith(String invalidField) {
        System.out.println("Given: creditCredential object with invalid field: " + invalidField);
    }



    //Feature: Debit Money from Account

    @Given("a valid debitCredential with sufficient balance")
    public void aValidDebitCredentialWithSufficientBalance() {
        System.out.println("Given: Valid debitCredential with sufficient balance");
    }

    @When("a debit request is made using the {string} endpoint")
    public void aDebitRequestIsMadeUsingTheEndpoint(String endpoint) {
        System.out.println("When: Debit request made to " + endpoint);
        response = requests.debit(endpoint, null); // Replace null with debitCredential
    }


    @And("the response should match the \\\"DebitedResponse\\\" schema")
    public void theResponseShouldMatchTheDebitedResponseSchema() {
        System.out.println("And: Response matches DebitedResponse schema");
        // Add schema validation
    }


    @Given("a valid debitCredential with insufficient balance")
    public void aValidDebitCredentialWithInsufficientBalance() {
        System.out.println("Given: Valid debitCredential with insufficient balance");
    }

    @And("the response body should contain an error message indicating insufficient balance")
    public void theResponseBodyShouldContainAnErrorMessageIndicatingInsufficientBalance() {
        System.out.println("And: Response indicates insufficient balance");
        // Add assertion to validate error message
    }

    @Given("a debitCredential with an invalid account number")
    public void aDebitCredentialWithAnInvalidAccountNumber() {
        System.out.println("Given: debitCredential with invalid account number");
    }

    @And("the response body should contain an error message indicating an invalid account number")
    public void theResponseBodyShouldContainAnErrorMessageIndicatingAnInvalidAccountNumber() {
        System.out.println("And: Response indicates invalid account number");
        // Add assertion to validate error message
    }

    @Given("a debitCredential with an invalid IFSC code")
    public void aDebitCredentialWithAnInvalidIFSCCode() {
        System.out.println("Given: debitCredential with invalid IFSC code");
    }

    @And("the response body should contain an error message indicating an invalid IFSC code")
    public void theResponseBodyShouldContainAnErrorMessageIndicatingAnInvalidIFSCCode() {
        System.out.println("And: Response indicates invalid IFSC code");
        // Add assertion to validate error message
    }

    @Given("a debitCredential with an incorrect password")
    public void aDebitCredentialWithAnIncorrectPassword() {
        System.out.println("Given: debitCredential with incorrect password");
    }

    @And("the response body should contain an error message indicating an incorrect password")
    public void theResponseBodyShouldContainAnErrorMessageIndicatingAnIncorrectPassword() {
        System.out.println("And: Response indicates incorrect password");
        // Add assertion to validate error message
    }

    @Given("a valid debitCredential with sufficient balance but daily transaction limit exceeded")
    public void aValidDebitCredentialWithSufficientBalanceButDailyTransactionLimitExceeded() {
        System.out.println("Given: Valid debitCredential but daily transaction limit exceeded");
    }

    @And("the response body should contain an error message indicating daily transaction limit exceeded")
    public void theResponseBodyShouldContainAnErrorMessageIndicatingDailyTransactionLimitExceeded() {
        System.out.println("And: Response indicates daily transaction limit exceeded");
        // Add assertion to validate error message
    }

    @Given("a valid debitCredential with sufficient balance and a high value transaction amount")
    public void aValidDebitCredentialWithSufficientBalanceAndAHighValueTransactionAmount() {
        System.out.println("Given: Valid debitCredential with high value transaction");
    }

    @And("a notification should be sent \\(This step may require mocking the NotificationsUtility dependency\\)")
    public void aNotificationShouldBeSentThisStepMayRequireMockingTheNotificationsUtilityDependency() {
        System.out.println("And: Notification sent");
        // Add mock for notification if needed
    }

    @When("a debit request is made using the {string} endpoint without debitCredential")
    public void aDebitRequestIsMadeUsingTheEndpointWithoutDebitCredential(String endpoint) {
        System.out.println("When: Debit request without debitCredential");
        response = requests.debit(endpoint, null);  //intentionally sending null to simulate missing data
    }

    @Then("the response status code should be {int}")
    public void theResponseStatusCodeShouldBe(int arg0) {
        // Write code here that turns the phrase above into concrete actions
    }

    @And("the response should contain an error message indicating missing debitCredential")
    public void theResponseShouldContainAnErrorMessageIndicatingMissingDebitCredential() {
        System.out.println("And: Response indicates missing debitCredential");
        // Add assertion to validate error message
    }


    //Feature: Make UPI Payment

    @Given("a user with a valid account and sufficient balance")
    public void aUserWithAValidAccountAndSufficientBalance() {
        System.out.println("Given: User with valid account and sufficient balance");
    }

    @And("a valid UPI ID is provided")
    public void aValidUPIIDIsProvided() {
        System.out.println("And: Valid UPI ID provided");
    }

    @When("the user initiates a UPI payment")
    public void theUserInitiatesAUPIPayment() {
        System.out.println("When: User initiates UPI payment");
        response = requests.makeUPIPayment(null); //Replace null with UPI payment request object
    }

    @Then("the payment should be successful")
    public void thePaymentShouldBeSuccessful() {
        System.out.println("Then: Payment successful");
    }

    @And("a {int} status code should be returned")
    public void aStatusCodeShouldBeReturned(Integer statusCode) {
        System.out.println("And: Status code " + statusCode + " returned");
        assert response.getStatusCode() == statusCode;
    }


    @And("the response should contain the payment details")
    public void theResponseShouldContainThePaymentDetails() {
        System.out.println("And: Response contains payment details");
        // Add assertion to validate response
    }

    @Given("a user with a valid account and insufficient balance")
    public void aUserWithAValidAccountAndInsufficientBalance() {
        System.out.println("Given: User with valid account and insufficient balance");
    }

    @Then("the payment should fail")
    public void thePaymentShouldFail() {
        System.out.println("Then: Payment failed");
    }

    @And("the error response should indicate insufficient balance")
    public void theErrorResponseShouldIndicateInsufficientBalance() {
        System.out.println