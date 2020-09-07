function deleteData(){
		
		var notiNum = "${dto.notiNum}";
		var pageNum = "${pageNum}";
		var params = "?notiNum=" + notiNum + "&pageNum=" + pageNum;
		var url = "<%=cp%>/noticeDeleted.action" + params;
		
		location.replace(url);
		
	}
	
	function updateData(){
		
		var notiNum = "${dto.notiNum}";
		var pageNum = "${pageNum}";
		var params = "?notiNum=" + notiNum + "&pageNum=" + pageNum;
		var url = "<%=cp%>/noticeUpdated.action" + params;
		
		location.replace(url);
		
	}
	

	function sendIt(){
		
		f = document.myForm;
		
		str = f.notiTitle.value;
		str = str.trim();
		
		if(!str){
			alert("\n제목을 입력하세요");
			f.notiTitle.focus();
			return;			
		}
		f.notiTitle.value = str; 
	
		
		str = f.notiContent.value;
		str = str.trim();
		
		if(!str){
			alert("\n내용을 입력하세요");
			f.notiContent.focus();
			return;			
		}
		f.notiContent.value = str; 
		
		if(f.mode.value=="insert")
			f.action = "/gyp/noticeCreated_ok.action";
		else
			f.action = "/gyp/noticeUpdated_ok.action";	
		f.submit();
		
		
	}


