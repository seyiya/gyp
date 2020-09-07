package com.exe.dto;
// 리뷰 테이블 (체육관 리뷰 + 상품 리뷰)
public class ReviewDTO {
	
	private int reNum;			// 리뷰 번호
	private String reType;		// 리뷰 타입 (체육관/상품)
	private String cusId;		// 회원 ID
	private String gymId;		// 체육관 ID
	private String productId;	// 상품 ID
	private int star;			// 평가 점수 (0~10)
	private String reContent;	// 리뷰 내용
	private String reCreated;	// 리뷰 작성일
	private String gymName; 	//체육관 이름
	private String productName; //상품 이름
	
	public int getReNum() {
		return reNum;
	}
	public void setReNum(int reNum) {
		this.reNum = reNum;
	}
	public String getReType() {
		return reType;
	}
	public void setReType(String reType) {
		this.reType = reType;
	}
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
	public String getProductId() {
		return productId;
	}
	public void setProductId(String productId) {
		this.productId = productId;
	}
	public int getStar() {
		return star;
	}
	public void setStar(int star) {
		this.star = star;
	}
	public String getReContent() {
		return reContent;
	}
	public void setReContent(String reContent) {
		this.reContent = reContent;
	}
	public String getReCreated() {
		return reCreated;
	}
	public void setReCreated(String reCreated) {
		this.reCreated = reCreated;
	}
	public String getGymName() {
		return gymName;
	}
	public void setGymName(String gymName) {
		this.gymName = gymName;
	}
	public String getProductName() {
		return productName;
	}
	public void setProductName(String productName) {
		this.productName = productName;
	}
	

	

}
