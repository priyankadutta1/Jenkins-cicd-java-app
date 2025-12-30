@RestController
public class HelloController {

    @GetMapping("/")
    public String hello() {
        return "Hello from Jenkins CI/CD Pipeline on GCP!";
    }
}
