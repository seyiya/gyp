package com.exe.dto;
// 마이페이지 상품 주문 내역 DTO
public class CusProductOrderDTO {
   private int proPayNum;         // 상품 주문 번호
   private int proPayDetailNum;   // 상품 상세 주문 번호
   private String cusId;         // 회원 번호
   private String proPayCreated;   // 상품 결제 일시 (날짜 + 시간)
   private int priceTotal;         // 총 결제 가격
   private String proPayAddr;      // 배송 주소지 (회원정보의 주소와 배송주소지는 다름)
   private String proPayTel;      // 배송 전화번호   private int proPayDetailNum;   // 주문 상세 번호
   private String productId;      // 상품 번호
   private int count;            // 상품 개수   //가격은 (상품 별 가격*count)
   private String productName;
   private String productImg;
   private int productPrice;
   
   public int getProPayNum() {
      return proPayNum;
   }
   public void setProPayNum(int proPayNum) {
      this.proPayNum = proPayNum;
   }
   public int getProPayDetailNum() {
      return proPayDetailNum;
   }
   public void setProPayDetailNum(int proPayDetailNum) {
      this.proPayDetailNum = proPayDetailNum;
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
   public String getProductId() {
      return productId;
   }
   public void setProductId(String productId) {
      this.productId = productId;
   }
   public int getCount() {
      return count;
   }
   public void setCount(int count) {
      this.count = count;
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
   
   
}