package com.jee.sensorHub;

import org.springframework.boot.SpringApplication;

public class TestSensorHubApplication {

	public static void main(String[] args) {
		SpringApplication.from(SensorHubApplication::main).with(TestcontainersConfiguration.class).run(args);
	}

}
