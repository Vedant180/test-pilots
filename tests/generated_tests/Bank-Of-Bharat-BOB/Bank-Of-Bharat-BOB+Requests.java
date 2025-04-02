```java
import io.restassured.RestAssured;
import io.restassured.response.Response;
import io.restassured.specification.RequestSpecification;
import org.json.JSONObject;

import static io.restassured.RestAssured.given;

public class WalletRequests {

    private String apiBaseUrl = "YOUR_API_ENDPOINT"; // Replace with your actual API base URL

    public String transferMoney(String senderAccountNumber, String recipientAccountNumber, int amount) {
        RequestSpecification request = RestAssured.given()
                .contentType("application/json")
                .body(new JSONObject()
                        .put("senderAccountNumber", senderAccountNumber)
                        .put("recipientAccountNumber", recipientAccountNumber)
                        .put("amount", amount)
                        .toString());

        Response response = request.post(apiBaseUrl + "/transfer"); // Adjust the endpoint as needed

        return response.asString();
    }


    public int getStatusCode() {
        return RestAssured.last().getStatusCode();
    }

    // Add other API request methods as needed.  Example for getting balance:
    public String getBalance(String accountNumber){
        RequestSpecification request = RestAssured.given()
                .contentType("application/json")
                .param("accountNumber", accountNumber); //Using query parameter for account number.  Adjust as needed.

        Response response = request.get(apiBaseUrl + "/balance"); // Adjust the endpoint as needed

        return response.asString();
    }


}
```

**To use this with your existing code:**

1.  **Replace `YOUR_API_ENDPOINT`:** Update `apiBaseUrl` in `WalletRequests.java` with the correct base URL of your API.  For example: `"http://localhost:8080/api/v1"`.
2.  **Adjust Endpoints:** Modify the endpoint paths (e.g., `/transfer`, `/balance`) in the `transferMoney` and `getBalance` methods to accurately reflect the routes in your API.
3.  **Add Dependencies:** Make sure you have the `io.rest-assured` dependency in your `pom.xml`:

```xml
<dependency>
    <groupId>io.rest-assured</groupId>
    <artifactId>rest-assured</artifactId>
    <version>5.3.0</version> <!-- Use the latest version -->
    <scope>test</scope>
</dependency>
<dependency>
    <groupId>org.json</groupId>
    <artifactId>json</artifactId>
    <version>20230618</version>
</dependency>

```

4.  **Replace `Requests` with `WalletRequests`:** In your `StepDefinitions.java`, change `requests = new Requests();` to `requests = new WalletRequests();`.


This improved `WalletRequests.java` leverages REST-assured for cleaner, more maintainable, and more efficient API interaction.  The example `getBalance` method shows how easily you can add more API calls as needed. Remember to handle potential exceptions (e.g., `IOException`) appropriately in your `StepDefinitions` or `WalletRequests` class, as needed.  Consider adding more robust error handling in your `WalletRequests` methods to check for various HTTP status codes and provide more informative error messages.
