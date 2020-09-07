<%@page import="com.exe.dto.CustomInfo"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
   request.setCharacterEncoding("UTF-8");
   String cp = request.getContextPath();

%>
<!DOCTYPE html>
<html>
<head>
   <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
   <meta http-equiv="X-UA-Compatible" content="IE=edge">
   <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
   <!-- Favicon -->
   <link rel="icon" href="/gyp/resources/img/core-img/favicon.ico">
   <!-- Core Stylesheet -->
   <link rel="stylesheet" href="/gyp/resources/css/style.css">
   <!-- font -->
   <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400&display=swap" rel="stylesheet">
   <!-- jQuery-2.2.4 js -->
    <script src="/gyp/resources/js/jquery/jquery-2.2.4.min.js"></script>
    <!-- iamport payment js -->
    <script type="text/javascript" src="https://cdn.iamport.kr/js/iamport.payment-1.1.5.js"></script>
    
   <!-- 결제 -->
   <link rel="stylesheet" href="/gyp/resources/css/payment.css">
   
   <style type="text/css">
   
   /*수정, 쓰기*/
	a.bokyung_mypage_link
		{color:#7a7ebf;}
	
	a.bokyung_mypage_link:visited
		{color:#7a7ebf; text-decoration:none;}
	
	a.bokyung_mypage_link:hover
		{color:#2E338C; text-decoration:none;}
   
   </style>
   
   
   
<title>GYP</title>
</head>
<body style="font-family: 'Noto Sans KR', sans-serif;">
   
   <jsp:include page="/WEB-INF/views/layout/header_over.jsp" />
   <jsp:include page="/WEB-INF/views/layout/header_below.jsp" />
   
   
   <div style="height: 100px;"></div>
	
	<div class="our-newsletter-area mb-100" style="width: 630px; margin: 0 auto; margin-bottom: 15px!important;">
		<div class="section-heading">
			<h6 align="center">THANK YOU</h6>
			<h2 align="center">결제 완료</h2>
			<div style="height: 10px;"></div>
			<hr>
		</div>
	</div>
   
    <!-- ##### Contact Area Start ##### -->
    <section class="contact-area section-padding-100" style="padding-top: 0;">
        <div class="container">
        <div style="width: 750px; margin: 0 auto;">
            <div class="row"> 
                <div class="col-12">
                    <div class="contact-content">
                        <!-- Contact Form Area -->
                        <div class="contact-form-area">
                        	<div class="row" align="center" style="text-align: center; justify-content: center;">
	                        		<img alt="reservation-check" src="/gyp/resources/img/check.png"
	                        		style="width:110px; height:110px; margin-right: 40px;">
	                          	<div class="mb-70" style="margin-top: 15px;">
									  <h4 style="color: #38b143">고객님의 상품 주문이 완료되었습니다.</h4>
		                              <h6>주문내역은 마이페이지에서 확인할 수 있습니다.</h6>
		                              기타 문의는 <a href="/gyp/qnaList.action" class="bokyung_mypage_link">Q&amp;A 게시판</a>을 이용해주세요. 
								</div>
                        	</div> 
								
						     <div class="fitness-buttons-area mb-100" style="text-align: center; margin-bottom: 20px!important;">
						   		<!-- 운동용품 쇼핑하기 -->	
						         <a href="/gyp/productList.action" class="btn fitness-btn btn-2 m-2">운동용품 쇼핑하기</a>
						         <!-- 더 둘러보기 -->
						         <a href="/gyp/map.action" class="btn fitness-btn btn-2 m-2">더 둘러보기</a>
						         <!-- 예약 확인하기 -->
						         <a href="/gyp/customerMyPage.action#2" class="btn fitness-btn btn-2 m-2">예약 확인하기</a>
						     </div>
                        </div>
                    </div>
                </div>
           </div> 
           </div>
        </div>
    </section>
    
   <jsp:include page="/WEB-INF/views/layout/footer.jsp" />

   
    <!-- ##### All Javascript Script ##### -->
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