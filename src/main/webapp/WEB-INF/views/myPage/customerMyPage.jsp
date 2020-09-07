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
<!-- jQuery-2.2.4 js -->
<script src="/gyp/resources/js/jquery/jquery-2.2.4.min.js"></script>

<!-- 마이페이지 -->
<link rel="stylesheet" href="/gyp/resources/css/myPage.css">
   
   <script type="text/javascript">
   
      function toUpdate(){
         
            f = document.myForm;
         
            var str = f.cusPwd.value;
            var ck = f.cusPwdck.value;
            
            str = str.trim();
            
            if(!str){
                alert("\n비밀번호를 입력하세요!");
                f.cusPwd.focus();
                return;
             }
            
            if(str!=ck){
               alert("\n비밀번호가 일치하지 않습니다.");
               f.cusPwd.focus();
               return;
            }
             
             f.cusPwd.value = str;
             
             f.action = "<%=cp%>/customerUpdate.action";
             f.submit();
      }
       
      $(function(){
    	  
    	  $(".td_proPayNum").each(function() {
    		  var proPayNum_rows = $(".td_proPayNum:contains('" + $(this).text() + "')");
    		  var len = proPayNum_rows.length-1;
    		  var productImg_rows = proPayNum_rows.siblings(".td_productImg");
    		  var productInfo_rows = proPayNum_rows.siblings(".td_productInfo");
    		  var priceTotal_rows = proPayNum_rows.siblings(".td_priceTotal");
    		  var review_rows = proPayNum_rows.siblings(".td_review");
    		  var deliverInfo_rows = proPayNum_rows.siblings(".td_deliverInfo");
    		  
    		  if (proPayNum_rows.length > 1) {
    			  proPayNum_rows.eq(0).attr("rowspan", proPayNum_rows.length);
    			  priceTotal_rows.eq(0).attr("rowspan", proPayNum_rows.length);
    			  deliverInfo_rows.eq(0).attr("rowspan", proPayNum_rows.length);
    			  
    			  proPayNum_rows.not(":eq(0)").remove();
    			  priceTotal_rows.not(":eq(0)").remove();
    			  deliverInfo_rows.not(":eq(0)").remove();
    			  
    			  /* var style = "border-bottom:1px solid #C8C8C8; padding-bottom: 10px;";
        		  productImg_rows.eq(len).attr("style",style);
    			  productInfo_rows.eq(len).attr("style",style);
    			  review_rows.eq(len).attr("style",style);
    			  proPayNum_rows.eq(0).attr("style",style);
    			  priceTotal_rows.eq(0).attr("style",style);
    			  deliverInfo_rows.eq(0).attr("style",style); */
    		  }
    		  
    		  
    		});
    	  
      }); 
      
   </script>
</head>
<body style="font-family: 'Noto Sans KR', sans-serif;">
	 
	<jsp:include page="/WEB-INF/views/layout/header_over.jsp" />
	<jsp:include page="/WEB-INF/views/layout/header_below.jsp" />

<div id="myPage_wrapper" style="font-family: 'Noto Sans KR', sans-serif; width: 1120px;">
   <div id="content" >   
   	  <h5 style="color: green;">CUSTOMER MY PAGE</h5> 
      <h2>마이 페이지</h2>
	  <div style="height: 20px;"></div>
		
      
      <!-- 회원정보 --> 
      <div class="container mb-50" id="1" style="padding: 0;"> 
         <div style="font-size: 14pt; font-weight: bold;">회원정보</div>
         <table class="table_bokyung"
         	 width="1120px" border="0" cellpadding="10" cellspacing="10" style="padding: 2em; text-align: center" >
            <tr>
               <td width="150px;" height="40px;" class="title">
               아이디</td>  
               <td style="text-align: left;  font-weight: bold;">
               ${cusdto.cusId }</td>
            </tr>
            <tr>
               <td width="150px;" height="40px;" class="title">
               이름</td>
               <td style="text-align: left;  font-weight: bold;">
               ${cusdto.cusName }</td>
            </tr>
            <tr>
               <td width="150px;" height="40px;" class="title">
               연락처</td>
               <td style="text-align: left; font-weight: bold;">
               ${cusdto.cusTel }</td>
            </tr>
            <tr>
               <td width="150px;" height="40px;" class="title">
               주소</td>
               <td style="text-align: left; font-weight: bold;">
               ${cusdto.cusAddr }&nbsp;${cusdto.cusAddrDetail }</td>
            </tr>
         </table> 
         
         
         <!-- 정보수정 -->
         <div class="right_float" style="margin: 0; padding: 0;">
            <form action="" name="myForm" method="post">
               <input type="hidden" name="cusPwdck" value=${cusdto.cusPwd }>
               <font class="title2">비밀번호 입력 :&nbsp;&nbsp; </font>
               <input type="password" name="cusPwd" class="bokyung_mypage_text" 
               style="background-color: #ecf1f4; border: none; border-radius:5px; padding: 3px; height: 35px; vertical-align: middle;"/>&nbsp;&nbsp;
               <input type="button" value="회원정보 수정" onclick="javascript:toUpdate()" 
               class="btn fitness-btn btn-white mt-10" style="min-width: 50px; min-height: 40px; width:150px; height: 40px; line-height: 25px;"/>
            </form>
         </div>
      </div><br><br>
      
      
      
      <!-- 이용권 -->
      <div class="container mb-30 col-12" id="2" style="padding: 0;">
         <div style="font-size: 14pt; font-weight: bold;">이용권</div>
         <div style="height: 10px;"></div>
         <div class="form-group mt-10" style="height: 40px;">
	         	<div class="form-control col-6" style="background-color: #DAE6C3; border: none; display:inline-block;
	         		border-radius:5px; padding: 3px; height: 40px; max-width:85.3%; margin-top: 2px;">
	         		<div style="margin-top: 4px;"><font class="title2">
	         		&nbsp;&nbsp;&nbsp; ${cusdto.cusPass } PASS가 남아있습니다  ( ${cusdto.cusPass*5000 }원 )
	         		</font></div>
	       		</div>
	       		<input type="button" value="충전하기" onclick="location.href='/gyp/passCharge.action'"
    	           	class="btn fitness-btn btn-white mt-10" style="min-width: 50px; min-height: 40px;width:150px; height: 40px; 
    	           	line-height: 25px; display:inline-block; float: right; vertical-align: middle;" />
         </div>
      </div><br><br>
      
      
		
		<!-- 예약 -->
		<div class="container mb-30 col-12" id="2" style="padding: 0; margin: 0!important;">
	        <div style="font-size: 14pt; font-weight: bold;">예약 내역</div>
		</div>
		<div style="height: 10px;"></div>
        <table class="table_bokyung" style="padding: 2em; text-align: center; margin: 0;"
        	width="1120px" border="0" cellpadding="10" cellspacing="10"  >
		     <tr style="text-align: center; height: 40px;">
		        <th width="70">번호</th>
		        <th>예약타입</th>
		        <th width="180">체육관</th>
		        <th width="180">트레이너</th>
		        <th width="170">등록일</th>
		        <th width="170">수업일정</th>
		        <th colspan="2" align="left">&nbsp;수업하기</th>
		     </tr>
		     
		     <c:forEach var="bookdto" items="${ booklists }">
		        <tr style="text-align: center; height: 40px; background-color: white;">
		           <td>${bookdto.bookNum }</td>
		           <td>${bookdto.bookType }</td>
		           <td><a href="/gyp/gymDetail.action?gymId=${bookdto.gymId }" style="font-weight: lighter;">${bookdto.gymName }</a></td>
		           <td>${bookdto.gymTrainerPick }</td>
		           <td>${bookdto.bookCreated }</td>
		           <td>${bookdto.bookHour }</td>
		           <td style="text-align: center;">
			          <c:if test="${not empty bookdto.faceLink}">
	                  <a href="/gyp/faceLink.action" class="bokyung_mypage_link">수업링크</a>
	                  </c:if>
	                  <c:if test="${empty bookdto.faceLink }">
	                  	<c:if test="${bookdto.bookType eq 'online' }">
	                  		링크 생성 예정
	                  	</c:if>
	                  	<c:if test="${bookdto.bookType eq 'offline' }">
	                  		오프라인 수업
	                  	</c:if>
	                  </c:if>
	                 
	               </td>
		        </tr>
		     </c:forEach>
          	 <c:if test="${empty booklists }">
	             <tr style="text-align: center; height: 40px; background-color: white;">
			     	<td colspan="7" style="color:#888; font-size: 12pt;" height="80px">
			     	예약 내역이 없습니다</td>
			     </tr>
            </c:if>
        </table></div>
      	<div style="height: 80px;" id="3"></div>
      
      	
     	 <!-- 리뷰 -->
      	<div class="container mb-30 col-12"style="padding: 0; margin: 0!important;">
        	<div style="font-size: 14pt; font-weight: bold;">리뷰 목록</div>
		</div>
		<div style="height: 10px;"></div>
	    <table class="table_bokyung" style="padding: 2em; text-align: center; margin: 0;"
	        	width="1120px" border="0" cellpadding="10" cellspacing="10"  >
		    <tr style="text-align: center; height: 40px;">
		        <th width="70">번호</th>
		        <th width="70">리뷰타입</th>
		        <th width="150">이름</th>
		        <th width="150">등록일</th>
		        <th width="170">평점</th>
		        <th width="170">내용</th>
		        <th width="170">게시글 관리</th>
		    </tr>
           	<c:if test="${reviewlists!=null}">
	            <c:forEach var="reviewdto" items="${reviewlists }">
	               <tr class="tr_white" style="text-align: center; height: 40px;">
	                  <td>${reviewdto.reNum }</td>
	                  <td>${reviewdto.reType }</td>
    				  <td><a href="/gyp/gymDetail.action?gymId=${reviewdto.gymId }" style="font-weight: lighter;">
    				  	  ${reviewdto.gymName }</a>
    				  	  <a href="/gyp/productDetail.action?productId=${reviewdto.productName }" style="font-weight: lighter;">
    				  	  ${reviewdto.productName }</a></td>
	                  <td>${reviewdto.reCreated }</td>
	                  <td>${reviewdto.star }</td>
	                  <td width="350" style="padding-right: 20px">${reviewdto.reContent }</td>
	                  <td><a href="<%=cp %>/reviewDelete.action?reNum=${reviewdto.reNum}" class="bokyung_mypage_link_D">삭제</a></td>
	               </tr>
	            </c:forEach>
           	</c:if>
           	<c:if test="${empty reviewlists}">
           		<tr style="text-align: center; height: 40px; background-color: white;">
			     	<td colspan="8" style="color:#888; font-size: 12pt;" height="80px">
			     	등록된 리뷰가 없습니다</td>
			     </tr>
           	</c:if>
	            
	    </table>
      	<div style="height: 80px;" id="4"></div>
      
      
      
	    <!-- 찜목록 -->
	    <div class="container mb-30 col-12" style="padding: 0; margin: 0!important;">
	   		<div style="font-size: 14pt; font-weight: bold;">제휴시설 찜 목록</div>
		</div>
		<div style="height: 10px;"></div>
        <table class="table_bokyung" style="padding: 2em; text-align: center; margin: 0;"
       	width="1120px" border="0" cellpadding="10" cellspacing="10"  >
		     <tr style="text-align: center; height: 40px;">
		        <th width="150">체육관</th>
		        <th width="350">주소</th>
		        <th width="350">전화번호</th>
		        <th width="150">찜 삭제</th>
		     </tr>
	           <c:forEach var="jjimdto" items="${ jjimlists }">
	           	<tr class="tr_white" style="text-align: center; height: 40px;">
	                 <td><a class="bokyung_mypage_link"
	                 href="/gyp/gymDetail.action?gymId=${jjimdto.gymId}">${jjimdto.gymName}</a></td>
	                 <td>${jjimdto.gymAddr}</td>
	                 <td>${jjimdto.gymTel}</td>
	                 <td><a href="<%=cp %>/jjimDelete.action?gymId=${jjimdto.gymId}" class="bokyung_mypage_link_D">삭제</a></td>
	              </tr>
	           </c:forEach>
	           <c:if test="${empty jjimlists }">
               <tr style="text-align: center; height: 40px; background-color: white;">
			     	<td colspan="4" style="color:#888; font-size: 12pt;" height="80px">
			     	찜한 제휴시설이 없습니다</td>
		  	   </tr>
	           </c:if>
    	</table>
    	<div style="height: 80px;" id="5"></div>
      
       
      <!-- 상품 주문 내역 -->
      <div class="container mb-30 col-12" style="padding: 0; margin: 0!important;">
       		<div style="font-size: 14pt; font-weight: bold;">상품 주문 내역</div>
	  </div>
	  <div style="height: 10px;"></div>
       <table class="table_bokyung" style="padding: 2em; text-align: center; margin: 0;"
       	width="1120px" border="0" cellpadding="10" cellspacing="10"  >
		   <tr style="text-align: center; height: 40px;">
		        <th width="100">번호(시간)</th>
		        <th width="200">상품 이미지</th>
		        <th width="200">주문 내역</th>
		        <th width="150">가격</th>
		        <th width="300">주문자 정보</th>
		        <th width="180">리뷰쓰기</th>
		   </tr>
           <c:forEach var="orderDto" items="${orderLists }" varStatus="status">
              <c:set var="nextDto" value="${orderLists[status.index+1]}" />
              <c:set var="tempProPayNum" value="${nextDto.proPayNum}" />
                 <tr style="text-align: center; background: white;" >
                    <!-- 번호와 시간 --><td class="td_proPayNum">
                    <font style="font-weight: bold; color:#22741C ">${orderDto.proPayNum}</font>
                    <br><br>&nbsp;(${orderDto.proPayCreated })</td>
                    <!-- 이미지 -->
                    <td class="td_productImg">
                       <img alt="${orderDto.productName }" src="${imagePath }${orderDto.productImg }" 
                       style="width:100px; height:100px; margin: 10px;"></td>
                    <!-- 주문내역 -->
                    <td class="td_productInfo">
                       <a href="/gyp/productDetail?pageNum=1&productId=${orderDto.productId }">
                       [${orderDto.productId }] ${orderDto.productName }</a>&nbsp;&nbsp;X&nbsp;&nbsp;
                       ${orderDto.count }개
                    </td>
                    <!-- 가격 -->
                    <td class="td_priceTotal" style="font-weight: bold;">
                       ${orderDto.priceTotal}원
                    </td>
                    <!-- 주문자 정보 -->
                    <td class="td_deliverInfo">
                       ${orderDto.proPayTel }<br/>${orderDto.proPayAddr }
                    </td>
                    <!-- 리뷰 쓰기 -->
                    <td class="td_review">
                       <a href="/gyp/productDetail.action?pageNum=1&productId=${orderDto.productId }" class="bokyung_mypage_link">
                       리뷰쓰기</a>
                   </td>
                 </tr>
              <c:if test="${orderDto.proPayNum != tempProPayNum}">
                 <tr style="border-bottom: 1px solid #38b143;background-color: #fff;"><td></td><td></td><td></td><td></td><td></td><td></td></tr>
              </c:if>
            </c:forEach>
	       	<c:if test="${empty orderLists }">
	          	<tr style="text-align: center; height: 40px; background-color: white;">
			     	<td colspan="7" style="color:#888; font-size: 12pt;" height="80px">
			     	주문 내역이 없습니다</td>
		  	   </tr>
	       	</c:if>
       	</table>  
        	
         	
         	
		</div>
	</div>






	<div style="height: 70px;">&nbsp;</div>
	<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>

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