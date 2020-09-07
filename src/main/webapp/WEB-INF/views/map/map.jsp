<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %> 
<%
   request.setCharacterEncoding("UTF-8");
String cp = request.getContextPath();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport"
   content="width=device-width, initial-scale=1, shrink-to-fit=no">
<!-- Favicon -->
<link rel="icon" href="/gyp/resources/img/core-img/favicon.ico">
<!-- Core Stylesheet -->
<link rel="stylesheet" href="/gyp/resources/css/style.css">
<!-- Map CSS -->
<link rel="stylesheet" href="/gyp/resources/css/map.css">
<!-- font -->
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400&display=swap" rel="stylesheet">
<!-- jQuery-2.2.4 js -->
<script src="/gyp/resources/js/jquery/jquery-2.2.4.min.js"></script>

<title>GYP</title>
</head>
<body style="font-family: 'Noto Sans KR', sans-serif;">
	<jsp:include page="/WEB-INF/views/layout/header_over.jsp" />
	<jsp:include page="/WEB-INF/views/layout/header_below.jsp" />
	
	<center>
	
	<div style="height: 80px;"></div>
	
	
	   <div class="mapContainerWrap">
	      <form method="post" name="searchForm" id="searchForm">
	      <!-- 검색창&리스트 웹 -->
	      
	      <div class="topBox">
	      <!-- 검색창 -->
		      <div class="searchBar">
		      	  <h5 style="color:#38b143;">SEARCH GYM</h5>
				  <h2>제휴시설 찾기</h2>
				  <div style="height: 10px;"><!-- 여백 --></div>
				  <!-- 검색 -->
			      <select name="searchKey" id="searchKey" class="selectField" onchange="selectChange();">
			         <option value="gymName" <c:if test="${tempSearchKey eq 'gymName'}">selected</c:if>>이름</option>
			         <option value="gymAddr" <c:if test="${tempSearchKey eq 'gymAddr'}">selected</c:if>>지역</option>
			         <option value="gymType" <c:if test="${tempSearchKey eq 'gymType'}">selected</c:if>>종목</option>
			      </select>
			      <input type="text" name="searchValue" id="searchValue" value="${tempSearchValue}" placeholder="&nbsp;검색어"
			        class="textField" onkeyup="sendKeyword();" onkeydown="enter('send');">
			      <input type="button" value=" 검색 " id="sendButton" onclick="searchMap('send');" style="cursor: pointer;"/>
			      <input type="button" value=" MY " id="myButton" onclick="searchMap('my');" style="cursor: pointer;" />
			      <input type="hidden" id="tempSearchKey" value="${tempSearchKey}"/>
			      <input type="hidden" id="tempSearchValue" value="${tempSearchValue}"/>
			      <input type="hidden" id="cusAddrGoo" value="${cusAddrGoo}"/>
			      <input type="hidden" id="sessionId" value="${sessionId}"/>
			      <input type="hidden" id="loginType" value="${loginType}"/>
		      </div>
		      <!-- 검색어 제시 -->
		      <div id="suggestDiv" class="suggest">
		         <div id="suggestListDiv"></div>
		      </div>
	      </div>
	      
	      
	      
	      <div class="leftBox">
		      <!-- 리스트 -->
	          <div style="height: 30px;"></div>
	          <span id="listData" style="display: none"></span>
	      </div>
	      


	      <div class="rightBox">
	         <!-- 지도시작 -->
	         <div id="map" style="width: 610px; height: 630px; z-index: 1; margin-left: 20px;"></div>
	      </div>
	      </form>
	   </div>
	   
	   <div style="height: 150px;"></div>
	   
	</center>


   <!-- ##### Footer Area Start ##### -->
   <%-- <jsp:include page="/WEB-INF/views/layout/footer.jsp" /> --%>
   <!-- ##### All Javascript Script ##### -->

   <!-- Popper js -->
   <script src="/gyp/resources/js/bootstrap/popper.min.js"></script>
   <!-- Bootstrap js -->
   <script src="/gyp/resources/js/bootstrap/bootstrap.min.js"></script>
   <!-- All Plugins js -->
   <script src="/gyp/resources/js/plugins/plugins.js"></script>
   <!-- Active js -->
   <script src="/gyp/resources/js/active.js"></script>

   <script src="/gyp/resources/js/httpRequest.js"></script>
   
    <!-- font awesome -->
	<script src="https://kit.fontawesome.com/4badd96a47.js" crossorigin="anonymous"></script>
	
   
   <script type="text/javascript">
  
  function jjim(id) {
      var sessionId = $("#sessionId").val();
      var loginType = $("#loginType").val();
      if(sessionId==""||loginType=="gym"||sessionId=="admin"){
           alert("일반 회원 로그인이 필요합니다!");
           return;
      }
      var url = "<%=cp%>/mapGymJjim.action";
            $.post(url,{
               gymId : id
               },function(args){
                  alert(args);
            });
   }
  
  
   function enter(mode) {
      if (window.event.keyCode == 13) {
         searchMap(mode);
       }
   }
   
   function selectChange() {
      $("#searchValue").val("");
   }
   
   $(document).ready(function () {
      <c:if test="${mode eq 'print'}">
         listPage("1");
         mapMake();
      </c:if>
      <c:if test="${mode eq 'map'}">
         searchPage();
         mapMake();
      </c:if>
   });

   function listPage(page) {
      var Key = $("#tempSearchKey").val();
      var Value = $("#tempSearchValue").val();
      var url = "<%=cp%>/mapSearchList.action";
         $.post(url,{
            pageNum:page,
            searchKey : Key,
            searchValue : Value},function(args){
            $("#listData").html(args);
         });
      
      $("#listData").show();
   }
   
   function searchMap(mode) {
	      var searchForm = document.searchForm;
	      var sessionId = $("#sessionId").val();
	      var searchValue = $("#searchValue").val();
	      var loginType = $("#loginType").val();
	      if(mode=='send'){
	         searchForm.action = "<%=cp%>/mapReload.action";
	         searchForm.submit();
	         return;
	      }
	      if(sessionId==""||loginType=="gym"||sessionId=="admin"){
	         alert("일반 회원 로그인이 필요합니다!");
	         return;
	      }else{
	         var cusAddrGoo = $("#cusAddrGoo").val(); 
	         $("#searchKey").val("gymAddr");
	         $("#searchValue").val(cusAddrGoo);
	      }
	      searchForm.action = "<%=cp%>/mapReload.action";
	      searchForm.submit();
	   }
   
   function searchPage() {
      var Key = $("#tempSearchKey").val();
      var Value = $("#tempSearchValue").val();
      var url = "<%=cp%>/mapSearchList.action";
         $.post(url,{
            searchKey : Key,
            searchValue : Value},function(args){
            $("#listData").html(args);
         });
      
      $("#listData").show();
   }
   
      function sendKeyword() {

         var searchKey = document.getElementById("searchKey").value;
         var searchValue = document.getElementById("searchValue").value;

         if (searchValue == "") {
            hide();//검색창이 비워져있으면 숨김
            return;
         }

         var params = "searchValue=" + searchValue + "&searchKey="
               + searchKey;
         sendRequest("map_ok.action", params, displaySuggest, "POST");
      }
      function displaySuggest() {
         if (httpRequest.readyState == 4) {
            if (httpRequest.status == 200) {//서버응답 정상처리인 경우
               var resultText = httpRequest.responseText;//resposne로 넘어온 텍스트 할당

               //(예)5|abc,ajax,abc마트
               var resultArray = resultText.split("|"); //(예){5, {abc,ajax,abc} } 로 나눔
               var count = parseInt(resultArray[0]);//5

               var keywordList = null;

               if (count > 0) {
                  keywordList = resultArray[1].split(",");
                  var html = "";

                  for (var i = 0; i < keywordList.length; i++) {
                     html += "<a href=\"javascript:select('"
                           + keywordList[i] + "');\">"
                           + keywordList[i] + "</a><br/>";
                  }
                  var suggestListDiv = document
                        .getElementById("suggestListDiv");
                  suggestListDiv.innerHTML = html;
                  show();
               } else {
                  //count==0
                  hide();
               }
            } else {
               //status!=200
               hide();
            }
         } else {
            //readyState!=4
            hide();
         }
      }//function..end

      //사용자가 제시어중에서 클릭한 키워드
      function select(selectKeyword) {
         //클릭한 제시어를 inputbox에 넣어줌
         document.getElementById("searchValue").value = selectKeyword;
         hide();//다른 제시어 감춤
      }

      function show() {
         var suggestDiv = document.getElementById("suggestDiv");
         suggestDiv.style.display = "block";
      }

      function hide() {
         var suggestDiv = document.getElementById("suggestDiv");
         suggestDiv.style.display = "none";
      }

      //처음 DOM이 로드되었을때 보이지 않도록
      window.onload = function() {
         hide();
      }
      
</script>
<script type="text/javascript"
   src="//dapi.kakao.com/v2/maps/sdk.js?appkey=cf7aec95ee469f062ba92f1f9e4a1b4a&libraries=services,clusterer"></script>
<script type="text/javascript">
var map;
var tempOverlay="";
function mapMake() {
         var container = document.getElementById('map'); //지도를 담을 영역의 DOM 레퍼런스
         var options = {
            center: new kakao.maps.LatLng(37.5532192,126.980466),// 위도경도
            <c:choose>
                <c:when test="${searchKey eq 'gymAddr'}">
                   level: 7 //지도의 레벨(확대, 축소 정도)
                </c:when>
                <c:otherwise>
                   level: 9 //지도의 레벨(확대, 축소 정도)
                </c:otherwise>
            </c:choose>
         };
         map = new kakao.maps.Map(container, options);
         //지도 생성 및 객체 리턴 // 지도타입 컨트롤, 줌 컨트롤 생성
         var mapTypeControl = new kakao.maps.MapTypeControl();
         map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);
         var zoomControl = new kakao.maps.ZoomControl();
         map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);
         
         /* 
         var imageSrc = '/gyp/resources/img/core-img/marker.png', // 마커이미지의 주소입니다    
          imageSize = new kakao.maps.Size(44, 49), // 마커이미지의 크기입니다
          imageOption = {offset: new kakao.maps.Point(27, 69)}; // 마커이미지의 옵션입니다. 마커의 좌표와 일치시킬 이미지 안에서의 좌표를 설정합니다.
          var markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, imageOption);
           */
         // ★ 주소-좌표 변환 객체를 생성
         var geocoder = new kakao.maps.services.Geocoder();
         // ★ 주소로 좌표를 검색 
            <c:forEach items="${lists}" var="dto" varStatus="status">
            	
            geocoder.addressSearch('${dto.gymAddr}', function(result, status) { // 정상적으로 검색이 완료됐으면
               if (status === kakao.maps.services.Status.OK) {
               var coords = new kakao.maps.LatLng(result[0].y, result[0].x);
               yy = result[0].x;
               xx = result[0].y;
               
              //리스트 첫번째에 있는 체육관으로 좌표지정
              <c:if test="${status.first}">
              	<c:if test="${searchKey eq 'gymAddr'}">
                  map.setCenter(coords);
              	</c:if>
              	<c:if test="${status.last}">
                  map.setCenter(coords);
                 map.setLevel(3);
                </c:if>
              </c:if>   
               // 결과값으로 받은 위치를 마커로 표시
               var marker = new kakao.maps.Marker({
                  map: map,
                  position: coords
                  
                  /* 
                  ,image: markerImage // 마커이미지 설정
                   */
               });
               var customContent = '<div class="wrap">' + 
                  '    <div class="info">' + 
                  '        <div class="title" style="border-bottom:none;" >' + 
                  '            ${dto.gymName}' + 
                  '          <div class="close" onclick="closeOverlay()" title="닫기"></div>' +
                  '        </div>' + 
                  '        <div class="body" style="font-family: \'Noto Sans KR\', sans-serif;">' + 
                  '            <div class="desc">' + 
                  					/*이미지(리스트)*/
                  '				  		<c:forEach var="images" items="${dto.gymPicAryList }">' +
                  '               	 	<img src="/gyp/sfiles/gymPic/${images }" width="90" height="70">' +
                  /*'						${images }'+*/
                  '				  	 	</c:forEach>'+
                  '				   <div style="height:5px;"></div>' /*여백*/ +
                  '                <div class="ellipsis" style="font-size:11pt; color:#666; font-weight:bold">'+ 
                  ' 				${dto.gymAddr}</div>'/*주소*/ + 
                  '                <div>'+
                  '             	<a href="<%=cp%>/gymDetail.action?gymId=${dto.gymId}" target="_self" class=\"hover_green_detail\">상세페이지</a><i class="fas fa-info-circle"></i>&nbsp;&nbsp;' +
                  '                <a href="https://map.kakao.com/link/to/${dto.gymName},' + xx +',' + yy + '" target="_blank" class="hover_green_detail">길찾기</a><i class="fas fa-arrow-alt-circle-right"></i>' +
                  '             </div>' +
                  '            </div>' + 
                  '        </div>' + 
                  '    </div>' +    
                  '</div>';
                // 커스텀 오버레이에 표시할 내용입니다     
                // HTML 문자열 또는 Dom Element 입니다 
                var postContent = '<div class ="label"><span class="left"></span><span class="center">${dto.gymName}</span><span class="right"></span></div>';
                
                  // 커스텀 오버레이를 생성합니다
                var postOverlay = new kakao.maps.CustomOverlay({
                    position: coords,
                    content: postContent
                });
                  // 마커 위에 커스텀오버레이를 표시합니다
                  // 마커를 중심으로 커스텀 오버레이를 표시하기위해 CSS를 이용해 위치를 설정했습니다
                  var customOverlay = new kakao.maps.CustomOverlay({
                      content: customContent,
                      position: coords,
                  });
                
                   // 마커를 클릭했을 때 커스텀 오버레이를 표시합니다
                   kakao.maps.event.addListener(marker, 'click', function() {
                      if(tempOverlay!=""){
                         if(tempOverlay==customOverlay){
                            tempOverlay.setMap(null);
                            tempOverlay="";
                            return;
                         }
                         tempOverlay.setMap(null);
                         tempOverlay=customOverlay;
                         postOverlay.setMap(null);
                         customOverlay.setMap(map);
                      }else if(tempOverlay==""){
                         tempOverlay=customOverlay;
                         postOverlay.setMap(null);
                         customOverlay.setMap(map)
                      }
                      
                      
                   });
                
                    // 마커에 마우스오버 이벤트를 등록합니다
                   kakao.maps.event.addListener(marker, 'mouseover', function() {
                      if(tempOverlay==customOverlay){
                         postOverlay.setMap(null); 
                      }else{
                         postOverlay.setMap(map);
                      }
                   });
                   
               // 마커에 마우스아웃 이벤트를 등록합니다
               kakao.maps.event.addListener(marker, 'mouseout', function() {
                  postOverlay.setMap(null);
               });
               
               }
            });
            </c:forEach>
            
            // 지도에 클릭 이벤트를 등록합니다
            // 지도를 클릭하면 마지막 파라미터로 넘어온 함수를 호출합니다
            kakao.maps.event.addListener(map, 'click', function(mouseEvent) {        
                
               if(tempOverlay!=""){
                  
                  }
                
            });
}

function closeOverlay() {
   tempOverlay.setMap(null);
   tempOverlay="";
}

function mapSetCenter(gymAddr) {
   // ★ 주소-좌표 변환 객체를 생성
   var geocoder = new kakao.maps.services.Geocoder();
   geocoder.addressSearch(gymAddr, function(result, status) { // 정상적으로 검색이 완료됐으면
      if (status === kakao.maps.services.Status.OK) {
         var coords = new kakao.maps.LatLng(result[0].y, result[0].x);
         yy = result[0].x;
         xx = result[0].y;
      }
      map.setLevel(3);
      map.setCenter(coords);
   });
}

   </script>
   
    <!-- ##### All Javascript Script ##### -->
    <!-- Popper js -->
    <script src="/gyp/resources/js/bootstrap/popper.min.js"></script>
    <!-- Bootstrap js -->
    <script src="/gyp/resources/js/bootstrap/bootstrap.min.js"></script>
    <!-- All Plugins js -->
    <script src="/gyp/resources/js/plugins/plugins.js"></script>
    <!-- Active js -->
    <script src="/gyp/resources/js/active.js"></script>
	<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
</body>
</html>