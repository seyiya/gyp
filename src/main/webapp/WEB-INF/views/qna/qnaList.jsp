<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
	<!-- qna.css -->
	<link rel="stylesheet" href="/gyp/resources/css/qna.css">
	
<title>GYP</title>

<script type="text/javascript">

function makeQuestion(){
	
	f = document.myForm;

	f.action = "javascript:location.href='/gyp/qnaCreated.action'";
	
	if(!f.customInfo.value){
		alert("로그인 해주세요");
		f.action = "javascript:location.href='/gyp/login.action'";
	}
	
	f.submit();
	
}

</script>




</head>
<body style="font-family: 'Noto Sans KR', sans-serif;">
	<jsp:include page="/WEB-INF/views/layout/header_over.jsp" />
	<!-- 메인 : header_main.jsp / 그외 : header_below.jsp -->
	<jsp:include page="/WEB-INF/views/layout/header_below.jsp" />
	
	
	<!-- 큐엔에이 시작 -->
	<section class="contact-area section-padding-100">
	<div class="container">
	<div class="row">
	<div class="col-12">
	<div class="contact-title">
		<h5 style="color:#38b143;">QUESTION</h5>
		<form name="myForm" method="post">
		<h2>Q&A&nbsp;&nbsp;&nbsp;
		<input type="hidden" value="${customInfo}" name="customInfo">
		</h2>
		</form>
	</div>
	</div>
	</div>
	</div>	
		
		<div class="container"  style="width: 1140px;">
			<form name="searchForm" method="post">
				
				<div style="display: inline-block;">
					<div class="row">
						<div style="width: 800px; padding-top: 10px;">&nbsp;&nbsp;&nbsp;&nbsp;
							<select name="searchValue" style="border: none; background-color:#EAEAEA; height: 32px; font-size: 11pt;">
								<option value="">전체</option>
								<option value="체육관">체육관</option>
								<option value="이용권">이용권</option>
								<option value="쇼핑몰">쇼핑몰</option>				
							</select>
							<input type="text" placeholder="&nbsp;&nbsp;어떤 도움이 필요하세요?" name="searchValue2" 
							style="border: none; background-color:#EAEAEA; height: 32px; font-size: 11pt;">
							<input type="submit" class="fas fa-search"  onclick="sendIt();"
							style="width:42px;height:32px;border: none;background-color:#38b143;color: white;" value="&#xf002;"/>
						</div>
						<div style="width:330px; text-align:right; float: right;">
						<input type="button" class="btn fitness-btn m-2" value="1:1 문의 남기기" onclick="makeQuestion();"
						style="float:right;  margin: 0 !important;" />
						</div>
					</div>
				</div>
				
			</form>
		</div>
		
		<div class="container">
		<div class="row">
		<div class="col-12">
		<div class="contact-form-area">
			<c:forEach var="dto" items="${lists }">
			
			<div class="row">
				<div style="width:1140px; height:55px; ">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
					<!-- 번호 --><hr style="margin: 0; padding-top: 18px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<font style="color: green; font-weight: bold;">${dto.listNum }</font>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<!-- 제목 -->
					<c:if test="${dto.qnaDepth!=0}"><!-- 답글 depth -->
						<c:forEach var="i" begin="1" end="${dto.qnaDepth }" step="1">
							&nbsp;&nbsp;
						</c:forEach>
					</c:if>
					<c:set var="qnaType" value="${dto.qnaType}"/>
					<a href="${articleUrl}&qnaNum=${dto.qnaNum}">[${fn:substring(qnaType,0,3)}] ${dto.qnaTitle }</a>
					<!-- 날짜 및 질문자-->
					<div style="width:250px; float: right; margin: 0; text-align: right;">${dto.qnaCreated }&nbsp;(질문자 : ${dto.cusId })&nbsp;&nbsp;&nbsp;&nbsp;</div>	
				</div>
			</div>
			</c:forEach>
		</div></div></div></div>
		
		<!-- 여백 -->
		<div style="height: 50px;"></div>
				
		<div class="container" style="width: 1100px; margin: 0 auto; text-align: center;">	
			<c:if test="${dataCount!=0 }">
				${pageIndexList }
			</c:if>
			<c:if test="${dataCount==0 }">
				등록된 게시물이 없습니다.
			</c:if>
		</div>
	</section>		
	
	<div style="height: 50px;"></div>
	<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
	
	
	<script type="text/javascript">
	function sendIt(){
		
		f = document.searchForm;
		f.action="/gyp/qnaList.action";
		f.submit();
	}
	</script>


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
	<!-- qna.js -->
	<script src="/gyp/resources/js/qna.js"></script>
<!-- fontawesome(검색버튼) -->
	<script src="https://kit.fontawesome.com/4badd96a47.js" crossorigin="anonymous"></script>
</body>
</html>