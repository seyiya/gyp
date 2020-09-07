package com.exe.dto;
// 패스 결제(충전) 테이블 CHARGE
public class ChargeDTO {
	
	private int chargeNum;			// 결제 번호
	private String cusId;			// 회원 번호
	private int chargePass;			// 충전 패스 (5)
	private String chargeCreated;	// 결제 일시 (날짜 + 시간)
	private String chargeType;		// 결제 방법
	
	public int getChargeNum() {
		return chargeNum;
	}
	public void setChargeNum(int i) {
		this.chargeNum = i;
	}
	public String getCusId() {
		return cusId;
	}
	public void setCusId(String cusId) {
		this.cusId = cusId;
	}
	public int getChargePass() {
		return chargePass;
	}
	public void setChargePass(int chargePass) {
		this.chargePass = chargePass;
	}
	public String getChargeCreated() {
		return chargeCreated;
	}
	public void setChargeCreated(String chargeCreated) {
		this.chargeCreated = chargeCreated;
	}
	public String getChargeType() {
		return chargeType;
	}
	public void setChargeType(String chargeType) {
		this.chargeType = chargeType;
	}
	
	

}
