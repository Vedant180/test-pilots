package tuto.cucumber.sample.steps;

import io.cucumber.spring.CucumberContextConfiguration;
import org.springframework.boot.test.context.SpringBootTest;
import com.syc.finance.v1.bharat.BankApplication;

@CucumberContextConfiguration
@SpringBootTest(classes = BankApplication.class, webEnvironment = SpringBootTest.WebEnvironment.DEFINED_PORT)
public class CucumberConfiguration {

}
