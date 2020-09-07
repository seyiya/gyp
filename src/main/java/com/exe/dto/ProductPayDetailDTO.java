package com.exe.dto;
// 상품 주문 상세 테이블 PRODUCTPAYDETAIL
public class ProductPayDetailDTO { //(propayNum같은거 다 가져오기)
	
	private int proPayDetailNum;	// 주문 상세 번호
	private String productId;		// 상품 번호
	private int proPayNum;			// 상품 주문 번호
	private int count;				// 상품 개수	//가격은 (상품 별 가격*count)
	
	public int getProPayDetailNum() {
		return proPayDetailNum;
	}
	public void setProPayDetailNum(int proPayDetailNum) {
		this.proPayDetailNum = proPayDetailNum;
	}
	public String getProductId() {
		return productId;
	}
	public void setProductId(String productId) {
		this.productId = productId;
	}
	public int getProPayNum() {
		return proPayNum;
	}
	public void setProPayNum(int proPayNum) {
		this.proPayNum = proPayNum;
	}
	public int getCount() {
		return count;
	}
	public void setCount(int count) {
		this.count = count;
	}
}
