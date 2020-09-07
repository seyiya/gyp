<%@page import="com.exe.dto.CustomInfo"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
	request.setCharacterEncoding("UTF-8");
	String cp = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">
<link
	href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.3.0/css/datepicker.css"
	rel="stylesheet" type="text/css" />
<!-- Favicon -->
<link rel="icon" href="/gyp/resources/img/core-img/favicon.ico">
<!-- Core Stylesheet -->
<link rel="stylesheet" href="/gyp/resources/css/style.css">
<!-- font -->
<link
	href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400&display=swap"
	rel="stylesheet">
<!-- jQuery-2.2.4 js -->
<script src="/gyp/resources/js/jquery/jquery-2.2.4.min.js"></script>
<!-- 상품상세 CSS -->
<link rel="stylesheet" href="/gyp/resources/css/productDetail.css"
	type="text/css">
<link rel="stylesheet" href="/gyp/resources/css/gymDetail.css">


<!-- js -->
<script type="text/javascript">
	
	function onlyNumber(event){
	    event = event || window.event;
	    var keyID = (event.which) ? event.which : event.keyCode;
	    if ( (keyID >= 48 && keyID <= 57) || (keyID >= 96 && keyID <= 105) || keyID == 8 || keyID == 46 || keyID == 37 || keyID == 39 ) 
	        return;
	    else
	        return false;
	}
	 
	function removeChar(event) {
	    event = event || window.event;
	    var keyID = (event.which) ? event.which : event.keyCode;
	    if ( keyID == 8 || keyID == 46 || keyID == 37 || keyID == 39 ) 
	        return;
	    else
	        event.target.value = event.target.value.replace(/[^0-9]/g, "");
	}
	
	function sendIt() {
	
	var f = document.myForm;
	
	//비로그인 시 로그인 창으로
	<c:if test="${empty sessionScope.customInfo.sessionId }">
	alert("\n로그인 해주세요")
	location.href = "/gyp/login.action";
	return;
	</c:if>
	
	
	
	//수량 빈칸 체크
	str = f.count.value;
	str = str.trim();
	if (!str) {
		alert("\n수량을 입력하세요.");
		f.count.focus();
		return;
	}
	f.count.value = str;	
	
		
	alert("장바구니에 상품이 담겼습니다.");
	
	f.action = "<%=cp%>/productDetail_ok.action?productId=${dto.productId}&pageNum=${pageNum}";
	f.submit();

	}
	
	function buyNow(){
		var f = document.myForm;
		
		//비로그인 시 로그인 창으로
		<c:if test="${empty sessionScope.customInfo.sessionId }">
			alert("\n로그인 해주세요")
			location.href = "/gyp/login.action";
			return;
		</c:if>
		
		//수량 빈칸 체크
		str = f.count.value;
		str = str.trim();
		if (!str) {
			alert("\n수량을 입력하세요.");
			f.count.focus();
			return;
		}
		f.count.value = str;
		
		f.action = "<%=cp%>/payment.action?productSelected=${dto.productId}";
		f.submit();
	}
	
</script>

<title>GYP</title>
</head>
<body style="font-family: 'Noto Sans KR', sans-serif;">

	<jsp:include page="/WEB-INF/views/layout/header_over.jsp" />
	<jsp:include page="/WEB-INF/views/layout/header_below.jsp" /> 

	<div class="blog-area mt-20 section-padding-100"> 
		<div class="container">
			<div class="wrapper_inner" style="">
				<font color="#888" size="3pt">&nbsp;&nbsp; 
					상품코드 - ${dto.productId } &nbsp;|&nbsp; 조회수 - ${dto.productHit } </font>   
				
				<hr/>
				<div class="gallery mt-30 col-12 row mt-50" style="margin: 0;">
					<!-- 상품 사진 -->
					<div class="gallery_article gallery_item_preview col-6">
						<a href="${imagePath }/${dto.productImg}">  
						<img alt="그림" src="${imagePath }/${dto.productImg}" 
						style="height:460px; width:460px; object-fit: cover; border: 7px double #dae6c3;
						margin:auto;"></a>
					</div>
		 	
					<!-- 상품 정보 -->
					<div class="col-6">
						<form action="" name="myForm" method="post" style="margin-left: 15px;">
						
							<!-- hidden parameters -->
							<input type="hidden" id="productId" name="productId" value="${dto.productId }" />
							<input type="hidden" id="cusId" name="cusId" value="${info.sessionId }" />  
							<input type="hidden" id="price" name="price" value="${dto.productPrice }"/>
						
							<!-- 제목 -->
							<font style="font-size: 10pt" color="gray">[${dto.productId}]</font>&nbsp;&nbsp;
							<font style="font-size: 20pt; font-weight:bolder;" color="#38b143">${dto.productName}</font>
							<br>
							<hr>
							
							<!-- 상품설명 -->
							<font size="4px" color="#8C8C8C">${dto.productContent }&nbsp;</font>
							<br><br><hr/>
		 
							<!-- 가격 --> 
							<div style="display: inline-block; width: 100%; vertical-align: middle;">
								<div style="display: inline-block;">
								<input class="form-control" type="number" value="1" name="count" id="count-product" min="1" max="100"
									style="text-align: center; width:100px; font-size: 15pt; vertical-align: middle; 
									padding-left: 22px;"></div>
								<div style="display: inline-block;"><font style="font-size: 20px;">&nbsp;&nbsp;개</font></div>
								<div style="display: inline-block; float: right; padding-top: 7px;">
								<font style="font-size: 20px;" color="#38b143"><fmt:formatNumber value="${dto.productPrice }" pattern="#,###" />원&nbsp;</font>
								<font style="font-size: 20px;" color="#BDBDBD">(1개당)</font></div>
							</div>
							
		
							<!-- 옵션 -->
							<br> <br> <br> <br> <input type="hidden" name="pid" value="${dto.productId }" />  
							
							<!-- 총 상품 금액 -->
							<div class="row" style="display: inline-block; width:100%; vertical-align: middle; float:right; padding-right: 15px;">
									<font  type="text" id="tot-product" readonly="readonly" 
									style="text-align: right; font-size: 30pt; vertical-align: middle; border: none;
									background-color: white; color: #38b143; font-weight: bold; padding-right: 0; float: right;">  
									<font style="text-align: right; font-size: 15pt; color: gray; font-weight: lighter;">
									총 금액</font>&nbsp;&nbsp;${dto.productPrice }원</font>
							</div> 
							<div style="height: 105px;"></div>

														 
							<!-- 버튼 --> 
							<div class="col-12" style="text-align: right; vertical-align: middle; padding: 0;"> 
								<input type="button" class="btn fitness-btn btn-white mt-10" 
									style="min-width: 150px;" value=" 장바구니 " onclick="sendIt();" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;      
								<input type="button" class="btn fitness-btn btn-white mt-10"
									style="min-width: 150px;" value=" 구매하기" onclick="buyNow();" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;    
								<input type="button" class="btn fitness-btn btn-2 mt-30" value="목록으로" 
									style="min-width: 150px; margin-top: 0!important;" 
									onclick="javascript:location.href='<%=cp%>/productList.action?searchValueCategory=${searchValueCategory }&searchValueWord=${searchValueWord }&pageNum=${pageNum }';" />
							</div>   
							<br><hr style="margin: 0;">
						</form>  
					</div>
				</div> 
			</div>
		<br><br>
		<div class="col-12 mt-50">
			<div class="single-blog-post mb-100 gymDetailHeadLine"> 
				<!-- ajax를 이용한 리뷰 리스트 및 리뷰 작성 : reviewList.jsp 참조 --> 
				<span id="listData" style="display: none"></span>

			</div>
		</div>
		
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
	<!-- Bootstrap DatePicker -->
	<script
		src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.3.0/js/bootstrap-datepicker.js"></script>
	<!-- Moment js -->
	<script type="text/javascript"
		src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.22.2/moment.min.js"></script>
	<!-- 상품디테일 -->
	<script src="/gyp/resources/js/productDetail.js"></script>

</body>
</html>