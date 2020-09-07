<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	request.setCharacterEncoding("UTF-8");
	String cp = request.getContextPath();
%>
 <!-- ##### Preloader ##### -->
    <div id="preloader">
        <i class="circle-preloader"></i>
    </div>

    <!-- ##### Header Area Start ##### -->
    <header class="header-area" style="font-family: 'Noto Sans KR', sans-serif;">
        <!-- Navbar Area -->
        <div class="fitness-main-menu">
            <div class="classy-nav-container breakpoint-off">
                <div class="container">
                    <!-- Menu -->
                    <nav class="classy-navbar justify-content-between" id="fitnessNav">

                        <!-- logo -->
                        <a href="/gyp" class="nav-brand"><img src="/gyp/resources/img/core-img/logo.png" alt="" style="width: 130px;"></a>

                        <!-- Navbar Toggler -->
                        <div class="classy-navbar-toggler">
                            <span class="navbarToggler"><span></span><span></span><span></span></span>
                        </div>

                        <!-- Menu -->
                        <div class="classy-menu">

                            <!-- close btn -->
                            <div class="classycloseIcon">
                                <div class="cross-wrap"><span class="top"></span><span class="bottom"></span></div>
                            </div>
							
							
							
                            <!-- Nav Start -->
                            <div class="classynav">
                                <ul>
                                	<!-- 로그인안한상태 -->
                                	<c:if test="${empty sessionScope.customInfo.sessionId }">
	                                    <li><a href="/gyp/map.action">제휴시설 찾기</a></li>
	                                    <li><a href="/gyp/howToUse.action">이용방법</a></li>
	                                    <li><a href="/gyp/noticeList.action">공지사항</a></li>
	                                    <li><a href="/gyp/qnaList.action">Q&A</a></li>
	                                    <li><a href="/gyp/login.action">로그인</a></li>
	                                    <li><a href="/gyp/create.action">회원가입</a></li>
	                                    <li><a href="/gyp/productList.action">스포츠용품</a>
	                                    	<ul class="dropdown" style="width: 100px;">
	                                            <li><a href="/gyp/productList.action?searchValueCategory=H">헬스</a></li>
	                                            <li><a href="/gyp/productList.action?searchValueCategory=Y">요가</a></li>
	                                            <li><a href="/gyp/productList.action?searchValueCategory=P">필라테스</a></li>
	                                        </ul>
	                                    </li>
	                                    
	                                    <a href="/gyp/passCharge.action" class="fitness-btn menu-btn ml-30" style="min-width: 100px;">
		                                	이용권 구입</a>
                                    </c:if>
                                    
                                   	<!-- 일반회원 로그인 -->
                                    <c:if test="${sessionScope.customInfo.loginType =='customer' && sessionScope.customInfo.sessionId !='admin' }">
	                                    <li><a href="/gyp/map.action">제휴시설 찾기</a></li>
	                                    <li><a href="/gyp/howToUse.action">이용방법</a></li>
	                                    <li><a href="/gyp/noticeList.action">공지사항</a></li>
	                                    <li><a href="/gyp/qnaList.action">Q&A</a></li>
	                                    <li><a href="/gyp/logout.action">로그아웃</a></li>
	                                    <li><a href="/gyp/customerMyPage.action">마이페이지</a>
	                                        <ul class="dropdown" style="width: 100px;">
	                                            <li><a href="/gyp/customerMyPage.action#1">내 이용권</a></li>
	                                            <li><a href="/gyp/customerMyPage.action#2">예약 내역</a></li>
	                                            <li><a href="/gyp/customerMyPage.action#3">리뷰 목록</a></li>
	                                            <li><a href="/gyp/customerMyPage.action#4">찜 목록</a></li>
	                                            <li><a href="/gyp/customerMyPage.action#5">주문 내역</a></li>
	                                            <li><a href="/gyp/cart.action">장바구니</a>
	                                            
	                                        </ul>
	                                    </li>
	                                    <li><a href="/gyp/productList.action">스포츠용품</a>
	                                    	<ul class="dropdown" style="width: 100px;">
	                                            <li><a href="/gyp/productList.action?searchValueCategory=H">헬스</a></li>
	                                            <li><a href="/gyp/productList.action?searchValueCategory=Y">요가</a></li>
	                                            <li><a href="/gyp/productList.action?searchValueCategory=P">필라테스</a></li>
	                                        </ul>
	                                    </li>
	                                    
	                                    <a href="/gyp/passCharge.action" class="fitness-btn menu-btn ml-30" style="min-width: 100px;">
	                                	이용권 구입</a>
	                                	<a href="/gyp/faceLink.action" class="fitness-btn menu-btn ml-30" style="min-width: 100px; 
	                                			margin-left: 20px!important; background: linear-gradient(to right, #38b143, #00B38F); ">
	                                	수업하기</a>
                                    </c:if>
                                    
                                    
                                    <!-- 관리자 로그인 -->
                                    <c:if test="${sessionScope.customInfo.sessionId =='admin' }">
                                    	<li><a href="/gyp/howToUse.action">이용방법</a></li>
                                    	<li><a href="/gyp/noticeList.action">공지사항</a></li>
                                    	<li><a href="/gyp/qnaList.action">Q&A</a></li>
                                    	<li><a href="/gyp/logout.action">로그아웃</a></li>
                                    	<li><a href="/gyp/adminHome.action">관리자페이지</a>
                                    </c:if>
                                    
                                    
                                    
                                    
                                    <!-- 체육관 로그인 -->
                                    <c:if test="${sessionScope.customInfo.loginType =='gym' }">
	                                   	<li><a href="/gyp/map.action">제휴시설 찾기</a></li>
	                                    <li><a href="/gyp/howToUse.action">이용방법</a></li>
	                                    <li><a href="/gyp/noticeList.action">공지사항</a></li>
	                                    <li><a href="/gyp/qnaList.action">Q&A</a></li>
	                                    <li><a href="/gyp/logout.action">로그아웃</a></li>
                                    	<li><a href="/gyp/gymMyPage.action">마이페이지</a>
                                   	 		<ul class="dropdown" style="width: 100px;">
	                                           <li><a href="/gyp/gymMyPage.action#">회원정보</a></li>
	                                           <li><a href="/gyp/gymMyPage.action#1">누적 매출</a></li>
	                                           <li><a href="/gyp/gymMyPage.action#2">예약 현황</a></li>
	                                           <li><a href="/gyp/gymMyPage.action#3">리뷰 목록</a></li>
	                                       	</ul>
                                    	</li>
                                	</c:if>
                                </ul>



                            </div>
                            <!-- Nav End -->
                        </div>
                    </nav>
                </div>
            </div>
        </div>
    </header>
    <!-- ##### Header Area End ##### -->
	
	

    
    