<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
   request.setCharacterEncoding("UTF-8");
   String cp = request.getContextPath();
%>

<script type="text/javascript">
   
   //reviewList 총점 별점
   $("input:radio.total-rating").each(function(){
      if($(this).val() == $("#StarAvgParam").val()) {
         $(this).attr('checked','checked');
      }
   });
   
</script>
<!-- gymDetail.action에 띄울 체육관 리뷰 리스트 : ajax 사용해 호출 -->

<c:if test="${totalDataCount==0 }">
	<div style="display: inline-block; width: 100%;">
	   <!-- Post Title -->
	   <a href="#" class="post-title" style="font-size:20pt; width: 300px; display: inline-block; vertical-align: bottom; margin-top: 15px;">
	   체육관 리뷰</a>                                    
	   <!-- 전체 평점 -->
	   <div style="text-align: right; float:right; height:36px;">
	   	   총 0 개의 평가<br>
		   <!-- 평점 -->  
		   <div style=" vertical-align: middle; height: 36px; width: 220px; vertical-align: bottom; font-size: 17pt; color: #38b143; font-weight: bold;">
		   		평균 0 점
		   </div>
	    </div>
	</div>
	<div style="height: 35px;"></div>
	<div style="width: 100%; text-align: center; font-size: 12pt; font-weight: bold; color: #38b143;">등록된 리뷰가 없습니다.</div> 
	<div style="height: 35px;"></div>
</c:if>



<c:if test="${totalDataCount!=0 }">
   <div style="display: inline-block; width: 100%;">
	   <!-- Post Title -->
	   <a href="#" class="post-title" style="font-size:20pt; width: 300px; display: inline-block; vertical-align: bottom; margin-top: 15px;">
	   체육관 리뷰</a>                                    
	   <!-- 전체 리뷰 수 -->
	   <input type="hidden" id="StarAvgParam" value="${starAvg }"/>
	   
	   <!-- 전체 평점 -->
	   <div style="text-align: right; float:right; height:36px;">
	   	   총 ${totalDataCount }개의 평가<br>
		   <fieldset class="ratingT" disabled="disabled">
		       <input type="radio" id="star5T" name="ratingT" class="total-rating" value="10" /><label class = "full" for="star5T" title="10점"></label>
		       <input type="radio" id="star4halfT" name="ratingT" class="total-rating" value="9"/><label class="half" for="star4halfT" title="9점"></label>
		       <input type="radio" id="star4T" name="ratingT" class="total-rating" value="8" /><label class = "full" for="star4T" title="8점"></label>
		       <input type="radio" id="star3halfT" name="ratingT" class="total-rating" value="7" /><label class="half" for="star3halfT" title="7점"></label>
		       <input type="radio" id="star3T" name="ratingT" class="total-rating" value="6" /><label class = "full" for="star3T" title="6점"></label>
		       <input type="radio" id="star2halfT" name="ratingT" class="total-rating" value="5" /><label class="half" for="star2halfT" title="5점"></label>
		       <input type="radio" id="star2T" name="ratingT" class="total-rating" value="4" /><label class = "full" for="star2T" title="4점"></label>
		       <input type="radio" id="star1halfT" name="ratingT" class="total-rating" value="3" /><label class="half" for="star1halfT" title="3점"></label>
		       <input type="radio" id="star1T" name="ratingT" class="total-rating" value="2" /><label class = "full" for="star1T" title="2점"></label>
		       <input type="radio" id="starhalfT" name="ratingT" class="total-rating" value="1" /><label class="half" for="starhalfT" title="1점"></label>
		   </fieldset>
		   <!-- 평점 -->  
		   <div style=" vertical-align: middle; height: 36px; width: 250px; vertical-align: bottom; font-size: 17pt; color: #38b143; font-weight: bold;">
		   		평균 ${starAvg }점
		   </div>
	    </div>
	</div>
   <c:forEach var="dto" items="${reviewLists }" varStatus="status">
      <hr>
      <!-- 리뷰 글쓴이 -->
      <div class="post-meta" style="display: inline-block; width: 400px; margin: 0; margin-top: 5px; font-weight: bold;'">
	      	<font style="color:#38b143;">${dto.cusId }</font>&nbsp;님의 리뷰&nbsp;
	      	<span style="color:#bbbbbb;">[${dto.reCreated }]</span>
	      	<c:if test="${!empty info.sessionId && info.sessionId == dto.cusId}">
	        	<span><a href="javascript:deleteData('${dto.gymId }','${dto.reNum }','${pageNum }')" style="color:#F0787F;">
	        	&nbsp;[삭제]</a></span>
	      	</c:if>
      </div>
      <!-- 평점 -->
      <div style=" width: 250px; height:36px; display: inline-block; float: right; text-align: right;">
	      <fieldset class="ratingP" disabled="disabled">
	          <input type="radio" id="star5P" name="ratingP${status.count}" class="personal-rating${status.count}" value="10" /><label class = "full" for="star5P" title="10점"></label>
	          <input type="radio" id="star4halfP" name="ratingP${status.count}" class="personal-rating${status.count}" value="9"/><label class="half" for="star4halfP" title="9점"></label>
	          <input type="radio" id="star4P" name="ratingP${status.count}" class="personal-rating${status.count}" value="8" /><label class = "full" for="star4P" title="8점"></label>
	          <input type="radio" id="star3halfP" name="ratingP${status.count}" class="personal-rating${status.count}" value="7" /><label class="half" for="star3halfP" title="7점"></label>
	          <input type="radio" id="star3P" name="ratingP${status.count}" class="personal-rating${status.count}" value="6" /><label class = "full" for="star3P" title="6점"></label>
	          <input type="radio" id="star2halfP" name="ratingP${status.count}" class="personal-rating${status.count}" value="5" /><label class="half" for="star2halfP" title="5점"></label>
	          <input type="radio" id="star2P" name="ratingP${status.count}" class="personal-rating${status.count}" value="4" /><label class = "full" for="star2P" title="4점"></label>
	          <input type="radio" id="star1halfP" name="ratingP${status.count}" class="personal-rating${status.count}" value="3" /><label class="half" for="star1halfP" title="3점"></label>
	          <input type="radio" id="star1P" name="ratingP${status.count}" class="personal-rating${status.count}" value="2" /><label class = "full" for="star1P" title="2점"></label>
	          <input type="radio" id="starhalfP" name="ratingP${status.count}" class="personal-rating${status.count}" value="1" /><label class="half" for="starhalfP" title="1점"></label>
	      </fieldset>
	      <!-- 평점 --> 
	      <div style=" height: 36px; width: 80px; display:inline-block; font-size: 12pt; color: #888; padding-top: 3px; ">
	         ${dto.star}점&nbsp;<font style="font-size: 2pt;">(총 10점)</font>
	      </div> 
          <input type="hidden" id="personalAvgParam-${status.count}" value="${dto.star }"/>
      </div>
      
      <!-- 여백 -->
      <div style="height: 15px;"></div>
      
      <!-- 리뷰 내용 -->
      <div>${dto.reContent }</div>
      
      <script type="text/javascript">
         //reviewList 개인별 별점
          $("input:radio.personal-rating${status.count}").each(function(){
             if($(this).val() == $("#personalAvgParam-${status.count}").val()) {
                $(this).attr('checked','checked');
                return;
             }
          });
      </script>
       
	</c:forEach>
	<!-- 페이징 -->
	<div style="height: 50px;"></div>
	<div style="text-align: center;">${pageIndexList }</div>
</c:if>




<!-- ************리뷰 작성************ -->
<!-- 리뷰 작성 : 회원 세션에 cusId가 올라가있으면서, 해당 페이지의 gymId의 Book 목록에 cusId가 있으면 보이게하기 -->
<c:if test="${!empty info.sessionId && timesCusBookedGym!=0 && timesCusReviewedGym<timesCusBookedGym}">
	<!-- 여백 -->
	<div style="height: 30px;"></div>
	
	<!-- title -->
	<a href="#" class="post-title" style="font-size:20pt; ">
	리뷰 작성</a>
	
	
	<!-- 작성자 및 별정 -->
	<div style="display: inline-block; width:100%; height: 50px; vertical-align: middle;">
		<!-- 아이디칸 -->
		<div style="display: inline-block; width: 200px; margin-bottom: 10px;">
		<input type="text" id="rname" size="20" maxlength="20" class="boxTF" value="${info.sessionId }" disabled
		style=" padding-left: 5px;"/>
		</div>
		<!-- 별표 -->
			<div style="text-align: right; width:200px; height:36px; display: inline-block; vertical-align: -12px; "> 
				<fieldset class="ratingM">
				      <input type="radio" id="star5" name="rating" value="10" /><label class = "full" for="star5" title="10점"></label>
				      <input type="radio" id="star4half" name="rating" value="9" /><label class="half" for="star4half" title="9점"></label>
				      <input type="radio" id="star4" name="rating" value="8" /><label class = "full" for="star4" title="8점"></label>
				      <input type="radio" id="star3half" name="rating" value="7" /><label class="half" for="star3half" title="7점"></label>
				      <input type="radio" id="star3" name="rating" value="6" /><label class = "full" for="star3" title="6점"></label>
				      <input type="radio" id="star2half" name="rating" value="5" /><label class="half" for="star2half" title="5점"></label>
				      <input type="radio" id="star2" name="rating" value="4" /><label class = "full" for="star2" title="4점"></label>
				      <input type="radio" id="star1half" name="rating" value="3" /><label class="half" for="star1half" title="3점"></label>
				      <input type="radio" id="star1" name="rating" value="2" /><label class = "full" for="star1" title="2점"></label>
				      <input type="radio" id="starhalf" name="rating" value="1" /><label class="half" for="starhalf" title="1점"></label>
				  </fieldset>
		   </div>
		<!-- 등록 버튼 -->
		<div style="display: inline-block; float: right; height: 36px; padding-top: 3px;">
			<input type="button" value="등록하기" class="btn fitness-btn m-2" id="rsendButton"
				style="min-width: 40px!important; height: 30px; margin:0!important; line-height: 0;"
	            onclick="javascript:writeReview();"/>
        </div>
	</div>
	<!-- 내용 -->
	<textarea rows="3" cols="102" class="boxTA" style="height:50px;" id="rcontent"></textarea>
	
	
	

</c:if>
