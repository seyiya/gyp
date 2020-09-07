<%@page import="com.exe.dto.CustomInfo"%>
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
	<meta http-equiv="refresh" content="60; URL=/gyp/gymMyPage.action">
	<!-- Favicon -->
	<link rel="icon" href="/gyp/resources/img/core-img/favicon.ico">
	<!-- Core Stylesheet -->
	<link rel="stylesheet" href="/gyp/resources/css/style.css">
	<!-- font -->
	<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400&display=swap" rel="stylesheet">
	
	<!-- 마이페이지 -->
	<link rel="stylesheet" href="/gyp/resources/css/myPage.css">

<title>GYP</title>

<script type="text/javascript">
   
      function toUpdate(){
         
            f = document.myForm;
         
            var str = f.gymPwd.value;
            var ck = f.gymPwdck.value;
            
            str = str.trim();
            
            if(!str){
                alert("\n비밀번호를 입력하세요!");
                f.gymPwd.focus();
                return;
             }
            
            if(str!=ck){
               alert("\n비밀번호가 일치하지 않습니다.");
               f.gymPwd.focus();
               return;
            }
             
            f.gymPwd.value = str;
             
            f.action = "<%=cp%>/gymUpdate.action";
			f.submit();
	}

</script>
</head>
<body style="font-family: 'Noto Sans KR', sans-serif;">
	
	<jsp:include page="/WEB-INF/views/layout/header_over.jsp" />
	<jsp:include page="/WEB-INF/views/layout/header_below.jsp" />

	<div id="myPage_wrapper" style="font-family: 'Noto Sans KR', sans-serif; width: 1120px;">
	   <div id="content" >   
	   	  <h5 style="color: green;">GYM MY PAGE</h5> 
	      <h2>체육관 마이 페이지</h2>
		  <div style="height: 20px;"></div>
		  
		  <!-- 체육관 정보 --> 
	      <div class="container mb-50" id="1" style="padding: 0;"> 
	         <div style="font-size: 14pt; font-weight: bold;">체육관 정보</div>
	         <table class="table_bokyung"
	         	 width="1120px" border="0" cellpadding="10" cellspacing="10" style="padding: 2em; text-align: center" >
	            <tr>
	               <td width="150px;" height="40px;" class="title">
	               아이디</td>  
	               <td style="text-align: left;  font-weight: bold;">
	               ${gymdto.gymId }</td>
	            </tr>
	            <tr>
	               <td width="150px;" height="40px;" class="title">
	               타입</td>
	               <td style="text-align: left;  font-weight: bold;">
	               ${gymdto.gymType}</td>
	            </tr>
	            <tr>
	               <td width="150px;" height="40px;" class="title">
	               이름</td>
	               <td style="text-align: left; font-weight: bold;">
	               ${gymdto.gymName }</td>
	            </tr>
	            <tr>
	               <td width="150px;" height="40px;" class="title">
	               이메일</td>
	               <td style="text-align: left; font-weight: bold;">
	               ${gymdto.gymEmail }</td>
	            </tr>
	            <tr>
	               <td width="150px;" height="40px;" class="title">
	               연락처</td>
	               <td style="text-align: left; font-weight: bold;">
	               ${gymdto.gymTel }</td>
	            </tr>
	            <tr>
	               <td width="150px;" height="40px;" class="title">
	               주소</td>
	               <td style="text-align: left; font-weight: bold;">
	               ${gymdto.gymAddr }&nbsp;${gymdto.gymAddrDetail }</td>
	            </tr>
	         </table> 
	         
	         
	         <!-- 정보수정 -->
	         <div class="right_float" style="margin: 0; padding: 0;">
	            <form action="" name="myForm" method="post">
	               <input type="hidden" name="gymPwdck" value=${gymdto.gymPwd }>
	               <font class="title2">비밀번호 입력 :&nbsp;&nbsp; </font>
	               <input type="password" name="gymPwd" class="bokyung_mypage_text" 
	               style="background-color: #ecf1f4; border: none; border-radius:5px; padding: 3px; height: 35px; vertical-align: middle;"/>&nbsp;&nbsp;
	               <input type="button" value="회원정보 수정" onclick="javascript:toUpdate()" 
	               class="btn fitness-btn btn-white mt-10" style="min-width: 50px; min-height: 40px; width:150px; height: 40px; line-height: 25px;"/>
	            </form>
	         </div>
	      </div>
	      <div style="height: 80px;" id="2"></div>
	      
	      
	      <!-- 누적 매출 -->
	      <div class="container mb-30 col-12" style="padding: 0;">
	         <div style="font-size: 14pt; font-weight: bold;">누적 매출</div>
	         <div style="height: 10px;"></div>
	         <div class="form-group mt-10" style="height: 40px;">
		         	<table class="table_bokyung" border="0" cellpadding="10" cellspacing="10">
					<tr align="center">
						<td>
							<div style="display: inline-block;">
								<div style="display: inline-block; margin-bottom: 10px;">
									<a href="gymMyPage.action?year=${preYear}&month=${preMonth}" style="color: #38b143;">
									◀이전</a>
								</div>
								<div style="display: inline-block; vertical-align: -2px;">
									<font color="#22741C" size="5">
									<b>&nbsp;${year }년&nbsp;&nbsp;${month }월&nbsp;</b></font>
								</div>
								<div style="display: inline-block; margin-bottom: 10px; color: gray;">
									<a href="gymMyPage.action?year=${nextYear }&month=${nextMonth }" style="color: #38b143;">
									다음▶</a>
								</div>
								<div style="display: inline-block; font-size: 14px; font-weight:bold; color:#22741C; margin-top: 2px; " >
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								월별 누적 매출&nbsp; <font size="5" style="color: #38b143; margin-top: 10px;">
								${bookdataCount * gymdto.gymPass}</font>&nbsp; PASS
								</div>
							</div>
						</td>
					</tr>
					</table>
	         </div>
	      </div>
	      <div style="height: 80px;" id="3"></div>
	      
	      <!-- 예약 -->
		<div class="container mb-30 col-12" style="padding: 0; margin: 0!important;">
	        <div style="font-size: 14pt; font-weight: bold;">예약 현황</div>
		</div>
		<div style="height: 10px;"></div>
        <table class="table_bokyung" style="padding: 2em; text-align: center; margin: 0;"
        	width="1120px" border="0" cellpadding="10" cellspacing="10"  >
		     <tr style="text-align: center; height: 40px;">
		        <th width="70">번호</th>
		        <th width="70">예약타입</th>
		        <th width="120">회원</th>
		        <th width="120">트레이너</th>
		        <th width="170">등록일</th>
		        <th width="170">수업일정</th>
		        <th width="130">&nbsp;수업하기</th>
		     </tr>
		     
		     <c:forEach var="bookdto" items="${ gymbooklists }">
		        <tr style="text-align: center; height: 40px; background-color: white;">
		           <td>${bookdto.bookNum }</td>
		           <td>${bookdto.bookType }</td>
		           <td>${bookdto.cusId }</td>
		           <td>${bookdto.gymTrainerPick }</td>
		           <td>${bookdto.bookCreated }</td>
		           <td>${bookdto.bookHour }</td>
		           <td style="text-align: center;">
			          <c:if test="${bookdto.bookType eq 'online'}">
		                  <a href="https://gyp.herokuapp.com/#${bookdto.faceLink }" class="bokyung_mypage_link">
		                  수업링크</a>&nbsp;&nbsp;
		                  <a href="<%=cp %>/bookDelete.action?bookNum=${bookdto.bookNum}&gymPass=${gymdto.gymPass}&cusId=${bookdto.cusId}" 
		                  class="bokyung_mypage_link_D">
						  거절</a>
	                  </c:if>
	                  <c:if test="${bookdto.bookType eq 'offline'}">
	                      <font style="font-weight: bold; color:gray;">오프라인</font>&nbsp;&nbsp;
	                      <a href="<%=cp %>/bookDelete.action?bookNum=${bookdto.bookNum}&gymPass=${gymdto.gymPass}&cusId=${bookdto.cusId}" 
		                  class="bokyung_mypage_link_D">
						  거절</a>
	                  </c:if>
	               </td>
		        </tr>
		     </c:forEach>
          	 <c:if test="${empty gymbooklists }">
	             <tr style="text-align: center; height: 40px; background-color: white;">
			     	<td colspan="7" style="color:#888; font-size: 12pt;" height="80px">
			     	예약 내역이 없습니다</td>
			     </tr>
            </c:if>
        </table>
        <div style="height: 80px;" id="4"></div>
	    
	    
	    <!-- 리뷰 -->
      	<div class="container mb-30 col-12" style="padding: 0; margin: 0!important;">
        	<div style="font-size: 14pt; font-weight: bold;">리뷰 목록</div>
		</div>
		<div style="height: 10px;"></div>
	    <table class="table_bokyung" style="padding: 2em; text-align: center; margin: 0;"
	        	width="1120px" border="0" cellpadding="10" cellspacing="10"  >
		    <tr style="text-align: center; height: 40px;">
		        <th width="90">번호</th>
		        <th width="150">회원</th>
		        <th width="150">등록일</th>
		        <th width="170">평점</th>
		        <th width="170">내용</th>
		        <th width="170">게시글 관리</th>
		    </tr>
           	<c:if test="${gymreviewlists!=null}">
	            <c:forEach var="reviewdto" items="${gymreviewlists }">
	               <tr class="tr_white" style="text-align: center; height: 40px;">
	                  <td>${reviewdto.reNum }</td>
    				  <td>${reviewdto.cusId }</td>
	                  <td>${reviewdto.reCreated }</td>
	                  <td>${reviewdto.star }</td>
	                  <td width="350" style="padding-right: 20px">${reviewdto.reContent }</td>
	                  <td><a href="/gyp/gymDetail.action?gymId=${reviewdto.gymId }" class="bokyung_mypage_link">
	                  	  리뷰 보러가기</a>&nbsp;&nbsp;
	                  </td>
	               </tr>
	            </c:forEach>
           	</c:if>
           	<c:if test="${empty gymreviewlists}">
           		<tr style="text-align: center; height: 40px; background-color: white;">
			     	<td colspan="8" style="color:#888; font-size: 12pt;" height="80px">
			     	등록된 리뷰가 없습니다</td>
			     </tr>
           	</c:if>
	    </table>
      	<br><br>
	    
		  
	  </div>
	</div>
	

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