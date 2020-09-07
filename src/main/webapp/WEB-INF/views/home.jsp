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
   <!-- Favicon -->
   <link rel="icon" href="/gyp/resources/img/core-img/favicon.ico">
   <!-- Core Stylesheet -->
   <link rel="stylesheet" href="/gyp/resources/css/style.css">
   <!-- font -->
   <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400&display=swap" rel="stylesheet">
   
   
   <!-- 추천 슬라이드 -->
   <link rel="stylesheet" type="text/css" href="//cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.css"/>

   <style type="text/css">
   .ads_sponsors div img{
      width:340px;
      height:200px;
      }
   </style>
   
   
<title>GYP</title>
</head>
<body style="font-family: 'Noto Sans KR', sans-serif;">
   
   <jsp:include page="/WEB-INF/views/layout/header_over.jsp" />
   <!-- 메인 : header_main.jsp / 그외 : header_below.jsp -->
   <jsp:include page="/WEB-INF/views/layout/header_main.jsp" />
   
   
   <!-- 추천 슬라이드 -->
   <jsp:include page="/WEB-INF/views/layout/body_recommend.jsp" />
   
   
   <div style="margin: 0 auto; width:1070px;">
      <img  alt="브랜드 소개" align="middle" src="resources/img/imagePage/gyp_main.jpg">
         
      <div style="margin: 0 auto; width:250px; ">
             <div class="elements-title mb-50">
                  <div class="fitness-buttons-area mb-100">
                        <a href="/gyp/passCharge.action" class="btn fitness-btn btn-2 m-2"
                           style="width: 250px; height: 60px; justify-content: center;
                           padding-top : 6px;
                           font-size:15pt; margin: 0 auto;">
                           이용권 구입</a>
                  </div>
              </div>
         </div>
   </div>
   
      
      <!-- 상품추천 -->  
      
      <div style="margin: 0 auto; width: 1140px;" class="mb-100">
         <h4 style="padding-left: 40px;"><font color="#38b143">인기 상품</font><span>&nbsp;
         <a href="/gyp/productList.action">더보기</a></span></h4><hr/>
         <br>
         <c:forEach var="productDTO" items="${productRecommendLists }">
              <div class="single-price-table" style="width: 282px; display: inline-block;  border-radius:15px; ">
                   <div class="price-table-content">
                      <!-- image -->
                      <img src="/gyp/sfiles/product/${productDTO.productImg}" alt="${productDTO.productName }"
                          style="width: 200px; height: 200px;">
                       <!-- 여백 -->
                       <div style="height: 10px;"></div>
                      <!-- price -->
                      <h4 class="price"><span>${productDTO.productId }(조회수: ${productDTO.productHit })</span></h4>
                      <!-- Name -->
                      <h5>${productDTO.productName }</h5>
                      <!-- Price Data -->
                      <ul class="price-data">
                          <li><i class="fa fa-circle" aria-hidden="true"></i> &#8361;${productDTO.productPrice }</li>
                          <li><i class="fa fa-circle" aria-hidden="true"></i>${productDTO.productContent }</li>
                      </ul>
                      <!-- btn -->
                      <a href="/gyp/productDetail.action?productId=${productDTO.productId }" class="btn fitness-btn mt-30">자세히 보기</a>
                   </div>
               </div>
         </c:forEach>
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
    
    
    <!-- 추천슬라이드 -->
    <script type="text/javascript" src="//cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.min.js"></script>
   <script src="https://static.codepen.io/assets/common/stopExecutionOnTimeout-157cd5b220a5c80d4ff8e0e70ac069bffd87a61252088146915e8726e5d9f147.js"></script>
   <script src='https://cdnjs.cloudflare.com/ajax/libs/slick-carousel/1.5.9/slick.min.js'></script>
   
   <script type="text/javascript">
       $('.ads_sponsors').slick({
          autoplay: true,
          autoplaySpeed: 2000,
          slidesToShow: 3,
         slidesToScroll: 1,
         arrows: false
       });
   </script>


</body>
</html>