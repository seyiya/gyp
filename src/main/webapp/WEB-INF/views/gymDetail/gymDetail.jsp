<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	request.setCharacterEncoding("UTF-8");
	String cp = request.getContextPath();
%>
<!DOCTYPE html">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<!-- BootStrap DatePicker CSS -->
	<link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.3.0/css/datepicker.css" rel="stylesheet" type="text/css" />
	<!-- Favicon -->
	<link rel="icon" href="/gyp/resources/img/core-img/favicon.ico">
	<!-- Core Stylesheet -->
	<link rel="stylesheet" href="/gyp/resources/css/style.css">
	<!-- font -->
	<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400&display=swap" rel="stylesheet">
	
	<!-- 짐 디테일 -->
	<link rel="stylesheet" href="/gyp/resources/css/gymDetail.css">
	<link rel="stylesheet" href="/gyp/resources/css/heart.css">
	
<title>GYP</title>
</head>
<body style="font-family: 'Noto Sans KR', sans-serif;">
	
	<jsp:include page="/WEB-INF/views/layout/header_over.jsp" />
	<jsp:include page="/WEB-INF/views/layout/header_below.jsp" />
	
	<!-- hidden parameters -->
    <input type="hidden" id="gymId" value="${gymDto.gymId }"/>
    <input type="hidden" id="cusId" value="${info.sessionId }"/>
	<input type="hidden" id="gymName" value="${gymDto.gymName }"/>
	<input type="hidden" id="gymAddr" value="${gymDto.gymAddr }"/>
	
    <!-- ##### Content Area Start ##### -->
    <div class="blog-area mt-20 section-padding-100">
        <div class="container">
        
        	<!-- 제목 및 개요 -->
        	<div id="gymDetailSubject">
	            <!-- 체육관 이름 + 타입 -->
	            <div class="row" id="gymDetailTitle">
		            <a href="<%=cp %>/gymDetail.action?gymId=${gymDto.gymId }" class="gymName-title">
		            <span style="height: 60px; vertical-align: bottom;">
		            &nbsp;${gymDto.gymName }</span></a>
		            <span class="gymName-type" style="height: 60px; font-weight:bold; vertical-align: bottom;">
		            &nbsp;&nbsp;&nbsp;&gt;&gt; ${gymDto.gymType }</span>
	            </div>
	            <br/>
	            <!-- 체육관 프로그램 내용 -->
	            <div class="col-12" style="padding: 0;">
		            <div class="single-blog-post">
		              	<div id="gymDetailGymProgram" style="font-size: 12pt; color: #A6A6A6;">
			            	[프로그램 설명]&nbsp;&nbsp;${gymDto.gymProgram }
		                </div>
	                </div>
	            </div>
            </div>
            
            <hr style="width: 100%; margin-left: 0px; text-align: left,border-bottom:0px;">
            
            <!-- 체육관 상세 content -->
            <div class="row">
            	<!-- ------------좌측 컬럼 시작------------- -->
                <div class="col-12 col-md-8" id="gymDetailLeftCol">
                    <div class="fitness-blog-posts">
                        <div class="row">

                            <!-- 체육관 트레이너 -->
                            <div class="col-12" style="height: 450;">
                                <div class="single-blog-post mb-100 gymDetailHeadLine">
                                    <!-- Post Title -->
									<a href="#" class="post-title" style="font-size:20pt;">체육관 트레이너</a>                                    
                                    <div style="height: 10px;"></div>
                                    <!-- 체육관 트레이너 목록 -->
					                <div class="row">
						                <c:forEach var="i" begin="0" end="${gymTrainerPic.size()-1 }">
							                <div class="col-3" style="height:300px; ">
									           <div class="single-teachers-area mb-100">
							                        <!-- Bg Gradients -->
							                        <div class="teachers-bg-gradients"></div>
							                        <!-- Thumbnail -->
							                        <div class="teachers-thumbnail">
							                            <img src="/gyp/sfiles/gymTrainerPic/${gymTrainerPic[i]}" alt="${gymTrainer[i]}">
							                        </div>
							                        <!-- Meta Info -->
							                        <div class="teachers-info">
							                            <h6>${gymTrainer[i]}</h6>
							                            <span>Personal trainer</span>
							                        </div>
						                    	</div>
							                </div>
						                </c:forEach>
					                </div>
                                </div>
                            </div>
							<!-- <hr style="width: 100%; margin-left: 0px; text-align: left,border-bottom:0px;"> -->
							<div style="height: 50px;"></div>
                            <!-- 체육관 리뷰 -->
                            <div class="col-12">
                                <div class="single-blog-post mb-100 gymDetailHeadLine">
                                    <!-- ajax를 이용한 리뷰 리스트 및 리뷰 작성 : reviewList.jsp 참조 -->
                                    <span id="listData" style="display:none"></span>
									
                                </div>
                            </div>
                        
                        <!-- <hr style="width: 100%; margin-left: 0px; text-align: left,border-bottom:0px;"> -->	    
                       
                        <!-- 관련 상품 뿌리기 -->
	                    <div class="col-12" style="vertical-align: bottom; height: 30px;">
	                    	<div class="single-blog-post mb-100 gymDetailHeadLine" style="display: inline-block;">
	                    		<a href="#" class="post-title" style="font-size:20pt; display: inline-block;">
	                    		${gymDto.gymType }&nbsp;관련 인기상품&nbsp;&nbsp;</a>
	                    		<a href="/gyp/productList.action" style="color: #38b143; display: inline-block;">더보기</a>
	                    	</div>
	                    </div>
                    	<!-- 상품리스트로 더보기 (링크 수정 필요) -->
		                <br/><br/><br>
		                    
		                    <c:forEach var="productDto" items="${productLists }">
				                <div class="single-price-table mb-100 col-4"  style="width: 282px; display: inline-block;">
			                        <div class="price-table-content">
			                        	<!-- imgae -->
			                        	<img src="/gyp/sfiles/product/${productDto.productImg}" alt="${productDto.productName }"
			                        		style="width: 282px;">
			                        	<!-- 여백 -->
	             	 					<div style="height: 10px;"></div>
			                            <!-- price -->
			                            <h4 class="price"><span>${productDto.productId }</span></h4>
			                            <!-- Name -->
		                				<h5>${productDTO.productName }</h5>
			                            <!-- Price Data -->
			                            <ul class="price-data">
			                                <li><i class="fa fa-circle" aria-hidden="true"></i> &#8361;${productDto.productPrice }</li>
			                                <li><i class="fa fa-circle" aria-hidden="true"></i>${productDto.productContent }</li>
			                            </ul>
			                            <!-- btn -->
			                            <a href="/gyp/productDetail.action?productId=${productDto.productId }" class="btn fitness-btn mt-30">자세히 보기</a>
			                        </div>
			                    </div>
		                    </c:forEach>
                        </div>
                    </div>
					

                </div>
				<!-- -------------좌측 컬럼 끝-------------- -->
				
				
				<!-- ------------우측 컬럼 시작------------- -->
                <div class="col-12 col-md-4">
                    <div class="fitness-blog-sidebar" style="width: 300px; margin: 0 auto;"> <!-- 우측컬럼 크기 -->
					<c:if test="${empty info || info.loginType ne 'gym'}">
						<div class="row" style="justify-content: center;">
							<!-- 예약 모달 버튼 -->
							<div class="single-blog-post mb-100 gymDetailHeadLine" style="width: 100px; padding-top: 80px; padding-right: 20px;" >
								<!--  Post Thumb -->
								<div class="blog-post-thumb mb-30" style=" cursor: pointer;">
									<div id="gymBook" class="post-date1" data-toggle="modal"
										data-target="#bookModal" data-backdrop="static" data-keyboard="false"
										style="width: 77px; margin: 0 auto;">
										<p>
											<span>${gymDto.gymPass }&nbsp;pass</span>
										</p>
									</div>
									<div style="width: 77px; margin: 0 auto; text-align: center; font-size: 12pt; font-weight: bold; color: #888!important;
									padding-top: 15px;">
									예약하기</div>
								</div>
							</div>
							
							
							<!-- 찜 버튼 -->
							<div class="single-blog-post mb-100 gymDetailHeadLine" style="width: 100px; padding-top: 80px;">
								<div class="blog-post-thumb mb-30" style=" cursor: pointer;">
									<div id="gymJjim" class="post-date2" style="width: 77px; margin: 0 auto;">
										<form action="" method="POST" name="JjimForm">
											<div id="main-content">
												  <div>
												  	<input type="hidden" name="gymId" id="gymIdInJjimForm" value="${gymDto.gymId }">
												 	<c:if test="${not empty whetherJjim}">
												 		<input type="hidden" id="whetherJjim" name="whetherJjim" value="${whetherJjim }"/>
												 	</c:if>
												    <input type="checkbox" id="jjimcheckbox" />
												    <label for="jjimcheckbox">
												      <svg id="heart-svg" viewBox="467 389 58 57" xmlns="http://www.w3.org/2000/svg">
												        <g id="Group" fill="none" fill-rule="evenodd" transform="translate(467 392)">
												          <path d="M29.144 20.773c-.063-.13-4.227-8.67-11.44-2.59C7.63 28.795 28.94 43.256 29.143 43.394c.204-.138 21.513-14.6 11.44-25.213-7.214-6.08-11.377 2.46-11.44 2.59z" id="heart" fill="#AAB8C2"/>
												          <circle id="main-circ" fill="#E2264D" opacity="0" cx="29.5" cy="29.5" r="1.5"/>
												
												          <g id="grp7" opacity="0" transform="translate(7 6)">
												            <circle id="oval1" fill="#9CD8C3" cx="2" cy="6" r="2"/>
												            <circle id="oval2" fill="#8CE8C3" cx="5" cy="2" r="2"/>
												          </g>
												
												          <g id="grp6" opacity="0" transform="translate(0 28)">
												            <circle id="oval1" fill="#CC8EF5" cx="2" cy="7" r="2"/>
												            <circle id="oval2" fill="#91D2FA" cx="3" cy="2" r="2"/>
												          </g>
												
												          <g id="grp3" opacity="0" transform="translate(52 28)">
												            <circle id="oval2" fill="#9CD8C3" cx="2" cy="7" r="2"/>
												            <circle id="oval1" fill="#8CE8C3" cx="4" cy="2" r="2"/>
												          </g>
												
												          <g id="grp2" opacity="0" transform="translate(44 6)">
												            <circle id="oval2" fill="#CC8EF5" cx="5" cy="6" r="2"/>
												            <circle id="oval1" fill="#CC8EF5" cx="2" cy="2" r="2"/>
												          </g>
												
												          <g id="grp5" opacity="0" transform="translate(14 50)">
												            <circle id="oval1" fill="#91D2FA" cx="6" cy="5" r="2"/>
												            <circle id="oval2" fill="#91D2FA" cx="2" cy="2" r="2"/>
												          </g>
												
												          <g id="grp4" opacity="0" transform="translate(35 50)">
												            <circle id="oval1" fill="#F48EA7" cx="6" cy="5" r="2"/>
												            <circle id="oval2" fill="#F48EA7" cx="2" cy="2" r="2"/>
												          </g>
												
												          <g id="grp1" opacity="0" transform="translate(24)">
												            <circle id="oval1" fill="#9FC7FA" cx="2.5" cy="3" r="2"/>
												            <circle id="oval2" fill="#9FC7FA" cx="7.5" cy="2" r="2"/>
												          </g>
												        </g>
												      </svg>
												    </label>
												</div>
											</div>
										</form>
									</div>
									<div style="width: 77px; margin: 0 auto; text-align: center; font-size: 12pt; font-weight: bold; color: #888!important;
									padding-top: 15px;">
									찜하기</div>
								</div>
							</div>
						</div>
					
					
						<!-- 예약 모달 -->
                        <div id="bookModal" class="modal fade" role="dialog">
						  <div class="modal-dialog modal-lg">
						
						    <!-- Modal content-->
						    <div class="modal-content">
							    <form action="" method="post" name="bookForm">
							      <div class="modal-header" style="padding-left: 35px;">
							        <button type="button" class="close" data-dismiss="modal">&times;</button>
							        <h4 class="modal-title">
										${gymDto.gymName } 체육관(${gymDto.gymType })
										<font style="font-size:12pt; color: #888!important;">&nbsp;을 예약하시겠습니까?</font><br>
										
										
									</h4>
							      </div>
							      <div class="modal-body" style="font-size: 12pt; padding-left: 35px;">
							      	<!-- hidden parameters -->
							      	<input type="hidden" name="gymId" value="${gymDto.gymId }">
							      	<div style="height: 30px;"></div>
							      	
							      	<!-- 트레이너 선택 -->
									<div class="modal-body-select">
							        	<label for="selectTrainer">&nbsp;<i class="fas fa-user"></i>&nbsp;
							        	트레이너&nbsp;&nbsp;</label>
										<select name="gymTrainerPick" id="selectTrainer">
										    <option value="" disabled="disabled" selected="selected">트레이너를 선택해주세요</option>
											<c:forEach var="i" begin="0" end="3">
										    <option value="${gymTrainer[i]}">${gymTrainer[i]}</option>
									  	  	</c:forEach>
										</select>
							        </div> 
	
									<div style="height: 20px;"></div>
									<!-- 예약 날짜 선택 -->
									<div class="modal-body-select" style="display: inline-block; width: 650px;"> 
							        	<div style="display: inline-block;">
							        		<label for="datepicker">&nbsp;<i class="far fa-calendar-alt"></i>&nbsp;
							        		날짜&nbsp;&nbsp;&nbsp;&nbsp;</label>
							        	</div>
										<div id="datepicker" class="input-group date" style="display: inline-flex; ">
										    <input class="form-control" type="text" readonly style="width: 190px;" />
										    <span class="input-group-addon"><i class="glyphicon glyphicon-calendar"></i></span>
										    <input type="hidden" id="datePick" name="datePick" value=""/>
										</div>
							        </div>  
							         	
							        <!-- 시간 선택 -->
							        <div class="modal-body-select" style="display: inline-block; width: 650px;">
							        	<div style="display: inline-block; vertical-align: 12px;">
								        	<label for="time-select-style">&nbsp;<i class="far fa-clock"></i>&nbsp;
								        	시간&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
								        </div> 
							        	<div class="time-select-style" style="display: inline-block; width: 190px;" >
								        		<select id="select-options-wdays" class="select-options" name="bookHourWd" style="width: 190px;">
										    		<option value="" disabled="disabled" selected="selected">시간을 선택해주세요</option>
										 		  <c:forEach var="i" begin="0" end="${optionTimes0.size()-1 }">
												    <option value="${optionTimes0[i] }">${optionTimes0[i] }</option>
												  </c:forEach>
											 	</select>
											 
											  <select id="select-options-sat" class="select-options" name="bookHourSat" style="width: 190px;">
										    		<option value="" disabled="disabled" selected="selected">시간을 선택해주세요</option>
											  	<c:forEach var="i" begin="0" end="${optionTimes1.size()-1 }">
												    <option value="${optionTimes1[i] }">${optionTimes1[i] }</option>
												  </c:forEach>
											  </select>
											    
											  <select id="select-options-sun" class="select-options" name="bookHourSun" style="width: 190px;">
										    		<option value="" disabled="disabled" selected="selected">시간을 선택해주세요</option>
											  	<c:forEach var="i" begin="0" end="${optionTimes2.size()-1 }">
												    <option value="${optionTimes2[i] }">${optionTimes2[i] }</option>
												  </c:forEach>
											  </select>
											   
										</div>
							        </div>
							        
							        <div style="height: 15px;"></div>
							        
							        <!-- 유형 선택 -->
							        <div class="modal-body-select">
							        	&nbsp;<i class="fas fa-location-arrow"></i>
							        	유형&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							        	<input type="radio" name="bookType" value="online">&nbsp;&nbsp;온라인&nbsp;&nbsp;
										<input type="radio" name="bookType" value="offline">&nbsp;&nbsp;오프라인
							        </div>
							      </div>
							      <div style="height: 30px;"></div>
							      
							      <!-- 예약하기 -->
							      <div class="modal-footer" style="padding-right: 35px;">
						      		<h5 style="margin: 0;"><span style="color: #38b143">${gymDto.gymPass } PASS</span> 차감됩니다</h5>&nbsp;&nbsp;&nbsp;&nbsp;
							        <button type="button" class="btn btn-default" 
							        data-toggle="modal" data-target="#bookConfirmModal" data-backdrop="static" data-keyboard="false"
							        style="background-color: #38b143; color: white; font-weight:;">
							        예약하기</button>
							      </div>
						      </form>
						    </div>
						
						  </div>
						</div>
                       <!-- 예약여부 재확인 모달 -->
						<div id="bookConfirmModal" class="modal fade" role="dialog" data-backdrop="false">
						    <div class="modal-dialog">
						        <!-- Modal content-->
						        <div class="modal-content">
						            <div class="modal-body">
						                <p>예약 하시겠습니까? ${gymDto.gymPass }pass가 차감됩니다.<br/>
						                	<span>잔여 pass: ${cusPassLeft }pass</span>
						                </p>
						                <button type="button" class="btn btn-danger" id="confirmclosed" >예약</button>
						                <button type="button" class="btn btn-primary" data-dismiss="modal">취소</button>
						            </div>
						        </div>
						    </div>
						</div>
					</c:if>
						
						<!-- 로그인 안했거나, 일반회원이면 여백 -->
						<c:if test="${empty info || info.loginType eq 'custom'}">
							<div style="height: 150px;"></div>
						</c:if>
						
						<!-- 체육관회원이면 여백 -->
						<c:if test="${!empty info && info.loginType eq 'gym'}">
							<div style="height: 50px;"></div>
						</c:if>
						
                        <!-- 제휴시설 미리보기 -->
                        <div class="blog-post-categories mb-100" >
                            <div class="col-12" style="vertical-align: bottom; height: 30px; padding: 0;">
		                    	<div class="single-blog-post mb-100 gymDetailHeadLine" style="display: inline-block;">
		                    		<a href="#" class="post-title" style="font-size:12pt; width:230px; display: inline-block;">
		                    		제휴시설 미리보기</a>
		                    	</div>
		                    </div>
		                    <!-- 여백 및 줄 -->
							<hr style="width: 100%; margin-left: 0px; text-align: left,border-bottom:0px; margin-top: 20px; ">
                            <!-- 사진 영역 -->
                            <div class=right-col-box style="width: 320x; ">
                            
							<c:forEach var="i" begin="1" end="${gymPic.size() }">
								<div class="column1">
								<img src="/gyp/sfiles/gymPic/${gymPic[i-1] }" style="width:150px; height: 100px; overflow: hidden;" onclick="openModal();currentSlide(${i})" class="hover-shadow cursor">
								</div>
								<c:if test="i%2==0">
									</div><div class="row">
								</c:if>
							</c:forEach>
							
							<!-- 체육관 사진 모달 -->
							<div id="myModal" class="modal" style="z-index: 100000000001">
							  <span class="close cursor" onclick="closeModal()">&times;</span>
							  <div class="modal-content">
								<c:forEach var="i" begin="0" end="${gymPic.size()-1 }">
								    <div class="mySlides">
								      <div class="numbertext">${i+1 } / ${gymPic.size() }</div>
								      <img src="/gyp/sfiles/gymPic/${gymPic[i] }" style="width:100%">
								    </div>
							    </c:forEach> 
							    <a class="prev" onclick="plusSlides(-1)">&#10094;</a>
							    <a class="next" onclick="plusSlides(1)">&#10095;</a>
							
							    <div class="caption-container">
							      <p id="caption"></p>
							    </div>
							    
								<div class="row">
									<c:forEach var="i" begin="0" end="3">
									    <div class="column2">
									      <img class="demo cursor" src="/gyp/sfiles/gymPic/${gymPic[i] }"  
									      	style="width:90%;" onclick="currentSlide( ${i+1 })"/>
									    </div>
								 	</c:forEach> 
							 	</div> 
							  </div>
							</div>
                        </div>
                        </div>
                        
                        
                        <div style="height: 200px;"></div>
                        
                        <!-- 이용가능 시설 -->
                        <div class="blog-post-categories mb-100" style="height: 150px;">
                          
                            <div class="col-12" style="vertical-align: bottom; height: 30px; padding: 0;">
		                    	<div class="single-blog-post mb-100 gymDetailHeadLine" style="display: inline-block;">
		                    		<a href="#" class="post-title" style="font-size:12pt; width:230px; display: inline-block;">
		                    		이용가능 시설</a>
		                    	</div>
		                    </div>
                            
                            <hr style="width: 100%; margin-left: 0px; text-align: left,border-bottom:0px;">
                            <div class=right-col-box>
                            	<div class="row">
						                <c:forEach var="i" begin="0" end="3">
							                <div class="col-3">
						                        <div class="teachers-info">
						                        	<div class="facility-rect">
						                        	<!-- 문구 수정 필요 -->
							                        	<c:if test="${gymFacility[i] == '주차'}"><!-- 혹은 '주차시설 완비; -->
							                        		<img alt="주차" src="/gyp/sfiles/gymFacility/parking.png" style="opacity: 40%;">
							                        	</c:if>
							                        	<c:if test="${gymFacility[i] == '샤워장'}">
							                        		<img alt="주차" src="/gyp/sfiles/gymFacility/shower.png" style="opacity: 40%;">
							                        	</c:if>
							                        	<c:if test="${gymFacility[i] == '타올'}">
							                        		<img alt="주차" src="/gyp/sfiles/gymFacility/towel.png" style="opacity: 40%;">
							                        	</c:if>
							                        	<c:if test="${gymFacility[i] == '운동복'}">
							                        		<img alt="주차" src="/gyp/sfiles/gymFacility/tshirt.png" style="opacity: 40%;">
							                        	</c:if>
						                        	</div>
						                            <div style="justify-content: center; width:70px; text-align: center;">
							                            <font style="color:#999!important; font-size: 12pt; font-weight: bold; align-self: center;">
							                            ${gymFacility[i]}</font>
						                            </div>
						                        </div>
							                </div>
						                </c:forEach>
					                </div>
                            </div>
                        </div>
                        
                        
                        <!-- 이용 시간 -->
                        <div class="blog-post-categories mb-100">
                           	<div class="col-12" style="vertical-align: bottom; height: 30px; padding: 0;">
		                    	<div class="single-blog-post mb-100 gymDetailHeadLine" style="display: inline-block;">
		                    		<a href="#" class="post-title" style="font-size:12pt; width:230px; display: inline-block;">
		                    		이용 시간</a>
		                    	</div>
		                    </div>
                       		<hr style="width: 100%; margin-left: 0px; text-align: left,border-bottom:0px;">
                            <div class=right-col-box style="font-weight: bold; color: #888;">
				                <font color="black">평일</font> &nbsp;&nbsp;&nbsp;&nbsp;${gymHour[0] }<br/>
				                <font color="#4374D9">토요일</font> &nbsp;${gymHour[1] }<br/>
				                <font color="#E65C5C">일요일</font> &nbsp;${gymHour[2] }<br/>
				                
                            </div>
                        </div>
                        
                        <!-- 연락처 및 주소 -->
                        <div class="blog-post-categories mb-100">
                        	<div class="col-12" style="vertical-align: bottom; height: 30px; padding: 0;">
		                    	<div class="single-blog-post mb-100 gymDetailHeadLine" style="display: inline-block;">
		                    		<a href="#" class="post-title" style="font-size:12pt; width:230px; display: inline-block;">
		                    		연락처 및 주소</a>
		                    	</div>
		                    </div>
                        	<hr style="width: 100%; margin-left: 0px; text-align: left,border-bottom:0px;">
                            <div class=right-col-box style="display: inline-block;">
                            	<!-- 전화 -->
                            	<div style="display: inline-block; width: 20px;"><i class="fas fa-phone-square-alt" style="color: #999;"></i></div>
                            	<div style="display: inline-block;">${gymDto.gymTel }</div><br>
				            	<!-- 주소 -->
				            	<div style="display: inline-block; vertical-align: 20px; width: 25px;"><i class="fas fa-map-marker-alt" style="color: #999;"></i></div>
				        		<div style="display: inline-block; width: 250px;">${gymDto.gymAddr }&nbsp;${gymDto.gymAddrDetail}</div>
				                <!-- 지도 -->
				                <div style="height: 15px;"></div>
				                <div id="map" style="width:300px;height:300px;"></div>
                            </div>
                        </div>
                        


                    </div>
                </div>
            	<!-- -------------우측 컬럼 끝-------------- -->
            </div>
        </div>
    </div>
    <!-- ##### Content Area End ##### -->

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
    <!-- Bootstrap DatePicker -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.3.0/js/bootstrap-datepicker.js"></script>
    <!-- Moment js -->
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.22.2/moment.min.js"></script>
	<!-- 카카오 지도 api -->
	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=d087512990dd20366e00ecdffb1ea8cd&libraries=services,clusterer,drawing"></script>
    <!-- 짐디테일 -->
    <script src="/gyp/resources/js/gymDetail.js"></script>
    <!-- font awesome -->
	<script src="https://kit.fontawesome.com/4badd96a47.js" crossorigin="anonymous"></script>
    
</body>
</html>