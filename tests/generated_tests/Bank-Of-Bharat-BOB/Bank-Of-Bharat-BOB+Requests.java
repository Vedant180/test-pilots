```java
import io.restassured.RestAssured;
import io.restassured.response.Response;
import io.restassured.specification.RequestSpecification;

import static io.restassured.RestAssured.given;

public class WalletRequests {

    private String baseUri;

    public WalletRequests(String baseUri) {
        this.baseUri = baseUri;
        RestAssured.baseURI = baseUri;
    }


    public Response post(String endpoint, Object requestBody) {
        RequestSpecification request = given().contentType("application/json");
        if (requestBody != null) {
            request.body(requestBody);
        }
        return request.post(endpoint);
    }

    public Response put(String endpoint, Object requestBody) {
        RequestSpecification request = given().contentType("application/json");
        if (requestBody != null) {
            request.body(requestBody);
        }
        return request.put(endpoint);
    }

    public Response delete(String endpoint, Object requestBody) {
        RequestSpecification request = given().contentType("application/json");
        if (requestBody != null) {
            request.body(requestBody);
        }
        return request.delete(endpoint);
    }

    public Response get(String endpoint, String accountNumber, String ifscCode, String password) {
        // Construct the full endpoint with parameters
        String fullEndpoint = String.format("%s/%s/%s/%s", endpoint, accountNumber, ifscCode, password);
        return given().get(fullEndpoint);

    }

    public Response get(String endpoint, Object requestBody) {
        RequestSpecification request = given().contentType("application/json");
        if (requestBody != null) {
            request.body(requestBody);
        }
        return request.get(endpoint);
    }

    public Response getBalance(Object requestBody) {
        RequestSpecification request = given().contentType("application/json");
        if (requestBody != null) {
            request.body(requestBody);
        }
        //  Replace with actual balance endpoint.  This is a placeholder.
        return request.get("/finance/v1/bank/v4/bharat/balance");
    }


    public Response debit(String endpoint, Object debitCredential) {
        RequestSpecification request = given().contentType("application/json");
        if (debitCredential != null) {
            request.body(debitCredential);
        }
        return request.post(endpoint); // Assuming debit is a POST request. Adjust as needed.
    }

    public Response makeUPIPayment(Object upiPaymentRequest) {
        RequestSpecification request = given().contentType("application/json");
        if (upiPaymentRequest != null) {
            request.body(upiPaymentRequest);
        }
        // Replace with actual UPI payment endpoint
        return request.post("/finance/v1/upi/v1/pay");
    }
}
```