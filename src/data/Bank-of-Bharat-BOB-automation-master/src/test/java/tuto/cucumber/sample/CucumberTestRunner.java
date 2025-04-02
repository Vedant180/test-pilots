package tuto.cucumber.sample;

import io.cucumber.junit.Cucumber;
import io.cucumber.junit.CucumberOptions;
import org.junit.runner.RunWith;

@RunWith(Cucumber.class)
@CucumberOptions(
        features = "D:\\WFHackathon\\trial\\test-pilots\\src\\data\\Bank-of-Bharat-BOB-automation-master\\target\\test-classes\\features",
        glue = "tuto.cucumber.sample.steps",
        tags= "@test",
        plugin = { "pretty", "html:target/cucumber-reports.html" }
)
public class CucumberTestRunner {

}
