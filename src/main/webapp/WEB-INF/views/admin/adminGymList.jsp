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
	function sendIt(){

		var f = document.searchForm;		
		f.action = "<%=cp%>/adminGymList.action";
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
			<h5 style="color: green;">GYM Management</h5>
			<h2 class="mb-30">체육관 관리</h2>
			
			<div>
			<h6 style="color: gray;">승인 대기 체육관 리스트</h6>
			<table width="1100px;" border="1" bordercolor="white">
				<tr style="background-color: #666; color: white;" align="center">
					<td width="100">체육관 ID</td>
					<td width="60">유형</td>
					<td width="100">이름</td>
					<td width="170">이메일</td>
					<td width="100">전화번호</td>
					<td width="100">주소</td>
					<td width="60">상세 정보</td> <!-- 트레이너, 트레이너 사진, 체육관 사진, 프로그램 -->
					<td width="80">가입일</td>
					<td width="50">금액</td>
					<td width="50">승인</td>
					<td width="50">거절</td>
				</tr>
				
				<c:forEach var="dto" items="${falselists}" varStatus="status">
				<tr align="center" height="45">
					<td>${dto.gymId }</td>
					<td>${dto.gymType }</td>
					<td>${dto.gymName }</td>
					<td>${dto.gymEmail }</td>
					<td>${dto.gymTel }</td>
					<td>${dto.gymAddr }</td>
					<td> 
					<!-- 더보기 모달 버튼 -->
						<div id="seeMore1" class="post-date1" data-toggle="modal" 
						data-target="#seeMore1${status.index }" data-backdrop="true" data-keyboard="false">
							<p style="margin-bottom: 0; color: green; font-weight: bold;">더보기</p>
						</div>
						
						
					<!-- 모달(승인대기용) -->
						<div id="seeMore1${status.index }"  class="modal fade" role="dialog">
							<div class="modal-dialog modal-lg">
								<!-- Modal content-->
								<div class="modal-content">
									<form action="" method="post" name="bookForm">
										<div class="modal-header">
											<h4 class="modal-title" >
												${dto.gymName } 상세 정보
											</h4>
											<button type="button" class="close" data-dismiss="modal">&times;</button>
										</div>
										<div class="modal-body" style="text-align: left;">
											
											<table width="766" border="1" bordercolor="black">
												<tr height="120">
													<td width="80">&nbsp;&nbsp;트레이너 및 사진</td>
													<c:forEach var="i" begin="0" end="3">
														<td width="90" align="center">
														<c:if test="${!empty dto.gymTrainerAry[i]}">
															${dto.gymTrainerAry[i]}<br>
															<a href="${imgPath}/gymTrainerPic/${dto.gymTrainerPicAry[i]}"><img src="${imgPath}/gymTrainerPic/${dto.gymTrainerPicAry[i]}" style="width:100px; height:150px;"/></a><br>
															<a href="${imgPath}/gymTrainerPic/${dto.gymTrainerPicAry[i]}"><span style="font-size: 8px;">${dto.gymTrainerPicAry[i]}</span></a>
														</c:if>
														</td>
													</c:forEach>
												</tr>
												<tr height="120">		
													<td width="80">&nbsp;&nbsp;체육관 사진</td> 
													<c:forEach var="i" begin="0" end="3">
														<td width="90" align="center">
															<c:if test="${!empty dto.gymPicAry[i]}">
															<a href="${imgPath}/gymPic/${dto.gymPicAry[i]}"><img src="${imgPath}/gymPic/${dto.gymPicAry[i]}" style="width:100px; height:100px;"/></a><br>
															<a href="${imgPath}/gymPic/${dto.gymPicAry[i]}"><span style="font-size: 8px;">${dto.gymPicAry[i]}</span></a>
															</c:if>
														</td>
													</c:forEach>
												</tr>
												<tr height="30">	
													<td>&nbsp;&nbsp;프로그램</td> 
													<td colspan="4">&nbsp;&nbsp;${dto.gymProgram }</td>
												</tr>
												<tr height="30">
													<td>&nbsp;&nbsp;체육관 시설</td> 
													<c:forEach var="i" begin="0" end="3">
														<td>
															<c:if test="${!empty dto.gymFacilityAry[i]}">
															&nbsp;&nbsp;${dto.gymFacilityAry[i]}
															</c:if>
														</td>
													</c:forEach>
												</tr>
												<tr height="30">
													<td>&nbsp;&nbsp;운영 시간</td>
													<td colspan="4">&nbsp;&nbsp;${dto.gymHour }</td>
												</tr>
											</table>
												
										</div>
									</form>
								</div>
					
							</div>
						</div>
						
					</td>
					<td>${dto.gymCreated }</td>
					<td>${dto.gymPass }</td>
					<td><input type="button" value=" 승인 " class="btn2" onclick="javascript:location.href='<%=cp%>/adminGymUpdated_ok.action?gymId=${dto.gymId}';"/></td>
					<td><input type="button" value=" 거절 " class="btn2" onclick="javascript:location.href='<%=cp%>/adminGymDeleted.action?gymId=${dto.gymId}';"/></td>
				</tr>
				</c:forEach>
			</table>
		</div>

		<!-- //////////////////////////////////////////////////////////// -->
		
		<hr>
		<br><br><br>
		<h6 style="color: gray;">등록된 체육관 리스트</h6>

		<!-- 검색 -->
		<div id="leftHeader" style="height: 50px; padding-top: 10px;">
			<form action="" name="searchForm" method="post">
				<select name="searchKey" class="selectField">
					<option value="gymName">이름</option>
					<option value="gymType">종목</option>
					<option value="gymAddr">지역</option>				
				</select>
				<input type="text" name="searchValue" class="textField">
				<input type="button" value=" 검색 " class="btn2" onclick="sendIt();">			
			</form>		
		</div>


		<div id="lists">
			<table width="1100px;" border="1" bordercolor="white">
				<tr style="background-color: #666; color: white;" align="center">
					<td width="80">체육관 ID</td>
					<td width="60">유형</td>
					<td width="200">이름</td>
					<td width="170">이메일</td>
					<td width="100">전화번호</td>
					<td width="">주소</td>
					<td width="80">상세 정보</td> <!-- 트레이너, 트레이너 사진, 체육관 사진, 프로그램 -->
					<td width="80">가입일</td>
					<td width="50">금액</td>
				</tr>
				
				<c:forEach var="dto" items="${lists}">
				<tr align="center" height="45">
					<td>${dto.gymId }</td>
					<td>${dto.gymType }</td>
					<td>${dto.gymName }</td>
					<td>${dto.gymEmail }</td>
					<td>${dto.gymTel }</td>
					<td>${dto.gymAddr }</td>
					<td> 
					<!-- 더보기 모달 버튼 -->
						<div id="seeMore1" class="post-date1" data-toggle="modal" 
						data-target="#seeMore2${status.index }" data-backdrop="true" data-keyboard="false">
							<p style="margin-bottom: 0; color: green; font-weight: bold;">더보기</p>
						</div>
						
						
					<!-- 모달(승인대기용) -->
						<div id="seeMore2${status.index }"  class="modal fade" role="dialog">
							<div class="modal-dialog modal-lg">
								<!-- Modal content-->
								<div class="modal-content">
									<form action="" method="post" name="bookForm">
										<div class="modal-header">
											<h4 class="modal-title" >
												${dto.gymName } 상세 정보
											</h4>
											<button type="button" class="close" data-dismiss="modal">&times;</button>
										</div>
										<div class="modal-body" style="text-align: left;">
											
											<table width="766" border="1" bordercolor="black">
												<tr height="120">
													<td width="80">&nbsp;&nbsp;트레이너 및 사진</td>
													<c:forEach var="i" begin="0" end="3">
														<td width="90" align="center">
															<c:if test="${!empty dto.gymTrainerAry[i]}">
																${dto.gymTrainerAry[i]}<br>
																<a href="${imgPath}/gymTrainerPic/${dto.gymTrainerPicAry[i]}"><img src="${imgPath}/gymTrainerPic/${dto.gymTrainerPicAry[i]}" style="width:100px; height:150px;"/></a><br>
																<a href="${imgPath}/gymTrainerPic/${dto.gymTrainerPicAry[i]}"><span style="font-size: 8px;">${dto.gymTrainerPicAry[i]}</span></a>
															</c:if>
														</td>
													</c:forEach>
												</tr>
												<tr height="120">		
													<td width="80">&nbsp;&nbsp;체육관 사진</td> 
													<c:forEach var="i" begin="0" end="3">
														<td width="90" align="center">
															<c:if test="${!empty dto.gymPicAry[i]}">
																<a href="${imgPath}/gymPic/${dto.gymPicAry[i]}"><img src="${imgPath}/gymPic/${dto.gymPicAry[i]}" style="width:100px; height:100px;"/></a><br>
																<a href="${imgPath}/gymPic/${dto.gymPicAry[i]}"><span style="font-size: 8px;">${dto.gymPicAry[i]}</span></a>
															</c:if>
														</td>
													</c:forEach>
												</tr>
												<tr height="30">	
													<td>&nbsp;&nbsp;프로그램</td> 
													<td colspan="4">&nbsp;&nbsp;${dto.gymProgram }</td>
												</tr>
												<tr height="30">
													<td>&nbsp;&nbsp;체육관 시설</td> 
													<c:forEach var="i" begin="0" end="3">
														<td>
															<c:if test="${!empty dto.gymFacilityAry[i]}">
															&nbsp;&nbsp;${dto.gymFacilityAry[i]}
															</c:if>
														</td>
													</c:forEach>
												</tr>
												<tr height="30">
													<td>&nbsp;&nbsp;운영 시간</td>
													<td colspan="4">&nbsp;&nbsp;${dto.gymHour }</td>
												</tr>
											</table>
												
										</div>
									</form>
								</div>
							</div>
						</div>
					
					
					</td>
					<td>${dto.gymCreated }</td>
					<td>${dto.gymPass }</td>
				</tr>
				</c:forEach>
			</table>
		</div>
			
			<div style="width: 1100px; margin: 0 auto; align-content: center; text-align: center;">
				<p>
					<c:if test="${dataCount!=0 }">
						<br>${pageIndexList }
					</c:if>
					<c:if test="${dataCount==0 }">
						<br>등록된 체육관이 없습니다.
					</c:if>
				</p>
			</div>	
		</div>
	</div>

	
	<div style="height:100px;"></div>

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