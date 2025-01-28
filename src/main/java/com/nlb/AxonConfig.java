package com.nlb;

import org.axonframework.commandhandling.gateway.CommandGateway;
import org.axonframework.commandhandling.gateway.DefaultCommandGateway;
import org.axonframework.commandhandling.SimpleCommandBus;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class AxonConfig {

    @Bean
    public SimpleCommandBus commandBus() {
        // Command Bus의 기본 설정
        return SimpleCommandBus.builder().build();
    }

    @Bean
    public CommandGateway commandGateway(SimpleCommandBus commandBus) {
        return DefaultCommandGateway.builder().commandBus(commandBus).build();
    }
}
