package com.exe.dto;

//세션에 올릴 아이디,패스워드
public class CustomInfo {

	private String sessionId; //아이디
	private String loginType; //회원유형
	
	public String getSessionId() {
		return sessionId;
	}
	public void setSessionId(String sessionId) {
		this.sessionId = sessionId;
	}
	public String getLoginType() {
		return loginType;
	}
	public void setLoginType(String loginType) {
		this.loginType = loginType;
	}
	
	
}
