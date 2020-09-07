function getXmlHttpRequest() {
	
	if(window.ActiveXObject){ //IE
		
		try {
			return new ActiveXObject("Msxml2.XMLHTTP");
		} catch (e) {
			try {
				return new ActiveXObject("Microsoft.XMLHTTP");
			} catch (e) {
				return null;
			}
		}
		
	}else if(window.XMLHttpRequest){
		return new XMLHttpRequest();
	}else{
		return null;
	}
	
}

//Ajax요청
var httpRequest = null;

function sendRequest(url,params,callback,method) {
	
	httpRequest = getXmlHttpRequest();
	
	//method 처리
	var httpMethod = method?method:"GET";
	
	if(httpMethod!="GET"&&httpMethod!="POST"){
		httpMethod = "GET";
	}
	
	//value처리
	var httpParams = (params==null||params=="")?null:params;
	
	//url처리
	var httpUrl = url;
	
	if(httpMethod=="GET" && httpParams!=null){
		httpUrl += "?" + httpParams;
	}
	
	httpRequest.open(httpMethod,httpUrl,true);
	httpRequest.setRequestHeader("Content-Type",
			"application/x-www-form-urlencoded");
	httpRequest.onreadystatechange = callback;
	httpRequest.send(httpMethod=="POST"?httpParams:null);
	
}