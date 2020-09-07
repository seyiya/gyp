<%@page import="com.exe.dto.CustomInfo"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	request.setCharacterEncoding("UTF-8");
	String cp = request.getContextPath();

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<meta http-equiv="refresh" content="60; URL=/gyp/faceLink.action">
	<!-- Favicon -->
	<link rel="icon" href="/gyp/resources/img/core-img/favicon.ico">
	<!-- Core Stylesheet -->
	<link rel="stylesheet" href="/gyp/resources/css/style.css">
	<!-- font -->
	<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400&display=swap" rel="stylesheet">
	
<title>GYP</title>
</head>
<body style="font-family: 'Noto Sans KR', sans-serif;">
	
	<jsp:include page="/WEB-INF/views/layout/header_over.jsp" />
	<jsp:include page="/WEB-INF/views/layout/header_below.jsp" />
	<div style="height: 100px;"></div>
	
	<div class="our-newsletter-area mb-100" style="width: 630px; margin: 0 auto; margin-bottom: 15px!important;">
		<div class="section-heading">
			<h6 align="center">FACELINK CLASS</h6>
			<h2 align="center">온라인 수업하기</h2>
			<div style="height: 10px;"></div>
			<hr>
		</div>
	</div>
	
	<div class="contact-area section-padding-100" style="padding: 0px;">
		<div class="container">
		<div style="width: 750px; margin: 0 auto;">

		<div class="row">
			<div class="col-12">
				<div class="contact-content">
                     <!-- Contact Form Area -->
                     <div class="contact-form-area">
                     
                     	<!-- 예약 내역이 없을 때 -->
                     	<c:if test="${dto == null}">
	                     	<div class="row" align="center" style="text-align: center; justify-content: center; margin: 20px;">
	                        	<div class="mb-70" > 
									<h4 style="color: #38b143;">예약한 수업이 없습니다</h4>
									<h7 style="color: gray">수업을 신청하러 가보는게 어떨까요?</h7>
								</div>
	                     	</div> 
						
						     <div class="fitness-buttons-area mb-100" style="text-align: center;">
						   		<!-- 운동용품 쇼핑하기 -->	
						         <a href="/gyp/productList.action" class="btn fitness-btn btn-2 m-2">운동용품 쇼핑하기</a>
						         <!-- 더 둘러보기 -->
						         <a href="/gyp/map.action" class="btn fitness-btn btn-2 m-2">체육관 둘러보기</a>
						         <!-- 예약 확인하기 -->
						         <a href="/gyp/customerMyPage.action#2" class="btn fitness-btn btn-2 m-2">예약 내역 확인하기</a>
						     </div>
					     </c:if>
					     
					     <!-- 예약 내역이 있을 때 (60초마다 페이지 리로드 함)-->
					     <c:if test="${dto != null }">
					     	<!-- 예약 내역은 있으나 링크가 생성되지 않았을 때 -->
					     	<c:if test="${dto.faceLink == null }">
					     	
						     	<div class="row" align="center" style="text-align: center; justify-content: center;">
		                        	<div class="mb-50"> 
										<h4 style="color: #38b143;">예약한 수업의 트레이너님이 열심히 준비중입니다 :)</h4>
							     		<h7 style="color: gray;">(수업시작 시간 5분전에 다시 확인해주세요)</h7><br>
										<font color="gray">기다리시는 동안 아래 활동을 해보시면 어떨까요?</font>
									</div> 
		                     	</div> 
		                     	
		                     	
		                     	<div class="fitness-buttons-area mb-100" style="text-align: center;">
							   		 <!-- 운동용품 쇼핑하기 -->	
							         <a href="/gyp/productList.action" class="btn fitness-btn btn-2 m-2">운동용품 쇼핑하기</a>
							         <!-- 더 둘러보기 -->
							         <a href="/gyp/map.action" class="btn fitness-btn btn-2 m-2">체육관 둘러보기</a>
							         <!-- 예약 확인하기 -->
							         <a href="/gyp/customerMyPage.action#2" class="btn fitness-btn btn-2 m-2">예약 내역 확인하기</a>
						     	</div>
					     	</c:if>	
					     
					     	<!-- 예약 내역이 있고, 링크가 생성되었을 때 -->
					     	<c:if test="${dto.faceLink != null }">
					     		<div class="row" align="center" style="text-align: center; justify-content: center;">
		                        	<div class="mb-50"> 
										<h4 style="color: #38b143;">수업 준비가 완료되었습니다!<br/>트레이너님이 기다리고 있어요</h4>
										<h7 style="color: gray;">(수업 전에 앞서 캠과 마이크를 준비해주세요)</h7>
									</div> 
		                     	</div> 
		                     	<div class="row" align="center" style="text-align: center; justify-content: center;">
			                     	<div class="mb-30"> 
										<h5>&lt; ${dto.gymName} | ${dto.bookHour} | ${dto.gymTrainerPick} 트레이너	&gt;</h5><br/>
									</div>
								</div>
		                     	
		                     	<div class="fitness-buttons-area mb-100" style="text-align: center;">
							         <a target="_blank" href="https://gyp.herokuapp.com/#${dto.faceLink}" class="btn fitness-btn btn-2 m-2">수업 바로 입장하기</a>
							         <!-- 예약 확인하기 -->
							         <a href="/gyp/customerMyPage.action#2" class="btn fitness-btn btn-2 m-2">예약 내역 확인하기</a>
						     	</div>
					     	</c:if>
					     
					     </c:if>
					     
                     </div>
                 </div>			
			</div>
		</div>
		
		</div>
		</div>
	</div>

	<jsp:include page="/WEB-INF/views/layout/footer.jsp" />

	
    <!-- ##### All Javascript Script ##### -->
    <!-- jQuery-2.2.4 js -->
    <script src="/gyp/resources/js/jquery/jquery-2.2.4.min.js"></script>
    <!-- Popper js -->
    <script src="/gyp/resources/js/bootstrap/popper.min.js"></script>
    <!-- Bootstrap js -->
    <script src="/gyp/resources/js/bootstrap/bootstrap.min.js"></script>
    <!-- All Plugins js -->
    <script src="/gyp/resources/js/plugins/plugins.js"></script>
    <!-- Active js -->
    <script src="/gyp/resources/js/active.js"></script>
    


</body>
</html>