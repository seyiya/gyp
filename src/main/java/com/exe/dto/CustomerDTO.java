package com.exe.dto;
// 회원 테이블 CUSTOMER
public class CustomerDTO {
	
	private String cusId;	// 회원 ID
	private String cusName;	// 회원 이름
	private String cusPwd;	// 회원 비밀번호
	private String cusEmail;// 회원 이메일
	private String cusTel;	// 회원 전화번호
	private String cusAddr;	// 회원 주소
	private String cusAddrDetail; //상세주소
	private int cusPass;	// 회원 소유 패스 갯수
	private String cusCreated;	// 회원가입일
	
	
	
	
	
	public String getCusAddrDetail() {
		return cusAddrDetail;
	}
	public void setCusAddrDetail(String cusAddrDetail) {
		this.cusAddrDetail = cusAddrDetail;
	}
	public String getCusId() {
		return cusId;
	}
	public void setCusId(String cusId) {
		this.cusId = cusId;
	}
	public String getCusName() {
		return cusName;
	}
	public void setCusName(String cusName) {
		this.cusName = cusName;
	}
	public String getCusPwd() {
		return cusPwd;
	}
	public void setCusPwd(String cusPwd) {
		this.cusPwd = cusPwd;
	}
	public String getCusEmail() {
		return cusEmail;
	}
	public void setCusEmail(String cusEmail) {
		this.cusEmail = cusEmail;
	}
	public String getCusTel() {
		return cusTel;
	}
	public void setCusTel(String cusTel) {
		this.cusTel = cusTel;
	}
	public String getCusAddr() {
		return cusAddr;
	}
	public void setCusAddr(String cusAddr) {
		this.cusAddr = cusAddr;
	}
	public int getCusPass() {
		return cusPass;
	}
	public void setCusPass(int cusPass) {
		this.cusPass = cusPass;
	}
	public String getCusCreated() {
		return cusCreated;
	}
	public void setCusCreated(String cusCreated) {
		this.cusCreated = cusCreated;
	}
}
