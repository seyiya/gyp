package com.exe.gyp;

import java.util.concurrent.Executor;

import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor;

@Configuration
@EnableAsync
public class AsyncConfig implements AsyncConfigurer {
	
	//자동실행 Executor 설정
	@Override
	public Executor getAsyncExecutor() {
		ThreadPoolTaskExecutor executor = new ThreadPoolTaskExecutor(); //스레드
		executor.setCorePoolSize(10); 
		executor.setMaxPoolSize(100);
		executor.setQueueCapacity(50);
		executor.initialize();
		return executor;
	}

}

