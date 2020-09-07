<%@page import="com.exe.dto.CustomInfo"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	request.setCharacterEncoding("UTF-8");
	String cp = request.getContextPath();

%>
<!DOCTYPE html>
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
	<link rel="stylesheet" href="/gyp/resources/css/cart.css" type="text/css">

<title>GYP</title>

<script type="text/javascript">

//전체선택
function fn_AllCheck(parantsObj){
	var obj = document.getElementsByName("cartChk");
	var obj2 = document.getElementsByName("cartNum");
	if(parantsObj.checked){
       for(var i=0; i< obj.length; i++){
	       if(obj[i].checked == false){
	    	   obj[i].checked = true;
	    	   window.price("cartChk"+obj2[i].value,"won"+obj2[i].value);
	       }
       }
	}else{
       for(var i=0; i< obj.length; i++){
    	   if(obj[i].checked == true){
	    	   obj[i].checked = false;
	    	   window.price("cartChk"+obj2[i].value,"won"+obj2[i].value);
	       }
       }
	}
}

	//선택삭제
function SelectDelete(checkboxName){
	var obj = document.getElementsByName(checkboxName);
	var j = 0;
	for(var i=0; i< obj.length; i++){
	       if(obj[i].checked == false){
		   j++;	    	   
	       }
	}
	if(j==obj.length){
		alert("상품을 선택해주세요.");
		return;
	}
	var f = document.myForm;
	f.action = "<%=cp%>/cart_delete.action";
	f.submit();
	
	}
	
	//선택주문
function SelectOrder(checkboxName) {
	var obj = document.getElementsByName(checkboxName);
	var j = 0;
	for(var i=0; i< obj.length; i++){
	       if(obj[i].checked == false){
		   j++;	    	   
	       }
	}
	if(j==obj.length){
		alert("상품을 선택해주세요.");
		return;
	}
	var f = document.myForm;
	f.action = "<%=cp%>/payment.action";
	f.submit();
	}

	//하나주문
	function OneOrder(checkboxName,cartChk,oneVal) {
		var obj = document.getElementsByName(checkboxName);//갯수
		var obj2 = document.getElementById(cartChk);//체크박스
		for(var i=0; i< obj.length; i++){
			if(obj[i].value==null||obj[i].value==""){
		    	   alert("\n갯수를 입력하세요.");
		    	   obj[i].focus();
		    	   return;
		     }
			obj2.checked = true;	    	   
			$("#totPrice").val($("#"+oneVal).val());
		}
		var f = document.myForm;
		f.action = "<%=cp%>/payment.action";
		f.submit();
	}
	//가격
	function price(checkboxName,won) {
		var checkBox = document.getElementById(checkboxName);
		var won = document.getElementById(won);
		var totPrice = document.getElementById("totPrice");

		var v3;
		if (checkBox.checked == true) {
			var v1 = Number(totPrice.value);
			var v2 = Number(won.value);
			v3 = v1 + v2;
			totPrice.value = v3;
		}
		if (checkBox.checked == false) {
			var v1 = Number(totPrice.value)
			var v2 = Number(won.value);
    		v3 = v1 - v2;
			totPrice.value = v3;
		}
	}
	
	//수량변경
	function countUpdate(countBox,cartNum) {
		var obj = document.getElementsByName(countBox);
		
		for(var i=0; i< obj.length; i++){
		       if(obj[i].value==null||obj[i].value==""){
		    	   alert("\n갯수를 입력하세요.");
		    	   obj[i].focus();
		    	   return;
		       }
		}
		var f = document.myForm;
		f.action = "<%=cp%>/cart_count_update.action?cartNum="+cartNum;
		f.submit();

	}
	
	//이 이벤트들은 갯수칸에 영어나한글을 넣지못하게 하는 기능
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

</script>

</head>
<body style="font-family: 'Noto Sans KR', sans-serif;">
	
	<jsp:include page="/WEB-INF/views/layout/header_over.jsp" />
	<jsp:include page="/WEB-INF/views/layout/header_below.jsp" />
	
	
	<div class="blog-area mt-20 section-padding-100">
        <div class="container colspan-12">
        	<!-- 제목 -->
           <div class="mb-50 colspan-12">
              <h5 style="color: #38B143;">CART</h5> 
               <h2>장바구니</h2>
               <hr/>
           </div>
        
	        <!-- 장바구니 기능 -->
	        <div>
	        	<form method="post" name="myForm" style="width: 1100px;">
					
				<c:if test="${!empty cartLists}">
	        	<table style="font-size: 10pt; color: #888; width: 100%; border-radius: 10px;" border="0"
					cellspacing="3" cellpadding="3">
						<tr style="font-size: 12pt; height: 80px;">
							<td colspan="3">
								&nbsp;&nbsp;&nbsp;<input type="checkbox" id="chkAll"
								class="selectAllCarts" onclick="fn_AllCheck(this);">
								<label for="chkAll" style="font:large;">&nbsp;&nbsp;&nbsp;전체선택</label> 
							</td>
							<td colspan="3">
								<input type="hidden" name="totPrice" value="${totPrice }">
							</td>
							<td colspan="2" style="text-align: right; vertical-align: middle;" >
								<input align="right" type="button" value="선택삭제"
								onclick="SelectDelete('cartChk');" class="btn fitness-btn btn-white"
								style="border-radius: 8px; min-width: 195px; height: 45px; margin: 10px 0; ">
							</td>
						</tr> 
					
					<tr style="text-align: center; height: 40px; background-color: #38b143; color: white; font-size: 16px;">
						<th colspan="2" width="150" align="center">선택</th>
						<th width="350">상품사진</th>
						<th colspan="2">갯수</th>
						<th width="250">상품명</th>
						<th width="150">상품가격</th>
						<th width="300"></th>
					</tr>
					</c:if>

					<!-- 장바구니 비었을때 -->
	        	<c:if test="${empty cartLists}">
	        		<table style="font-size: 10pt; color: #888; width: 100%; border-radius: 10px;" border="0"
					cellspacing="3" cellpadding="3">
						<tr height="40px;">
						<td colspan="7" align="center" style="font-size: 15pt; color:#999;">
						&nbsp;담은 물건이 없습니다!</td></tr>
					</table>
				</c:if>
				
				<!-- 장바구니 안비었을때 -->
				<c:if test="${!empty cartLists}">
					<c:forEach var="cart" items="${cartLists }">
						<tr height="130px" style="font-size: 12pt; vertical-align: middle;">	
							<!-- 체크박스 -->
							<td width="30px" >
								<input type="hidden" name="cartNum" value="${cart.cartNum}" />
								&nbsp;&nbsp;
								<input type="checkbox" id="cartChk${cart.cartNum}" name="cartChk" value="${cart.cartNum}"
									onchange="price('cartChk${cart.cartNum}','won${cart.cartNum}')" /> <!-- pid -->
							</td>
							<!-- 체크박스 라벨 - 상품 ID -->
							<td align="left" width="70px">
								&nbsp;&nbsp;&nbsp;<label for="cartChk${cart.cartNum}" style="margin-bottom: 0">${cart.productId}</label>
							</td>
							<!-- 상품 이미지 -->
							<td width="250px" align="center">
								<img alt="그림" src="${imagePath }/${cart.productImg}" style="height: 120px; width: 120px; margin: 10px;">
							</td>
							<!-- 갯수 -->
							<td align="center" width="100px">
								<%-- <input type="text" name="count${cart.cartNum}" value="${cart.count}" 
								style="font-size:16pt; color: #666; vertical-align: middle;
										width: 50px; height: 45px; padding-top: 2px; text-align: center;
										color:#F23D4C; font-size: 20pt; font-family: 'Do Hyeon', sans-serif;
										vertical-align: middle;" onkeydown ='return onlyNumber(event)' 
										onkeyup ='removeChar(event)'/> --%>
								<input class="form-control" type="number" name="count${cart.cartNum}" value="${cart.count}" min="1" max="100"
									style="text-align: center; font-size: 13pt; vertical-align: middle; width: 75px; border: 3px solid #38b143; 
									border-radius: 10px; padding-left: 25px;">
							</td>
							<!-- 변경버튼 -->
							<td width="100px">
								<input type="button" value="변경" onclick="countUpdate('count${cart.cartNum}','${cart.cartNum}');"
								class="btn fitness-btn btn-2" style="min-width: 60px;  height:42px; padding: 0; width: 70px;"/>
							</td>
							<!-- 상품명 + 상품상세페이지로 이동 링크 -->
							<td style="text-align: center;" width="280px">
								<a href="javascript:location.href='<%=cp%>/productDetail.action?productId=${cart.productId}&pageNum=1'">
								<h6>${cart.productName }</h6></a> 
							</td>
							<!-- 가격 -->
							<td style="text-align: center;" width="80px">${cart.productPrice}원
								<input type="hidden" id="won${cart.cartNum}" value="${cart.productPrice * cart.count}"/>
							</td>	
							<!-- 구매/삭제버튼 -->
							<td>
								<input type="button" value="구매하기"
								class="btn fitness-btn btn-2"
								style="min-width: 80px; float: right; margin: 10px 5px 10px 5px; padding: 5px; border-radius: 10px; vertical-align: middle; line-height: 0;"
								onclick="OneOrder('count${cart.cartNum}','cartChk${cart.cartNum}','won${cart.cartNum }');">
							
								<input type="button" value="삭제하기"
								class="btn fitness-btn btn-white"
								style="min-width: 80px; float: right; margin: 10px 25px 10px 0px; padding: 5px; border-radius: 10px; vertical-align: middle; line-height: 0;"
								onclick="location.href='<%=cp%>/cart_Onedelete.action?cartNum=${cart.cartNum}'">
							</td>
							
						</tr>
						
						<!-- 선 -->
						<tr height="1">
							<td colspan="8" bgcolor="#cccccc"></td>
						</tr>
					</c:forEach>
					
					<tr valign="bottom" height="100">
						<td colspan="7" align="right" style="padding-bottom: 0px;">
							<font color="black" size="5pt">선택한 상품금액 : 
								<input type="text" readonly="readonly" value="0" id="totPrice" name="totPrice2"
								style="border: 0; background-color: #d7efda; padding-top: 2px; padding-right: 15px; padding-bottom:5px;  width: 150px; height: 45px; border-radius: 10px;
								font-size: 15pt; font-family: 'Do Hyeon'; text-align: right;">&nbsp;&nbsp;원&nbsp;&nbsp;&nbsp;&nbsp;
							</font>
						</td>
						<td align="right">
							<input type="button" style="min-width: 195px;"
							value="선택주문" onclick="SelectOrder('cartChk');"
							class="btn fitness-btn btn-2">
						</td>
					</tr>						
				</c:if>
				</table>
				</form>
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