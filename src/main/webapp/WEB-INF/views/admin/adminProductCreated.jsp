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

<script type="text/javascript">
		
	function sendIt(){
		
		f = document.myForm;
		
		if(f.mode.value!='update'){
			//상품아이디 체크
			str = f.productId.value;
			str = str.trim();
			if(!str){
				alert("\n상품 ID를 입력하세요.");
				f.productId.focus();
				return;
			}
			f.productId.value = str;
		}
		
		//상품이름 체크
		str = f.productName.value;
		str = str.trim();
		if(!str){
			alert("\n상품 이름을 입력하세요.");
			f.productName.focus();
			return;
		}
		f.productName.value = str;
		
		//상품이미지 체크
		//(수정일 경우, 이미지 변경 없으면 비어있을 수 있으므로 조건 추가함)
		if(!f.upload.value && !f.mode.value=='update'){
			alert("\n상품 사진을 입력하세요.");
			f.upload.focus();
			return;
		}
	
		//상품가격 체크
		str = f.productPrice.value;
		str = str.trim();
		if(!str){
			alert("\n상품 가격을 입력하세요.");
			f.productPrice.focus();
			return;
		}
		f.productPrice.value = str;
		
		//상품내용 체크
		str = f.productContent.value;
		str = str.trim();
		if(!str){
			alert("\n상품 내용을 입력하세요.");
			f.productContent.focus();
			return;
		}
		f.productContent.value = str;
		

		
		f.action = "<%=cp%>/adminProductUpdated_ok.action";
		f.submit();
	}
	
</script>

<style type="text/css">
	td{
		font-weight: bold;
	}

</style>

</head>
<body style="font-family: 'Noto Sans KR', sans-serif;">

	<jsp:include page="/WEB-INF/views/layout/header_over.jsp" />
	<!-- 메인 : header_main.jsp / 그외 : header_below.jsp -->
	<jsp:include page="/WEB-INF/views/layout/header_below.jsp" />
	
	<div style="height: 50px;"></div>
	<form action="" method="post" name="myForm" enctype="multipart/form-data">
		<div id="myPage_wrapper" style="width: 1100px; margin: 0 auto;">
			<div id="content">
				<h5 style="color: green;">Customer Management</h5>
				
				<c:if test="${mode != 'update' }">
					<h2 class="mb-30">상품 등록하기</h2>
				</c:if>
				
				<c:if test="${mode == 'update' }">
					<h2 class="mb-30">상품 수정하기</h2>
				</c:if>
				
				<table>
					<tr height="40">
						<td width="100">상품 ID</td>
						<td><input type="text" name=productId value="${dto.productId }" size="35" maxlength="20" class="boxTF" disabled="disabled"/></td>
					</tr>
					<tr height="40">
						<td>상품 이름</td>
						<td><input type="text" name="productName" value="${dto.productName }" size="35" maxlength="20" class="boxTF"/></td>
					</tr>
					
					<!-- 수정할떄 -->
					<c:if test="${mode == 'update' }">
					<tr height="40">
						<td>기존 이미지</td>
						<td><input type="text" name="oldImageName" value="${oldImageName}" size="35" maxlength="20" class="boxTF" disabled="disabled"/>
						</td>
					</tr>
					<tr height="40">
						<td>수정할 이미지</td>
						<td><input type="file" name="upload" size="35" maxlength="20" class="boxTF" id="newImage"/></td>
					</tr>
					</c:if>
					
					
					<c:if test="${mode != 'update' }">
					<tr height="40">
						<td>상품 이미지</td>
						<td><input type="file" name="upload" size="35" maxlength="20" class="boxTF" id="newImage"/></td>
					</tr>
					</c:if>
					
					
					
					<tr height="40">
						<td>상품 가격</td>
						<td><input type="text" name="productPrice" value="${dto.productPrice }" size="35" maxlength="20" class="boxTF"/></td>
					</tr>
					<tr height="40">
						<td>상품 설명</td>
						<td><textarea rows="5" cols="40" name="productContent">${dto.productContent }</textarea></td>
					</tr>
					
					<!-- 등록하기 -->
					<c:if test="${mode != 'update' }">
					<tr height="60" valign="middle">
						<td colspan="2" align="center">
						<div style="width: 100px; display: inline-block;"></div>
						<input type="button" value=" 등록하기 " class="btn2" 
						onclick="sendIt();"/>
						<input type="reset" value=" 다시입력 " class="btn2" 
						onclick="document.myForm.productId.focus();"/>
						<input type="button" value=" 작성취소 " class="btn2" 
						onclick="javascript:location.href='<%=cp%>/adminProductList.action';"/>
						</td>
					</tr>
					</c:if>
					
					<!-- 수정하기 -->
					<c:if test="${mode == 'update' }">
					<tr height="60" valign="middle">
						<td colspan="2" align="center">
						<div style="width: 100px; display: inline-block;"></div>
						<input type="button" value=" 수정하기 " class="btn2" 
						onclick="sendIt();"/>
						<input type="button" value=" 수정취소 " class="btn2" 
						onclick="javascript:location.href='<%=cp%>/adminProductList.action?pageNum=${pageNum }${params }';"/>
						<!-- 히든 값 -->
						<input type="hidden" name="mode" value="${mode }">
						<input type="hidden" name="oldImageName" value="${oldImageName }">
						<input type="hidden" name="productImg" value="${dto.productImg }">
						<input type="hidden" name="productId" value="${dto.productId }">
						<input type="hidden" name="params" value="${params }">
						</td>
					</tr>
					</c:if>
					
					
					
				</table>
			</div>
		</div>
	</form>

	<div style="height: 100px;"></div>

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


</body>
</html>
