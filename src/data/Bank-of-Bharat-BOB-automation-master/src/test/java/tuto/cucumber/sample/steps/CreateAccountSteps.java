package tuto.cucumber.sample.steps;
import io.cucumber.java.en.*;
import static io.restassured.RestAssured.*;
import static org.hamcrest.Matchers.*;
import io.restassured.response.Response;
import org.springframework.boot.test.context.SpringBootTest;
import java.util.HashMap;
import java.util.Map;

@SpringBootTest
public class CreateAccountSteps {

    private Response response;
    private Map<String, Object> requestBody;

    @Given("the user provides valid account details")
    public void the_user_provides_valid_account_details() {
        requestBody = new HashMap<>();
        requestBody.put("accountHolderName", "John Doe");
        requestBody.put("contactEmail", "johndoe@example.com");
        requestBody.put("contactPhone", "9876543210");
        requestBody.put("gender", "Male");
        requestBody.put("contactAddress", "123 Street, City");
        requestBody.put("stateOfOrigin", "California");
        requestBody.put("pinCodeNumber", "123456");
        requestBody.put("currentLocation", "New York");
        requestBody.put("designation", "Engineer");
        requestBody.put("country", "USA");
        requestBody.put("accountType", "Savings");
    }

    @When("the user sends a request to create an account")
    public void the_user_sends_a_request_to_create_an_account() {
        response = given()
                .header("Content-Type", "application/json")
                .body(requestBody)
                .when()
                .post("http://localhost:45785/finance/v1/bank/v4/bharat/create-account"); // Replace with actual URL
    }

    @Then("the account should be created successfully")
    public void the_account_should_be_created_successfully() {
        response.then().body("message", equalTo("YOUR ACCOUNT HAS BEEN CREATED SUCCESSFULLY !! "));
    }

    @Then("the response status should be {int}")
    public void the_response_status_should_be(Integer statusCode) {
        response.then().statusCode(statusCode);
    }

    @Given("the user provides account details with an already registered email")
    public void the_user_provides_account_details_with_an_already_registered_email() {
        requestBody = new HashMap<>();
        requestBody.put("accountHolderName", "John Doe");
        requestBody.put("contactEmail", "existingemail@example.com"); // Already used email
        requestBody.put("contactPhone", "1234567890");
        requestBody.put("gender", "Male");
        requestBody.put("contactAddress", "123 Street, City");
        requestBody.put("stateOfOrigin", "California");
        requestBody.put("pinCodeNumber", "123456");
        requestBody.put("currentLocation", "New York");
        requestBody.put("designation", "Engineer");
        requestBody.put("country", "USA");
        requestBody.put("accountType", "Savings");
    }

    @Then("an error message {string} should be returned")
    public void an_error_message_should_be_returned(String errorMessage) {
        response.then().body("message", equalTo(errorMessage));
    }

    @Given("the user provides account details with an already registered phone number")
    public void the_user_provides_account_details_with_an_already_registered_phone_number() {
        requestBody = new HashMap<>();
        requestBody.put("accountHolderName", "John Doe");
        requestBody.put("contactEmail", "newemail@example.com");
        requestBody.put("contactPhone", "existingphone@example.com"); // Already used phone
        requestBody.put("gender", "Male");
        requestBody.put("contactAddress", "123 Street, City");
        requestBody.put("stateOfOrigin", "California");
        requestBody.put("pinCodeNumber", "123456");
        requestBody.put("currentLocation", "New York");
        requestBody.put("designation", "Engineer");
        requestBody.put("country", "USA");
        requestBody.put("accountType", "Savings");
    }

}
