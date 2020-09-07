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
	<!-- font -->	
	<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400&display=swap" rel="stylesheet">

<title>GYP</title>
</head>
<body style="font-family: 'Noto Sans KR', sans-serif;">
	<jsp:include page="/WEB-INF/views/layout/header_over.jsp" />
	<jsp:include page="/WEB-INF/views/layout/header_below.jsp" />

	<div style="height: 130px;"></div>
	
	<div class="our-newsletter-area mb-100" style="width: 400px; margin: 0 auto;">
		<div class="section-heading">
			<h6 align="center">JOIN GYP</h6>
			<h2 align="center">회원가입</h2>
		</div>
	</div>
	
	
	<div style="width: 525px; margin: 0 auto;">	
	
		<div style="display: inline-block; text-align: center; justify-content: center;">		
			<!-- 개인회원가입 -->
			<div style="margin-left:25px; margin-right: 25px; opacity: 60%; color: #38b143">
				<i class="fas fa-id-card-alt fa-10x" onclick="javascript:location.href='<%=cp%>/createCustomer.action';"></i>
			</div>
			<div style="height: 30px;"></div>
			<div style="margin-left:25px; margin-right: 25px;">
				<input type="button" class="btn fitness-btn btn-2" 
				style="font-size:14pt; width:210px;height:50px; background-color:#38b143; border: none;" value="개인 회원가입" 
				onclick="javascript:location.href='<%=cp%>/createCustomer.action';"/>
			</div>
		</div>
		
		<div style="display: inline-block; text-align: center; justify-content: center;"">
			<!-- 체육관회원가입 -->
			<div style="margin-left:25px; margin-right: 25px;  opacity: 40%; color:#002266">
				<i class="fas fa-id-card-alt fa-10x" onclick="javascript:location.href='<%=cp%>/createGym.action';"></i>			
			</div>
			<div style="height: 30px;"></div>
			<div style="margin-left:25px; margin-right: 25px;">
				<input type="button" class="btn fitness-btn btn-2"
				style="font-size:14pt; width:210px;height:50px;  background-color:#002266; border: none;"  value="체육관 회원가입"
				onclick="javascript:location.href='<%=cp%>/createGym.action';"/>
			</div>
		</div>
		
	</div>
	
	
	<div style="height: 200px;"></div>
	
	


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