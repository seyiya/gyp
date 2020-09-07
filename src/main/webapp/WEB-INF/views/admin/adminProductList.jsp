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
	
	
	<script type="text/javascript">
	function searchData(){
		f = document.searchForm;
		f.action = "<%=cp%>/adminProductList.action";
		f.submit();

	}
	</script>
<title>GYP</title>
</head>
<body style="font-family: 'Noto Sans KR', sans-serif;">

	<jsp:include page="/WEB-INF/views/layout/header_over.jsp" />
	<!-- 메인 : header_main.jsp / 그외 : header_below.jsp -->
	<jsp:include page="/WEB-INF/views/layout/header_below.jsp" />

	<div style="height: 50px;"></div>

	<div id="myPage_wrapper" style="width: 1100px; margin: 0 auto;">
		<div id="content">
			<h5 style="color: green;">Customer Management</h5>
			<h2 class="mb-30">상품 관리</h2>
		
			<div>
				<!-- 검색 -->
				<div id="leftHeader" style="height: 50px; padding-top: 10px; display: inline-block; width: 550px;">
					<form action="" name="searchForm" method="post">
						<select name="searchKey" class="selectField">
							<option value="productId">상품 ID</option>
							<option value="productName">상품 이름</option>
						</select>
						<input type="text" name="searchValue" class="textField">
						<input type="button" value=" 검색 " class="btn2" onclick="searchData();"/>			
					</form>		
				</div>
				
				<!-- 상품등록 -->
				<div id="rightHeader" style=" height: 50px; padding-top: 10px; display: inline-block; width: 550px; float: right; text-align: right;">
					<input type="button" value=" 상품등록 " class="btn2"
					onclick="javascript:location.href='<%=cp%>/adminProductCreated.action?';"/>&nbsp;	
				</div>
				
				
				<div>
					<table width="1100px;" border="1" bordercolor="white">
						<tr style="background-color: #666; color: white;" align="center">
							<td width="100">상품 ID</td>
							<td width="70">이름</td>
							<td width="170">가격</td>
							<td width="100">설명</td>
							<td width="250">사진</td>
							<td width="80">조회수</td>
							<td width="50">수정</td>
							<td width="50">삭제</td>
						</tr>
						
						<c:forEach var="dto" items="${lists}">
							<tr align="center" height="45">
								<td>${dto.productId }</td> 
								<td>${dto.productName}</td>
								<td>${dto.productPrice }</td>
								<td>${dto.productContent }</td>
								<td><a href="${imgPath }${dto.productImg }">
									<img src="${imgPath }${dto.productImg }" width="25" height="25"></a>${dto.productImg }</td>
								<td>${dto.productHit }</td>
								<td><input type="button" value=" 수정 "
										onclick="javascript:location.href='<%=cp%>/adminProductUpdated.action?pageNum=${pageNum}${params }&productId=${dto.productId}';"/></td>
								<td><input type="button" value=" 삭제 "
										onclick="javascript:location.href='<%=cp%>/adminProductDeleted.action?productId=${dto.productId}'"></td>
							</tr>
						</c:forEach>
					</table><br><br>
					<div style="width: 1100px; margin: 0 auto; align-items: center; text-align: center;">
						<p>
							<c:if test="${dataCount!=0 }">
								${pageIndexList }
							</c:if>
							<c:if test="${dataCount==0 }">
								등록된 상품이 없습니다.
							</c:if>
						</p>
					</div>	
					
				</div>
			</div>
		</div>
	</div>
	
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