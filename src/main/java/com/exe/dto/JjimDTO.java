package com.exe.dto;
// 찜한 체육관 테이블 JJIM
public class JjimDTO {

	private String cusId;		// 회원 ID
	private String gymId;		// 체육관 ID
	private String jjimCreated;	// 찜한 날짜
	
	public String getCusId() {
		return cusId;
	}
	public void setCusId(String cusId) {
		this.cusId = cusId;
	}
	public String getGymId() {
		return gymId;
	}
	public void setGymId(String gymId) {
		this.gymId = gymId;
	}
	public String getJjimCreated() {
		return jjimCreated;
	}
	public void setJjimCreated(String jjimCreated) {
		this.jjimCreated = jjimCreated;
	}
	
	
}
