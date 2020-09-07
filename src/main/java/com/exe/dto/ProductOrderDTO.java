package com.exe.dto;

// 상품 주문 페이지 DTO
public class ProductOrderDTO {

	private String productId; // 상품 ID
	private String productName; // 상품 이름
	private String productImg; // 상품 이미지
	private int productPrice; // 상품 가격
	private int cartNum; // 상품 장바구니 번호
	private int count; // 상품 갯수

	public String getProductId() {
		return productId;
	}

	public void setProductId(String productId) {
		this.productId = productId;
	}

	public String getProductName() {
		return productName;
	}

	public void setProductName(String productName) {
		this.productName = productName;
	}

	public String getProductImg() {
		return productImg;
	}

	public void setProductImg(String productImg) {
		this.productImg = productImg;
	}

	public int getProductPrice() {
		return productPrice;
	}

	public void setProductPrice(int productPrice) {
		this.productPrice = productPrice;
	}

	public int getCartNum() {
		return cartNum;
	}

	public void setCartNum(int cartNum) {
		this.cartNum = cartNum;
	}

	public int getCount() {
		return count;
	}

	public void setCount(int count) {
		this.count = count;
	}

}