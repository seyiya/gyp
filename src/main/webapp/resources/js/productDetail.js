
/*------------ 리뷰 리스트 (ajax) ------------*/

function listPage(page){	//리뷰 리스트 출력
	
	var url = "/gyp/productreviewList.action?productId=" + $("#productId").val();
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
			+ "&productId=" + $("#productId").val().replace(" ","")
			+ "&star=" + star
			+ "&reContent=" + $("#rcontent").val();
	
	$.ajax({
		
		type:"POST",
		url:"/gyp/productreviewCreated.action",
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


function deleteData(productId,reNum){	//리뷰삭제
	
	var url = "/gyp/productreviewDeleted.action";
	
	$.post(url,{productId:productId,reNum:reNum},function(args){
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



	$(function(){
		listPage(1);
	});
	
