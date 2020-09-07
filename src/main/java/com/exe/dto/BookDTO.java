package com.exe.dto;
// 예약 테이블 Book
public class BookDTO {
	
	private int bookNum;			// 예약 번호
	private String cusId;			// 회원 번호
	private String gymId;			// 체육관 번호
	private String gymTrainerPick;	// 선택한 트레이너 이름 (존재하는지 검사하기)
	private String bookType;		// 예약 종류 (온라인/오프라인)
	private String faceLink;		// 화상 통화 링크
	private String faceLinkCreated;	// 화상 통화 링크 생성시점(날짜 + 시간)
	private String bookCreated;		// 예약일
	private String bookHour;		// 예약 시간
	private String bookOK;			// 예약 승인 여부 (true:승인,false:거절)
	
	private String gymName;			//체육관 이름
	
	public int getBookNum() {
		return bookNum;
	}
	public void setBookNum(int bookNum) {
		this.bookNum = bookNum;
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
	public String getGymTrainerPick() {
		return gymTrainerPick;
	}
	public void setGymTrainerPick(String gymTrainerPick) {
		this.gymTrainerPick = gymTrainerPick;
	}
	public String getBookType() {
		return bookType;
	}
	public void setBookType(String bookType) {
		this.bookType = bookType;
	}
	public String getFaceLink() {
		return faceLink;
	}
	public void setFaceLink(String faceLink) {
		this.faceLink = faceLink;
	}
	public String getFaceLinkCreated() {
		return faceLinkCreated;
	}
	public void setFaceLinkCreated(String faceLinkCreated) {
		this.faceLinkCreated = faceLinkCreated;
	}
	public String getBookCreated() {
		return bookCreated;
	}
	public void setBookCreated(String bookCreated) {
		this.bookCreated = bookCreated;
	}
	public String getBookHour() {
		return bookHour;
	}
	public void setBookHour(String bookHour) {
		this.bookHour = bookHour;
	}
	public String getBookOK() {
		return bookOK;
	}
	public void setBookOK(String bookOK) {
		this.bookOK = bookOK;
	}
	public String getGymName() {
		return gymName;
	}
	public void setGymName(String gymName) {
		this.gymName = gymName;
	}
	

}
