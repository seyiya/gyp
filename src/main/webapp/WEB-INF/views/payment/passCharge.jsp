<%@page import="com.exe.dto.CustomInfo"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
	<!-- jQuery-2.2.4 js -->
    <script src="/gyp/resources/js/jquery/jquery-2.2.4.min.js"></script>
    <!-- iamport payment js -->
 	<script type="text/javascript" src="https://cdn.iamport.kr/js/iamport.payment-1.1.5.js"></script>
 	
	<!-- 결제 -->
	<link rel="stylesheet" href="/gyp/resources/css/payment.css">
	
<title>GYP</title>
</head>
<body style="font-family: 'Noto Sans KR', sans-serif;">
	
	<jsp:include page="/WEB-INF/views/layout/header_over.jsp" />
	<jsp:include page="/WEB-INF/views/layout/header_below.jsp" />

	<!-- 제목 시작 -->
	<section class="contact-area section-padding-100">
	<div class="container">
	<div class="row">
	<div class="col-12">
	<div class="contact-title">
		<h5 style="color:#38b143;">PASS CHARGE</h5>
		<form name="myForm" method="post">
		<h2>이용권 구입&nbsp;&nbsp;&nbsp;
		<input type="hidden" value="${customInfo}" name="customInfo">
		</h2>
		</form>
	</div>
	</div>
	</div>
	</div>	



	<div class="container">
		<div class="row justify-content-center mt-100" style="margin-top: 30px!important; margin-bottom: 70px;">
			<c:forEach var="i" begin="0" end="${passKind.size()-1}">
				<!-- Single Price Table -->
				<div class="col-12 col-md-6 col-lg-4">
					<div class="single-price-table mb-100">
						<div class="price-table-content">
							<h2 class="price">
								${passKind[i]}<span> &nbsp;pass</span>
							</h2>
							<h5>
								<span>&#8361;<fmt:formatNumber value="${passKind[i] * pricePerPass}" pattern="#,###" /></span>
							</h5>
							<div class="description" style="font-size: 12pt; color:#bbbbbb;">&nbsp;${passDescription[i] }</div>
							<a href="/gyp/payment.action?pass=pass_${passKind[i] }"
								class="btn fitness-btn mt-30">구매하기</a>
						</div>
					</div>
				</div>
			</c:forEach>
		</div>
	</div>
		
	

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