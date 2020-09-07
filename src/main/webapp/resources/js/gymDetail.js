/*------------ 체육관 사진 모달 ------------*/

function openModal() {
  document.getElementById("myModal").style.display = "block";
}

function closeModal() {
  document.getElementById("myModal").style.display = "none";
}

var slideIndex = 1;
showSlides(slideIndex);

function plusSlides(n) {
  showSlides(slideIndex += n);
}

function currentSlide(n) {
  showSlides(slideIndex = n);
}

function showSlides(n) {
  var i;
  var slides = document.getElementsByClassName("mySlides");
  var dots = document.getElementsByClassName("demo");
  if (n > slides.length) {slideIndex = 1}
  if (n < 1) {slideIndex = slides.length}
  for (i = 0; i < slides.length; i++) {
      slides[i].style.display = "none";
  }
  for (i = 0; i < dots.length; i++) {
      dots[i].className = dots[i].className.replace(" active", "");
  }
  slides[slideIndex-1].style.display = "block";
  dots[slideIndex-1].className += " active";
}


/*------------ 리뷰 리스트 (ajax) ------------*/

function listPage(page){	//리뷰 리스트 출력
	
	var url = "/gyp/reviewList.action?gymId=" + $("#gymId").val()
	$.post(url,{pageNum:page},function(args){
		$("#listData").html(args);
	});
	
	$("#listData").show();
	
	
}

function writeReview() {	//리뷰 작성
	var star;
	$("input[name='rating']:checked").each(function(){
		star = $(this).val();
	});
	
	var params = "cusId=" + $("#rname").val().replace(" ","")
			+ "&gymId=" + $("#gymId").val()
			+ "&star=" + star
			+ "&reContent=" + $("#rcontent").val();
	
	$.ajax({
		
		type:"POST",
		url:"/gyp/reviewCreated.action",
		data:params,
		success:function(args){

			//args로 데이터 받음.
			$("#listData").html(args);	//넘어온 데이터를 넣어준다.
			
			//초기화 작업
			$("#rcontent").val("");
			//라디오버튼 초기화
			$("input[name='rating']:checked").each(function(){
				$(this).prop('checked', false);
			});
			
		},
		beforeSend:showRequest,
		error:function(e){
			alert(e.responseText);
		}
		
	});
}


function deleteData(gymId,reNum){	//리뷰삭제
	
	var url = "/gyp/reviewDeleted.action";
	
	$.post(url,{gymId:gymId,reNum:reNum},function(args){
		$("#listData").html(args);
	});
	
}


/*------------ 리뷰 작성시 유효성 검사 ------------*/
function showRequest(){
	
	var star;
	$("input[name='rating']:checked").each(function(){
		star = $(this).val();
	});
	
	if(!star){
		alert("\평점을 입력하세요");
		return false;
	}
		
	var content = $.trim($("#rcontent").val());
	if(!content){
		//content값이 없으면
		alert("\내용을 입력하세요");
		$("#rcontent").focus();
		return false;
	}
	
	if(content.length > 500){
		alert("\n내용은 500자까지만 가능합니다.");
		$("#content").focus();
		return false;
	}
	
	return true;
	
}

/*------------ 예약 ------------*/

function bookGym(){
	//세션에 cusId없으면 로그인창으로 이동
	if(!$("#cusId").val()) {
		alert("로그인 해주세요!");
		location.href="/gyp/login.action";
		return;
	}

	//현재 날짜
	var today = new Date(); //Fri Jul 24 2020 09:47:54 GMT+0900 (대한민국 표준시)
	var _today = getFormattedDate(today); //2020-7-24
	var today_now_hour = today.getHours();//9
	
	//datepicker 세팅
	$("#datepicker").datepicker({ 
		format: "yyyy-mm-dd",
        autoclose: true, 
        todayHighlight: true,
        startDate: '-0d',
        endDate: '+15d'
	}).datepicker('update', new Date());
	
	//오늘날짜 처리
	$('#datepicker').datepicker('setDate(today)');//오늘날짜로 set
	//이후 시간 비활성화
	dis_en_ableFormerTime(today_now_hour,true);
	
		
	//날짜 선택시마다 처리 (변경할때마다)
	$('#datepicker').on('changeDate', function() {

    	dis_en_ableFormerTime(today_now_hour,false);
		//날짜 input에 세팅하기
	    $('#datePick').val(
    		$('#datepicker').datepicker('getDate')
	    );
	    
	    // 선택한 날짜
	    var selDate = new Date($('#datePick').val());//Sat Jul 25 2020 00:00:00 GMT+0900 (대한민국 표준시)
	    var _selDate = getFormattedDate(selDate); //selDate: 2020-7-25 
	    
	    //선택한 날짜가 오늘이라면 현재 시간을 포함한 이전 강의option disable시키기
	    if(_selDate == _today) {
	    	dis_en_ableFormerTime(today_now_hour,true);
	    }
	    
	    //input값에 따라 보여줄 time select box 변경 (변경시마다 타 selectbox 값 초기화)
	    if(selDate.getDay()==0) {
	    	// 일요일
	    	$('#select-options-wdays').val('');
	    	$('#select-options-sat').val('');
	    	$('#select-options-wdays').hide();
	    	$('#select-options-sat').hide();
	    	$('#select-options-sun').show();
	    } else if(selDate.getDay()==6) {
	    	// 토요일
	    	$('#select-options-wdays').val('');
	    	$('#select-options-sun').val('');
	    	$('#select-options-wdays').hide();
	    	$('#select-options-sat').show();
	    	$('#select-options-sun').hide();
	    } else {
	    	// 평일
	    	$('#select-options-sat').val('');
	    	$('#select-options-sun').val('');
	    	$('#select-options-wdays').show();
	    	$('#select-options-sat').hide();
	    	$('#select-options-sun').hide();
	    }
	});
	
	//모달 닫힘 제어
	$("#confirmclosed").click(function(){
		
		var f = document.bookForm;
		
		if(!$("#selectTrainer").val() || $("#selectTrainer").val()==""){
    		alert("트레이너를 선택해주세요");
    		$('#bookConfirmModal').modal('hide');
    		return;
    	}
		
		if(!$("#select-options-wdays").val() && !$("#select-options-sat").val() && !$("#select-options-sun").val()){
    		alert("시간을 선택해주세요");
    		$('#bookConfirmModal').modal('hide');
    		return;
    	}
		
		var bookType;
		$("input[name='bookType']:checked").each(function(){
			bookType = $(this).val();
		});
		
		if(!bookType){
			alert("\수업 형태를 선택하세요 (온라인/오프라인)");
			$('#bookConfirmModal').modal('hide');
    		return;
		}
    	f.action = "/gyp/gymBook.action";
    	f.submit();
		
	});
	
}


//날짜 Formatting함수 - (2020-7-25)
function getFormattedDate(date){
	var resultDate = date.getFullYear() + "-" +
			(date.getMonth() + 1) + "-" +
			date.getDate();
	return resultDate;
}

//현재 시간 이전시간 disable시키는 함수
function dis_en_ableFormerTime(today_now_hour,bool) {
	$('#select-options-wdays option').each(function(){
		if(this.value.substring(0,this.value.indexOf(":")) <= today_now_hour) {
			this.disabled=bool;
		}
	});	
	
	$('#select-options-sat option').each(function(){
		if(this.value.substring(0,this.value.indexOf(":")) <= today_now_hour) {
			this.disabled=bool;
		}
	});	
	
	$('#select-options-sun option').each(function(){
		if(this.value.substring(0,this.value.indexOf(":")) <= today_now_hour) {
			this.disabled=bool;
		}
	});	
}

/*------------ 찜 ------------*/

function JjimGym() {
	
	var f = document.JjimForm;
	
	//세션에 cusId없으면 로그인창으로 이동
	if(!$("#cusId").val()) {
		alert("로그인 해주세요!");
		location.href="/gyp/login.action";
		return;
	}
	
	 if($("#whetherJjim").val() == 0) {
		// WhetherJjim의 값이 0이면 checkbox의 값을 checked로 설정
		$("#jjimcheckbox").prop('checked', true);
		alert("찜 성공");
	} else {
		// WhetherJjim의  값이 1이면 checkbox의 값을 unchecked로 설정
		$("#jjimcheckbox").prop('checked', false);
		alert("찜이 해제됨");
	}
	 
	f.action = "/gyp/gymJjim.action";
	f.submit();
}

/*------------ 지도 ------------*/

function showGymMap() {
	
  	var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
    mapOption = {
        /* center: new kakao.maps.LatLng(${gymDto.gymLatitude}, ${gymDto.gymLongitude}), */ // 지도의 중심좌표
        center: new kakao.maps.LatLng(33.450701, 126.570667),	//카카오 본원을 중심좌표로 설정
        level: 2 // 지도의 확대 레벨
    };  

	// 지도를 생성합니다    
	var map = new kakao.maps.Map(mapContainer, mapOption); 

	// 주소-좌표 변환 객체를 생성합니다
	var geocoder = new kakao.maps.services.Geocoder();

	// 주소로 좌표를 검색합니다
	geocoder.addressSearch($("#gymAddr").val(), function(result, status) {

	    // 정상적으로 검색이 완료됐으면 
	     if (status === kakao.maps.services.Status.OK) {

	        var coords = new kakao.maps.LatLng(result[0].y, result[0].x);	//중심좌표 재설정

	        // 결과값으로 받은 위치를 마커로 표시합니다
	        var marker = new kakao.maps.Marker({
	            map: map,
	            position: coords
	        });

	        // 인포윈도우로 장소에 대한 설명을 표시합니다
	        var infowindow = new kakao.maps.InfoWindow({
	            content: '<div style="width:150px;text-align:center;padding:6px 0;">'+$("#gymName").val()+'</div>'
	        });
	        infowindow.open(map, marker);

	        // 지도의 중심을 결과값으로 받은 위치로 이동시킵니다
	        map.setCenter(coords);
	    } 
	}); 
}



/*------------ 최종 실행 ------------*/

$(function(){
	
	listPage(1);//처음실행시 무조건 1페이지가 나오게함
	
});

//페이지 넘길 준비 
$(document).ready(function(){
	//예약
	$("#gymBook").click(function(){
		
		bookGym();
		
	});
	
	//찜
	// 로그인 되어 있다면
		// WhetherJjim의  값이 1이면 checkbox의 값을 checked로 설정
		// WhetherJjim의 값이 0이면 checkbox의 값을 unchecked로 설정
	if($("#cusId").val()) {
		
		if($("#whetherJjim").val() == 0) {
			$("#jjimcheckbox").prop('checked', false);
		} else {
			$("#jjimcheckbox").prop('checked', true);
		} 
	}
	
	$("#jjimcheckbox").click(function(){

		JjimGym();
		
	});
	
	//지도 위치
	showGymMap();
	
});