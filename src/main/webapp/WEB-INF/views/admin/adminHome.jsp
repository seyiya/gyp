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
	<!-- Favicon -->
	<link rel="icon" href="/gyp/resources/img/core-img/favicon.ico">
	<!-- Core Stylesheet -->
	<link rel="stylesheet" href="/gyp/resources/css/style.css">
	<link rel="stylesheet" href="/gyp/resources/css/adminHome.css">
	<!-- font -->
	<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400&display=swap" rel="stylesheet">
	

<title>GYP</title>
</head>
<body style="font-family: 'Noto Sans KR', sans-serif;">

	<jsp:include page="/WEB-INF/views/layout/header_over.jsp" />
	<!-- 메인 : header_main.jsp / 그외 : header_below.jsp -->
	<jsp:include page="/WEB-INF/views/layout/header_below.jsp" />
	
	<div style="height: 50px;"></div>
	
	<!-- 제목 -->
	<section class="contact-area section-padding-100">
	<div class="container">
	<div class="row">
	<div class="col-12">
	<div class="contact-title">
		<h5 style="color:#38b143;">ADMIN</h5>
		<form name="myForm" method="post">
		<h2>관리자 홈&nbsp;&nbsp;&nbsp;
		<input type="hidden" value="${customInfo}" name="customInfo">
		</h2>
		</form>
	</div>
	</div>
	</div>
	</div>
	
	<div style="height: 50px;"></div>
		
<center>

	<div style="width: 1155px; margin: 0 auto;  display: inline-block;" >
		<!-- qna -->
		<div style=" display: inline-block; margin: 50px 36px;">
			<div>
				<i class="fab fa-quora fa-10x" style="color: #000042;"
				onclick="javascript:location.href='<%=cp%>/qnaList.action';"></i>
			</div>
			<div style="height: 10px;"></div>
			<div>
				<input type="button" class="btn fitness2-btn btn-2" 
				style="font-size:17px; min-width:150px;" value="Q&A 관리"
				onclick="javascript:location.href='<%=cp%>/qnaList.action';"/>
			</div>
		</div>
		
		<!-- 공지사항 -->
		<div style=" display: inline-block; margin: 50px 36px;">
			<div>
				<i class="fas fa-bullhorn fa-10x" style="color: #000042;" 
				onclick="javascript:location.href='<%=cp%>/noticeList.action';"></i>
			</div>
			<div style="height: 20px;"></div>
			<div>
				<input type="button" class="btn fitness2-btn btn-2" 
				style="font-size:17px; min-width:150px;"  value="공지사항 관리"
				onclick="javascript:location.href='<%=cp%>/noticeList.action';"/>
			</div>
		</div>
		
		<!-- 회원관리 -->
		<div style=" display: inline-block; margin: 50px 36px;">
			<div>
				<i class="fas fa-id-card-alt fa-10x" style="color: #000042;"
				onclick="javascript:location.href='<%=cp%>/adminCustomerList.action';"></i>
			</div>
			<div style="height: 20px;"></div>
			<div>
				<input type="button" class="btn fitness2-btn btn-2" 
				style="font-size:17px;min-width:150px;" value="회원 관리"
				onclick="javascript:location.href='<%=cp%>/adminCustomerList.action';"/>
			</div>
		</div>
		
		<!-- 체육관 관리 -->
		<div style=" display: inline-block; margin: 50px 36px;">
			<div>
				<i class="fas fa-id-card-alt fa-10x" style="color: #000042;"
				onclick="javascript:location.href='<%=cp%>/adminGymList.action';"></i>
			</div>
			<div style="height: 20px;"></div>
			<div>
				<input type="button" class="btn fitness2-btn btn-2" 
				style="font-size:17px;min-width:150px;"  value="체육관 관리 "
				onclick="javascript:location.href='<%=cp%>/adminGymList.action';"/>
			</div>
		</div>
		
		<!-- 상품관리 -->
		<div style=" display: inline-block; margin: 40px 36px;">
			<div>
				<i class="fas fa-chart-line fa-10x" style="color: #000042;"
				onclick="javascript:location.href='<%=cp%>/adminProductList.action';"></i>
			</div>
			<div style="height: 10px;"></div>
			<div>
				<input type="button" class="btn fitness2-btn btn-2" 
				style="font-size:17px; min-width:150px;"  value="상품 관리"
				onclick="javascript:location.href='<%=cp%>/adminProductList.action';"/>
			</div>
		</div>
	
	</div>
	
	<div style="height: 300px;"></div>
</center>	
	
	
	
	
	
	
	
	
	<!-- 
	<a href="/gyp/adminGymList.action">체육관 관리</a><br>
	<a href="/gyp/adminCustomerList.action">회원 관리</a><br>
	<a href="/gyp/noticeList.action">공지사항 관리</a><br>
	<a href="/gyp/qnaList.action">Q&A 관리</a><br>
	<a href="/gyp/adminProductList.action">상품 관리</a><br>
	 -->
	
	
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
    
    <!-- font awesome -->
	<script src="https://kit.fontawesome.com/4badd96a47.js" crossorigin="anonymous"></script>
    
</body>
</html>