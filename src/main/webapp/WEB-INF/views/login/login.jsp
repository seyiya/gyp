<%@page import="java.math.BigInteger"%>
<%@page import="java.security.SecureRandom"%>
<%@page import="java.net.URLEncoder"%>
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
	
<title>GYP</title>

<script type="text/javascript">

	function sendIt(){
		
		f = document.myForm;
		
		if(!f.sessionId.value){
			alert("아이디를 입력하세요!");
			f.sessionId.focus();
			return;
		}
		if(!f.sessionpwd.value){
			alert("패스워드를 입력하세요!");
			f.sessionpwd.focus();
			return;
		}
		
		var referrer = document.referrer;
		
		f.action = "/gyp/login_ok.action?history=" + referrer;
		f.submit();
	}
	
	window.history.forward();	
	
	function noBack(){window.history.forward();}
	
</script>


</head>
<body style="font-family: 'Noto Sans KR', sans-serif;" onload="noBack();" onpageshow="if(event.persisted) noBack();" onunload="">
	
	<jsp:include page="/WEB-INF/views/layout/header_over.jsp" />
	<jsp:include page="/WEB-INF/views/layout/header_below.jsp" />
	<div style="height: 100px;"></div>
	
	
	
	<div style="position: relative;  margin-left: auto; margin-right: auto;">
		<div style="width:1110px!important; margin-left: auto; margin-right: auto;
			 justify-content: center; ">
			<div class="our-newsletter-area mb-100" style="width: 400px; margin: 0 auto;">
				<div class="section-heading">
					<h6 align="center">LOGIN GYP</h6>
					<h2 align="center">로그인</h2>
				</div>
	
				<form action="" method="post" name="myForm" style="">
					<div class="form-group">
						<input type="text" class="form-control" name="sessionId" id="loginId"
							placeholder="아이디" style="width: 400px; align-self: center;">
					</div>
					<div class="form-group mb-0">
						<input type="password" class="form-control" name="sessionpwd" id="loginPwd"
							placeholder="패스워드" style="width: 400px;">
					</div>
					<div style="text-align: center;"><br><font color="red"><b>${message }</b></font></div>
					<%-- <div id="naver_id_login" class="btn mt-50" style="padding: 0;"><img alt="네이버 로그인" src="<%=cp %>/resources/img/core-img/네이버 아이디로 로그인_완성형_Green.PNG" style="width: 200px;"/></div> --%>
					
					 <%
					    String clientId = "P84rJHPRvVU6zfXj1ZXD";//애플리케이션 클라이언트 아이디값";
					    String redirectURI = URLEncoder.encode("http://192.168.16.9:8000/gyp/naverLogin_ok.action", "UTF-8");
					    SecureRandom random = new SecureRandom();
					    String state = new BigInteger(130, random).toString();
					    String apiURL = "https://nid.naver.com/oauth2.0/authorize?response_type=code";
					    apiURL += "&client_id=" + clientId;
					    apiURL += "&redirect_uri=" + redirectURI;
					    apiURL += "&state=" + state;
					    session.setAttribute("state", state);
					 %>
					 
				 	<!-- 네이버 로그인 -->
				  	<div id="naver_id_login" class="btn mt-50" style="padding: 0;">
				  		<a href="<%=apiURL%>"><img height="50" src="/gyp/resources/img/core-img/네이버 아이디로 로그인_완성형_Green.PNG" style="width: 200px;"/></a>
				  	</div>
					
					<!-- 로그인 버튼 -->
					<button type="button" class="btn fitness-btn btn-white mt-50" style="min-width: 194px;"
						onclick="sendIt();">로그인</button>
				</form>
				<br>
				<center>
					<table style="width: 400px" >
					<tr style="text-align: center;">
						<td width="33.33%"><a href="<%=cp %>/create.action">
						<font style="color: gray;">회원가입</font></a></td>
						<td width="33.33%"><a href="<%=cp%>/searchid.action">
						<font style="color: gray;">아이디 찾기</font></a></td>
						<td width="33.33%"><a href="<%=cp%>/searchpw.action">
						<font style="color: gray;">비밀번호 찾기</font></a></td>
					</tr>
					</table>
				</center>
			</div>
		</div>
	</div>
	
	
	
	
	<div style="height: 70px;">&nbsp;</div>
	<jsp:include page="/WEB-INF/views/layout/footer.jsp" />

 	<!-- ##### Footer Area Start ##### -->

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
    <!-- 네이버 로그인 api -->
    <script type="text/javascript" src="https://static.nid.naver.com/js/naverLogin_implicit-1.0.3.js" charset="utf-8"></script>
</body>
</html>