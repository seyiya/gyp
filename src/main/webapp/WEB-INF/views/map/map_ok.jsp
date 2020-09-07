<%@page import="org.omg.CORBA.Request"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Iterator"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%	
	request.setCharacterEncoding("UTF-8");
	String cp = request.getContextPath();
	String[] keywords = null;
	if(request.getAttribute("gymName")!=null){
		keywords=(String[])request.getAttribute("gymName");
	}else if(request.getAttribute("gymAddr")!=null){
		keywords=(String[])request.getAttribute("gymAddr");
	}else if(request.getAttribute("gymType")!=null){
		keywords=(String[])request.getAttribute("gymType");
	}
	
	//키워드갯수와 키워드단어들을 | 로 구분
	out.print(keywords.length);
	out.print("|");
	//출력형식 5 | abc,ajax,abc마트
	for(int i=0;i<keywords.length;i++){
		out.print(keywords[i]);
		if(i!=keywords.length){
			out.print(",");
		}
	}
%>