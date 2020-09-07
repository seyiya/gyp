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
	<!-- notice.css -->
	<link rel="stylesheet" href="/gyp/resources/css/notice.css">

<title>GYP</title>
</head>
<body style="font-family: 'Noto Sans KR', sans-serif;">
	
	<jsp:include page="/WEB-INF/views/layout/header_over.jsp" />
	<!-- 메인 : header_main.jsp / 그외 : header_below.jsp -->
	<jsp:include page="/WEB-INF/views/layout/header_below.jsp" />
	
	<!-- 공지사항 시작 -->
	<section class="contact-area section-padding-100">
	<div class="container">
	<div class="row">
	<div class="col-12">
	<div class="contact-title">
		<h5 style="color:#38b143;">NOTICE</h5>
		<h2>공지사항
		<c:if test="${result==0}"> 
		<input type="button" style="float:right;" class="btn fitness-btn m-2"  value="작성하기" onclick="javascript:location.href='/gyp/noticeCreated.action';">
		</c:if>
		</h2>
	</div>
	</div>
	</div>
	</div>
		
		<div class="container">
		<div class="row">
		<div class="col-12">
		<div class="contact-form-area">
			<c:forEach var="dto" items="${lists }">
			<hr> 
			<div class="row" >
				<div style="width:1000px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
					<!-- 번호 -->
					<font style="color: green; font-weight: bold;">${dto.listNum }</font>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<!-- 제목 -->
					<a href="${articleUrl}&notiNum=${dto.notiNum}">
						${dto.notiTitle }
					</a>
				</div>
				<!-- 날짜 -->
				<div style="width:100px; float: right; margin: 0;">[${dto.notiCreated }]</div>
			</div>	
			</c:forEach>
			<hr>
		</div></div></div></div>
		
		<!-- 여백 -->
		<div style="height: 50px;"></div>
		
		<!-- 페이징 -->
		<div class="container">		
			<c:if test="${dataCount!=0 }">
				<div style="width: 900px; margin: 0 auto; text-align: center;">
				${pageIndexList }</div>
			</c:if>
			<c:if test="${dataCount==0 }">
				<div>등록된 게시물이 없습니다.</div>
			</c:if>
		</div>	
	</section>		

	<div style="height: 50px;"></div>
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
	<!-- notice.js -->
	<script src="/gyp/resources/js/notice.js"></script>
</body>
</html>