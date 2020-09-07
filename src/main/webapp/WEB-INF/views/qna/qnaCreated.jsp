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
function sendIt() {

	f = document.myForm;

	str = f.qnaTitle.value;
	str = str.trim();

	if (!str) {
		alert("\n제목을 입력하세요");
		f.qnaTitle.focus();
		return;
	}
	f.qnaTitle.value = str;
	
	str = f.mode.value;
	if(!($('input:radio[name="qnaType"]').is(':checked'))&&(str=="insert")){
		alert("\n문의유형을 선택해주세요");
		location.reload();
		return;
	}
	f.mode.value = str;
	
	str = f.qnaContent.value;
	str = str.trim();

	if (!str) {
		alert("\n내용을 입력하세요");
		f.qnaContent.focus();
		return;
	}
	f.qnaContent.value = str;

	if (f.mode.value=="insert")
		f.action = "/gyp/qnaCreated_ok.action";
	else if(f.mode.value=="update")
		f.action = "/gyp/qnaUpdated_ok.action";
	else if(f.mode.value=="reply")
		f.action = "/gyp/qnaReply_ok.action";
	
	f.submit();
}


function qnaTypeCheck(){
	/*
	var chkcount = document.getElementsByName("qnaType").length;
	
	for(var i=0;i<chkcount;i++){
		if(document.getElementsByName("qnaType")[i].checked == true){
			var qnaTypeChk = document.getElementsByName("qnaType")[i].value;
			$('input[name=qnaTitle]').attr('value','['+qnaTypeChk+']');
		}
	}
	*/
}

</script>

</head>
<body style="font-family: 'Noto Sans KR', sans-serif;">

	<jsp:include page="/WEB-INF/views/layout/header_over.jsp" />
	<!-- 메인 : header_main.jsp / 그외 : header_below.jsp -->
	<jsp:include page="/WEB-INF/views/layout/header_below.jsp" />
<!-- 제목 -->
	<section class="contact-area section-padding-100">
	<div class="container">
	<div class="row">
	<div class="col-12">
	<div class="contact-title" style="width: 700px; margin: 0 auto;">
		<h2>1:1 문의하기</h2><hr><br>
	</div>
	</div>
	</div>
	
	
	<div class="row">
	<div class="col-12">
	<div class="contact-content">
	<div class="contact-form-area">
		<form method="post" action="/gyp/qnaCreated.action" name="myForm" style="width: 700px; margin: 0 auto;">
		<!-- (참고) form-group 하나에 1개의 form-control만 작동함... -->
				<!-- 번호 -->
				<div class="form-group">
					<font class = "bokyung_qnaCreatedFont">질문 번호</font>
					<input type="text" name="listNum" class="form-control" value="${dto.listNum }" disabled="disabled"
					style="margin-top: 10px; font-size: 12pt;"/>
				</div>
				
				<div class="form-group"><br>	
					<font class = "bokyung_qnaCreatedFont">작성자</font>
					<input type="text" name="cusId" class="form-control" value="${dto.cusId }" disabled="disabled"
					style="margin-top: 10px; font-size: 12pt;"/>
				</div>
				
				<!-- 문의 -->
				<c:if test="${mode=='insert'}"><br>	
					<font class = "bokyung_qnaCreatedFont">문의유형 선택</font>
					<em style="color:red;">*</em><!-- 별표 -->&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<input type="radio" name="qnaType" value="체육관" onclick="qnaTypeCheck()" style="font-size: 12pt;"/>&nbsp;&nbsp;체육관&nbsp;&nbsp;&nbsp;&nbsp; 
						<input type="radio" name="qnaType" value="이용권" onclick="qnaTypeCheck()" style="font-size: 12pt;"/>&nbsp;&nbsp;이용권&nbsp;&nbsp;&nbsp;&nbsp;
						<input type="radio" name="qnaType" value="쇼핑몰" onclick="qnaTypeCheck()" style="font-size: 12pt;"/>&nbsp;&nbsp;쇼핑몰&nbsp;&nbsp;&nbsp;&nbsp; 			
				</c:if>
				
				<div class="form-group"><br><br>
					<font class = "bokyung_qnaCreatedFont">제목</font>
					<em style="color:red;">*</em><!-- 별표 -->
					<input type="text" name="qnaTitle" class="form-control" placeholder="제목을 입력해주세요" value="${dto.qnaTitle }" 
					style="margin-top: 10px; font-size: 12pt; ">
				</div>
				<div class="form-group" style="margin-top: 10px;"><br><br>
					<font class = "bokyung_qnaCreatedFont">내용</font>
					<em style="color:red;">*</em><!-- 별표 -->
					<textarea name="qnaContent" rows="12" cols="63" class="form-control" placeholder="운영체제와 브라우저를 함께 적어주시면 정확한 문제 해결에 도움이 됩니다." 
					style="margin-top: 10px; font-size: 12pt;">${dto.qnaContent }</textarea>
				</div>
				
			<!-- reply필요한 파라미터 -->
				<input type="hidden" name="qnaType" value="${dto.qnaType }"/>			
				<input type="hidden" name="qnaGroupNum" value="${dto.qnaGroupNum }"/>
				<input type="hidden" name="qnaOrderNo" value="${dto.qnaOrderNo }"/>
				<input type="hidden" name="qnaDepth" value="${dto.qnaDepth }"/>
				<input type="hidden" name="qnaParent" value="${dto.qnaNum }"/>
			<!-- insert 필요한 파라미터 -->	
				<input type="hidden" name="mode" value="${mode }"/>
			<!-- update 필요한 파라미터 -->	
				<input type="hidden" name="pageNum" value="${pageNum }"/>
				<input type="hidden" name="qnaNum" value="${dto.qnaNum }" />
				
				<div style="width: 700px; margin: 0 auto; justify-content: center; text-align: center;">
				<c:if test="${mode=='insert'}">
					<input type="button" class="btn fitness-btn btn-2 mt-30" value="등록하기" onclick="sendIt();" />
					<input type="button" class="btn fitness-btn btn-2 mt-30" value="작성취소" onclick="javascript:location.href='/gyp/qnaList.action';" />
				</c:if>
	
				<c:if test="${mode=='update'}">
					<input type="button" class="btn fitness-btn btn-2 mt-30" value="수정하기" onclick="sendIt();" />
					<input type="button" class="btn fitness-btn btn-2 mt-30" value="수정취소" onclick="javascript:location.href='/gyp/qnaList.action';" />
				</c:if>
				
				<c:if test="${mode=='reply'}">
					<input type="button" class="btn fitness-btn btn-2 mt-30" value="답변하기" onclick="sendIt();" />
					<input type="button" class="btn fitness-btn btn-2 mt-30" value="작성취소" onclick="javascript:location.href='/gyp/qnaList.action';" />
				</c:if>
				</div>
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
	<!-- qna.js -->
	<script src="/gyp/resources/js/qna.js"></script>
	
</body>
</html>