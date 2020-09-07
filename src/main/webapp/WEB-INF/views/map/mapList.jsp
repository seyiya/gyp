<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	request.setCharacterEncoding("UTF-8");
	String cp = request.getContextPath();
%>

<c:if test="${dataCount!=0 }">
	<div id="mapList" style="width: 490px;">
	<c:forEach var="dto" items="${lists}">
		<hr style="width: 470px;">
		<div class="mapDetail">
		<dl>
			<dd class="mapListTitle">
				<a href="javascript:void(0);"onclick='mapSetCenter("${dto.gymAddr }");' class="hover_green">
				${dto.gymName }</a>
			</dd>
			<dd>
				<div class="mapListText">
					<div style="display: inline-block;">
						<div class="Icon_middle"><i class="fas fa-phone-square-alt" style="color: #999;"></i></div>
						<div class="mapListText_detail"style="color:#666;">&nbsp;&nbsp;${dto.gymTel }</div>
						<div></div>
						<div class="Icon_middle"><i class="fas fa-clock" style="color: #999;"></i></div>
						<div class="mapListText_detail" style="color:#666;">&nbsp;&nbsp;${dto.gymHour }</div>
						<div></div>
						<div class="Icon_middle"><i class="fas fa-map-marker-alt" style="color: #999;"></i></div>
						<div class="mapListText_detail" style="color:#666;">&nbsp;&nbsp;${dto.gymAddr }</div>
					</div>
				</div>
			</dd>
			<dd>
				<c:if test="${loginType == '' || loginType == 'customer' }">
					
					<a href='javascript:void(0);' onclick="jjim('${dto.gymId}');">
					<img alt="찜하기" src="/gyp/resources/img/core-img/mapLikeIcon.JPG" style="width: 30px">&nbsp;
					<font style="color:#F29DAA; vertical-align:-2px;">찜하기</font></a>
					&nbsp;&nbsp;&nbsp;&nbsp;
				</c:if>
					<a href="<%=cp%>/gymDetail.action?gymId=${dto.gymId}">
					<img alt="예약하기" src="/gyp/resources/img/core-img/mpaCashIcon.JPG" style="width: 30px">&nbsp;
					<font style="color:#74BE5F; vertical-align:-2px;">체육관 상세페이지</font></a>
			</dd>
		</dl>
		</div>
	</c:forEach>
	</div>
	
	<!-- 페이징 -->
	<div style="height: 30px;"></div>
	<div style="width:300px; margin: 0 auto; text-align: center;">
		${ajaxPageIndexList}
	</div>
</c:if>

<c:if test="${dataCount==0 }">
	${searchValue} 검색 결과가 없어요.
</c:if>


