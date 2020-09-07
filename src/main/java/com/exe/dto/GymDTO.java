package com.exe.dto;

import java.util.List;

// 체육관 정보 테이블 GYM
public class GymDTO {
	private String gymId;		// 체육관 ID
	private String gymType;  	// 체육관 타입 (헬스, 요가, 필라테스)
	private String gymName;   	// 체육관 이름
	private String gymPwd;   	// 체육관 비밀번호
	private String gymEmail;   	// 체육관 이메일
	private String gymTel;   	// 체육관 전화번호
	private String gymAddr;   	// 체육관 주소
	private String gymAddrDetail;   	// 체육관 상세주소
	private float gymLongitude;  // 체육관 경도
	private float gymLatitude;   // 체육관 위도
	private String gymTrainer;   // 체육관 트레이너 (1,2,3,4) - 파싱해서 사용
	private String gymTrainerPic;// 체육관 트레이너 사진 (1,2,3,4) - 위와 같은 순서대로 매칭해서 파싱해 사용
	private String gymPic;   	// 체육관 사진 (1,2,3,4) - 파싱해서 사용
	private String gymProgram;   // 체육관의 프로그램
	private String gymFacility;  // 체육관 시설
	private String gymHour;   	// 체육관 운영시간
	private String gymCreated;   // 체육관 가입일
	private int gymPass;   		// 체육관 소유 패스 (벌어들이는 돈)
	private String gymOk; 		// true: 승인 /false: 거부

	private String[] gymTrainerAry; //이미지 출력용 배열(Array) 생성
	private String[] gymTrainerPicAry;
	private String[] gymPicAry;
	private String[] gymFacilityAry;
	
	private List<String> gymPicAryList; //map에서 사진 뿌리는 용도

	
	public String getGymAddrDetail() {
		return gymAddrDetail;
	}
	public void setGymAddrDetail(String gymAddrDetail) {
		this.gymAddrDetail = gymAddrDetail;
	}
	public List<String> getGymPicAryList() {
		return gymPicAryList;
	}
	public void setGymPicAryList(List<String> gymPicAryList) {
		this.gymPicAryList = gymPicAryList;
	}
	public String getGymId() {
		return gymId;
	}
	public void setGymId(String gymId) {
		this.gymId = gymId;
	}
	public String getGymType() {
		return gymType;
	}
	public void setGymType(String gymType) {
		this.gymType = gymType;
	}
	public String getGymName() {
		return gymName;
	}
	public void setGymName(String gymName) {
		this.gymName = gymName;
	}
	public String getGymPwd() {
		return gymPwd;
	}
	public void setGymPwd(String gymPwd) {
		this.gymPwd = gymPwd;
	}
	public String getGymEmail() {
		return gymEmail;
	}
	public void setGymEmail(String gymEmail) {
		this.gymEmail = gymEmail;
	}
	public String getGymTel() {
		return gymTel;
	}
	public void setGymTel(String gymTel) {
		this.gymTel = gymTel;
	}
	public String getGymAddr() {
		return gymAddr;
	}
	public void setGymAddr(String gymAddr) {
		this.gymAddr = gymAddr;
	}
	public float getGymLongitude() {
		return gymLongitude;
	}
	public void setGymLongitude(float gymLongitude) {
		this.gymLongitude = gymLongitude;
	}
	public float getGymLatitude() {
		return gymLatitude;
	}
	public void setGymLatitude(float gymLatitude) {
		this.gymLatitude = gymLatitude;
	}
	public String getGymTrainer() {
		return gymTrainer;
	}
	public void setGymTrainer(String gymTrainer) {
		this.gymTrainer = gymTrainer;
	}
	public String getGymTrainerPic() {
		return gymTrainerPic;
	}
	public void setGymTrainerPic(String gymTrainerPic) {
		this.gymTrainerPic = gymTrainerPic;
	}
	public String getGymPic() {
		return gymPic;
	}
	public void setGymPic(String gymPic) {
		this.gymPic = gymPic;
	}
	public String getGymProgram() {
		return gymProgram;
	}
	public void setGymProgram(String gymProgram) {
		this.gymProgram = gymProgram;
	}
	public String getGymFacility() {
		return gymFacility;
	}
	public void setGymFacility(String gymFacility) {
		this.gymFacility = gymFacility;
	}
	public String getGymHour() {
		return gymHour;
	}
	public void setGymHour(String gymHour) {
		this.gymHour = gymHour;
	}
	public String getGymCreated() {
		return gymCreated;
	}
	public void setGymCreated(String gymCreated) {
		this.gymCreated = gymCreated;
	}
	public int getGymPass() {
		return gymPass;
	}
	public void setGymPass(int gymPass) {
		this.gymPass = gymPass;
	}
	public String getGymOk() {
		return gymOk;
	}
	public void setGymOk(String gymOk) {
		this.gymOk = gymOk;
	}

	public String[] getGymTrainerAry() {
		return gymTrainerAry;
	}
	public void setGymTrainerAry(String[] gymTrainerAry) {
		this.gymTrainerAry = gymTrainerAry;
	}
	public String[] getGymTrainerPicAry() {
		return gymTrainerPicAry;
	}
	public void setGymTrainerPicAry(String[] gymTrainerPicAry) {
		this.gymTrainerPicAry = gymTrainerPicAry;
	}
	public String[] getGymPicAry() {
		return gymPicAry;
	}
	public void setGymPicAry(String[] gymPicAry) {
		this.gymPicAry = gymPicAry;
	}
	public String[] getGymFacilityAry() {
		return gymFacilityAry;
	}
	public void setGymFacilityAry(String[] gymFacilityAry) {
		this.gymFacilityAry = gymFacilityAry;
	}

}
