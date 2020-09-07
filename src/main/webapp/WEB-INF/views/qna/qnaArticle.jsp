<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	request.setCharacterEncoding("UTF-8");
String cp = request.getContextPath();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">
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
//삭제
function deleteData() {

	var qnaNum = "${dto.qnaNum}";
	var pageNum = "${pageNum}";
	var params = "?qnaNum=" + qnaNum + "&pageNum=" + pageNum;
	var url = "/gyp/qnaDeleted.action" + params;

	location.replace(url);

}
//수정
function updateData() {

	var qnaNum = "${dto.qnaNum}";
	var pageNum = "${pageNum}";
	var params = "?qnaNum=" + qnaNum + "&pageNum=" + pageNum;
	var url = "/gyp/qnaUpdated.action" + params;

	location.replace(url);

}
//답글
function sendData() {

	var qnaNum = "${dto.qnaNum}";
	var pageNum = "${pageNum}";
	var params = "?qnaNum=" + qnaNum + "&pageNum=" + pageNum;
	var url = "/gyp/qnaReply.action" + params;

	location.replace(url);

}
</script>
</head>
<body style="font-family: 'Noto Sans KR', sans-serif;">

	<jsp:include page="/WEB-INF/views/layout/header_over.jsp" />
	<!-- 메인 : header_main.jsp / 그외 : header_below.jsp -->
	<jsp:include page="/WEB-INF/views/layout/header_below.jsp" />
 

	<section class="contact-area section-padding-100">
		<div class="container" style="width: 1140px;">
		<div class="col-12" style="padding:0px;">
		<div class="contact-form-area">
			<div style="font-size:25px;font-weight: bold;colspan:4; height: 50px;'">
			<!-- 제목 -->
			${dto.qnaTitle }</div>
			<!-- 아이디 , 날짜 -->
			<div style="colspan:4; width:200px;margin: 0; padding-top: 10px;">
			아이디 : ${dto.cusId } <br>
			작성일 : ${dto.qnaCreated }</div>
			<div style="valign:top;colspan:4; width: 1100px;"><hr><br>${dto.qnaContent }</div>
		</div>
		
		<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>
		
		<div>
			<font style="color: green; font-weight: bold;">이전글 : </font>
			<c:if test="${!empty preQnaTitle  }">
				<a href="<%=cp%>/qnaArticle.action?${params }&qnaNum=${preQnaNum}"> ${preQnaTitle } </a>
			</c:if>
		</div>

		<div>
			<font style="color: green; font-weight: bold;">다음글 : </font>
			<c:if test="${!empty nextQnaTitle  }">
				<a href="<%=cp%>/qnaArticle.action?${params }&qnaNum=${nextQnaNum}"> ${nextQnaTitle } </a>
			</c:if>
			<input type="hidden" value="${dto.qnaNum }">
		</div>

		
		<div>
			<!-- 관리자 로그인 -->
			<c:if test="${result==0}"> 
				<input type="button" class="btn fitness-btn btn-2 mt-30" value="답글" onclick="sendData();">
				<input type="button" class="btn fitness-btn btn-2 mt-30" value="삭제" onclick="deleteData();">
				
			</c:if>
			<!-- 본인 게시물일때 -->
			<c:if test="${sessionScope.customInfo.sessionId == dto.cusId && cusId!=null && cusId!='admin'}">
				<input type="button" class="btn fitness-btn btn-2 mt-30" value="수정" onclick="updateData();">
				<input type="button" class="btn fitness-btn btn-2 mt-30" value="삭제" onclick="deleteData();">
			</c:if>
			<!-- 로그인안했을때 -->
			<input type="button" class="btn fitness-btn btn-2 mt-30" value="목록" onclick="javascript:location.href='/gyp/qnaList.action?${params }';" />
		</div>
		</div>
		</div>
	</section>
	
	
	
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
	<!-- qna.js -->
	<script src="/gyp/resources/js/qna.js"></script>


</body>
</html>