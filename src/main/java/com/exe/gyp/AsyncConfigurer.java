package com.exe.gyp;

import java.util.concurrent.Executor;

//인터페이스
//Executor 자동실행 메소드 설정 
public interface AsyncConfigurer {
	
	public Executor getAsyncExecutor();
}
