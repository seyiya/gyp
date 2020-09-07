function sendIt(){
		
	f = document.searchForm;
		
	f.action="/gyp/qnaList.action";
	f.submit();
}

	function sendIt() {

		f = document.myForm;

		str = f.qnaTitle.value;
		str = str.trim();

		if (!str) {
			alert("\n제목을 입력하세요");
			f.qnaTitle.focus();
			return;
		}
		f.qnaTitle.value = str;
		
		str = f.mode.value;
		if(!($('input:radio[name="qnaType"]').is(':checked'))&&(str=="insert")){
			alert("\n질문유형을 선택해주세요");
			return;
		}
		f.mode.value = str;
		
		str = f.qnaContent.value;
		str = str.trim();

		if (!str) {
			alert("\n내용을 입력하세요");
			f.qnaContent.focus();
			return;
		}
		f.qnaContent.value = str;

		if (f.mode.value=="insert")
			f.action = "/gyp/qnaCreated_ok.action";
		else if(f.mode.value=="update")
			f.action = "/gyp/qnaUpdated_ok.action";
		else if(f.mode.value=="reply")
			f.action = "/gyp/qnaReply_ok.action";
		
		f.submit();
	}
	
	function qnaTypeCheck(){
		var chkcount = document.getElementsByName("qnaType").length;
		
		for(var i=0;i<chkcount;i++){
			if(document.getElementsByName("qnaType")[i].checked == true){
				var qnaTypeChk = document.getElementsByName("qnaType")[i].value;
				$("#space").html(qnaTypeChk);
			}
		}
		
		
		
	}

	function deleteData() {

		var qnaNum = "${dto.qnaNum}";
		var pageNum = "${pageNum}";
		var params = "?qnaNum=" + qnaNum + "&pageNum=" + pageNum;
		var url = "/gyp/qnaDeleted.action" + params;

		location.replace(url);

	}

	function updateData() {

		var qnaNum = "${dto.qnaNum}";
		var pageNum = "${pageNum}";
		var params = "?qnaNum=" + qnaNum + "&pageNum=" + pageNum;
		var url = "/gyp/qnaUpdated.action" + params;

		location.replace(url);

	}

	function sendData() {

		var qnaNum = "${dto.qnaNum}";
		var pageNum = "${pageNum}";
		var params = "?qnaNum=" + qnaNum + "&pageNum=" + pageNum;
		var url = "/gyp/qnaReply.action" + params;

		location.replace(url);

	}