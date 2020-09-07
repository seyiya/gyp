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
<script type="text/javascript">
function sendIt(){
	
	f = document.myForm;
	
	str = f.notiTitle.value;
	str = str.trim();
	
	if(!str){
		alert("\n제목을 입력하세요");
		f.notiTitle.focus();
		return;			
	}
	f.notiTitle.value = str; 

	
	str = f.notiContent.value;
	str = str.trim();
	
	if(!str){
		alert("\n내용을 입력하세요");
		f.notiContent.focus();
		return;			
	}
	f.notiContent.value = str; 
	
	if(f.mode.value=="insert")
		f.action = "/gyp/noticeCreated_ok.action";
	else
		f.action = "/gyp/noticeUpdated_ok.action";	
	f.submit();
	
	
}

</script>
</head>
<body style="font-family: 'Noto Sans KR', sans-serif;">
	
	<jsp:include page="/WEB-INF/views/layout/header_over.jsp" />
	<!-- 메인 : header_main.jsp / 그외 : header_below.jsp -->
	<jsp:include page="/WEB-INF/views/layout/header_below.jsp" />


	<section class="contact-area section-padding-100">
	<div class="container">
	<div class="row">
	<div class="col-12">
	<div class="contact-title">
		<h2>공지사항</h2><hr><br>
	</div>
	</div>
	</div>
	<div class="row">
	<div class="col-12">
	<div class="contact-content">
	<div class="contact-form-area">
		<form method="post" action="/notice/noticeCreated.action" name="myForm">
		
			<div class="form-group">
				번호<input type="text" name="notiNum" class="form-control" value="${dto.notiNum }" disabled="disabled"/>
			</div>	
			<div class="form-group">	
				<br>제목<em style="color:red;">*</em><input type="text" name="notiTitle" class="form-control" placeholder="제목을 입력해주세요" value="${dto.notiTitle }"/>
			</div>
			<div class="form-group">
				<br>내용<em style="color:red;">*</em><textarea name="notiContent" rows="12" cols="63" class="form-control" placeholder="내용을 입력해주세요">${dto.notiContent }</textarea>
			</div>
		
		<input type="hidden" name="mode" value="${mode }" />
		<input type="hidden" name="pageNum"	value="${pageNum }"/>
		<!-- update -->
		<input type="hidden" name="notiNum" value="${dto.notiNum }"/>
		
			<c:if test="${mode=='insert'}">
			<input type="button" value="등록하기" class="btn fitness-btn btn-2 mt-30" onclick="sendIt();"/>
			<input type="button" value ="작성취소" class="btn fitness-btn btn-2 mt-30"
			onclick="javascript:location.href='/gyp/noticeList.action';"/>
			</c:if>
					
			<c:if test="${mode=='update'}">
			<input type="button" value="수정하기" class="btn fitness-btn btn-2 mt-30"  onclick="sendIt();"/>
			<input type="button" value ="수정취소" class="btn fitness-btn btn-2 mt-30"
			onclick="javascript:location.href='/gyp/noticeList.action';"/>
			</c:if>
		</form>
		</div>
		</div>
		</div>
		</div>
		</div>
		</section>
	<br><br><br>
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