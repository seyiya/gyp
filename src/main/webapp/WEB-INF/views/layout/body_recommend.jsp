<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

    <!-- ##### Pricing Table Area Start ##### -->
    <div class="fitness-pricing-table-area section-padding-100-0 bg-img bg-overlay bg-fixed" style="background-image: url(/gyp/resources/img/bg-img/bg-7.jpg);">
        <div class="container">
            <div class="ads_sponsors">
            
            
            <c:forEach items="${gymRecommendLists }" var="gym">
                   <!-- Single Price Table -->
                   <div class="col-12 col-md-6 col-lg-4">
                       <div class="single-price-table mb-100">
                          <c:set var="firstPic" value="${gym.gymPic }"/>
                          <c:set var="firstComma" value="${fn:indexOf(firstPic,',') }"/>
                           <img src="/gyp/sfiles/gymPic/${fn:substring(firstPic,0,firstComma) }" alt="${gym.gymName }">
                           <div class="price-table-content">
                               <!-- price -->
                               <h2 class="price">
                                   ${gym.gymPass }<span>Pass [${gym.gymType }]</span>
                               </h2>
                               <h5>${gym.gymName }</h5>
                               <!-- Price Data -->
                               <ul class="price-data">
                                   <li style="text-indent: -19px; padding-left: 12px; margin-left: 25px;">
                                      <i class="fa fa-circle" aria-hidden="true"></i>
                                      <span>TEL. ${gym.gymTel }</span></li>
                                   <li style="text-indent: -19px; padding-left: 12px; margin-left: 25px;">
                                      <i class="fa fa-circle" aria-hidden="true"></i>
                                      <span style="height:100px;">${gym.gymAddr }</span></li>
                                   <li style="text-indent: -19px; padding-left: 12px; margin-left: 25px;">
                                      <i class="fa fa-circle" aria-hidden="true"></i>
                                      <span>PROGRAM. ${gym.gymProgram }</span></li>
                               </ul>
                               <!-- btn -->
                               <a href="/gyp/gymDetail.action?gymId=${gym.gymId }" class="btn fitness-btn mt-30" style="width:260px;">예약하기</a>
                               
                           </div>
                       </div>
                   </div>
            </c:forEach>
            

            
            
            </div>
        </div>
    </div>
    <!-- ##### Pricing Table Area End ##### -->

    