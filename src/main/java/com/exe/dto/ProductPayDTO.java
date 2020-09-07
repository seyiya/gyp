package com.exe.dto;
// 상품 주문 테이블 PRODUCTPAY	
public class ProductPayDTO {//주문1 : A1, B2, C3 : 행 6개
	
	private int proPayNum;			// 상품 주문 번호
	private String cusId;			// 회원 번호
	private String proPayCreated;	// 상품 결제 일시 (날짜 + 시간)
	private int priceTotal;			// 총 결제 가격
	private String proPayAddr;		// 배송 주소지 (회원정보의 주소와 배송주소지는 다름)
	private String proPayTel;		// 배송 전화번호
	
	public int getProPayNum() {
		return proPayNum;
	}
	public void setProPayNum(int proPayNum) {
		this.proPayNum = proPayNum;
	}
	public String getCusId() {
		return cusId;
	}
	public void setCusId(String cusId) {
		this.cusId = cusId;
	}
	public String getProPayCreated() {
		return proPayCreated;
	}
	public void setProPayCreated(String proPayCreated) {
		this.proPayCreated = proPayCreated;
	}
	public int getPriceTotal() {
		return priceTotal;
	}
	public void setPriceTotal(int priceTotal) {
		this.priceTotal = priceTotal;
	}
	public String getProPayAddr() {
		return proPayAddr;
	}
	public void setProPayAddr(String proPayAddr) {
		this.proPayAddr = proPayAddr;
	}
	public String getProPayTel() {
		return proPayTel;
	}
	public void setProPayTel(String proPayTel) {
		this.proPayTel = proPayTel;
	}
	
	

}
