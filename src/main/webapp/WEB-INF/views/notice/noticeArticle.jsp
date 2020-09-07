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
<!-- notice.css -->
<link rel="stylesheet" href="/gyp/resources/css/notice.css">

<title>GYP</title>
<script type="text/javascript">
function deleteData(){
	
	var notiNum = "${dto.notiNum}";
	var pageNum = "${pageNum}";
	var params = "?notiNum=" + notiNum + "&pageNum=" + pageNum;
	var url = "<%=cp%>/noticeDeleted.action" + params;
	
	location.replace(url);
	
}

function updateData(){
	
	var notiNum = "${dto.notiNum}";
	var pageNum = "${pageNum}";
	var params = "?notiNum=" + notiNum + "&pageNum=" + pageNum;
	var url = "<%=cp%>/noticeUpdated.action" + params;
	
	location.replace(url);
	
}


</script>
</head>
<body style="font-family: 'Noto Sans KR', sans-serif;">

	<jsp:include page="/WEB-INF/views/layout/header_over.jsp" />
	<!-- 메인 : header_main.jsp / 그외 : header_below.jsp -->
	<jsp:include page="/WEB-INF/views/layout/header_below.jsp" />

	<section class="contact-area section-padding-100">
		<div class="container">
		<div class="col-12" style="padding: 0;">
		<div class="contact-form-area row" style="width: 1140px; margin: 0 auto;">
			<div style="width: 1140px; font-size:25px; font-weight: bold; colspan:4; height: 50px;" >
				<!-- 제목 -->
				${dto.notiTitle }
			</div>
			<!-- 날짜 -->
			<div style="colspan:4; width:200px; float: right; margin: 0; padding-top: 10px;">
			작성일 : ${dto.notiCreated }</div>
			<div style="valign:top;colspan:4; width: 1100px;"><hr><br>${dto.notiContent }</div>
		</div>
		
			<br><br><hr>
			<div>
				<font style="color: green; font-weight: bold;">이전글 : </font>
				<c:if test="${!empty preNotiTitle  }">
					<a href="<%=cp%>/noticeArticle.action?pageNum=${pageNum }&notiNum=${preNotiNum}">${preNotiTitle }</a>
				</c:if>
			</div>
			
			<div>
				<font style="color: green; font-weight: bold;">다음글 : </font>
				<c:if test="${!empty nextNotiTitle  }">
					<a href="<%=cp%>/noticeArticle.action?pageNum=${pageNum }&notiNum=${nextNotiNum}">${nextNotiTitle }</a>
				</c:if>
			</div>
			
			<div>
			<c:if test="${result==0}"> 
				<input type="button" class="btn fitness-btn btn-2 mt-30" value="수정" onclick="updateData();">
				<input type="button" class="btn fitness-btn btn-2 mt-30" value="삭제" onclick="deleteData();">
			</c:if>	
				<input type="button" class="btn fitness-btn btn-2 mt-30" value="목록"
					onclick="javascript:location.href='<%=cp%>/noticeList.action?pageNum=${pageNum }';" />
			</div>
		</div>
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