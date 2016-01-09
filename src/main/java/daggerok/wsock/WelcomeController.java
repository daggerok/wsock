package daggerok.wsock;

import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.stereotype.Controller;

import java.util.concurrent.TimeUnit;

@Controller
public class WelcomeController {
    @MessageMapping("/welcome")
    @SendTo("/topic/welcome")
    public Welcome welcome(Message message) throws InterruptedException {
        TimeUnit.SECONDS.sleep(3);
        return Welcome.of("Hey, " + message.getName() + "!");
    }
}