package com.exe.filter;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.exe.dto.CustomInfo;

public class LoginCheckFilter implements Filter {
	
	//필터가 생성되면서 실행될 메소드
	@Override
	public void init(FilterConfig filterConfig) throws ServletException {
		System.out.println("LoginCheckFilter is created!!");
	}

	//호출마다 실행될 메소드
	@Override
	public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain)
			throws IOException, ServletException {
		HttpServletRequest request = (HttpServletRequest) req;
		HttpServletResponse response = (HttpServletResponse) resp;
        String requestURI = request.getRequestURI();
        CustomInfo dto = null;
        dto = (CustomInfo) request.getSession().getAttribute("customInfo");
        
        
        //특정 조건 로그인 필터
        if(dto!=null) {
        	//특정 조건 로그인이 들어가면 안 되는 곳
        	if(dto.getSessionId().equals("admin")) { //관리자
        		
        		if(requestURI.equals("/gyp/login.action")||requestURI.equals("/gyp/searchpw.action")||
        				requestURI.equals("/gyp/searchid.action")||requestURI.equals("/gyp/productreviewCreated.action")||
                        requestURI.equals("/gyp/passCharge.action")||requestURI.equals("/gyp/faceLink.action")||
                        requestURI.equals("/gyp/productList.action")||requestURI.equals("/gyp/qnaCreated.action")){
        			
        			//이동할 링크
        			response.sendRedirect("/gyp/adminHome.action");
        			return;
        			
                }
        		
        	}else if(dto.getLoginType().equals("customer")) { //고객
        		
        		//요청 URI가 /gyp/어쩌구저쩌구 혹은 /gyp/어쩌구저쩌구 일 때
        		if(requestURI.equals("/gyp/login.action")||requestURI.equals("/gyp/searchpw.action")||
        				requestURI.equals("/gyp/searchid.action")||requestURI.equals("/gyp/adminHome.action")||
        				requestURI.equals("/gyp/adminGymList.action")||requestURI.equals("/gyp/adminCustomerList.action")||
        				requestURI.equals("/gyp/adminProductList.action")||requestURI.equals("/gyp/adminProductList.action")||
        				requestURI.equals("/gyp/gymMyPage.action")){
        			
        			//이동할 링크
        			response.sendRedirect("/gyp");
        			return;
        			
                }
        	}else if(dto.getLoginType().equals("gym")) { //체육관
        		
        		if(requestURI.equals("/gyp/gymJjim.action")||requestURI.equals("/gyp/login.action")||
        				requestURI.equals("/gyp/searchpw.action")||requestURI.equals("/gyp/searchid.action")||
        				requestURI.equals("/gyp/qnaCreated.action")||requestURI.equals("/gyp/productList.action")||
                        requestURI.equals("/gyp/passCharge.action")||requestURI.equals("/gyp/productreviewCreated.action")){
        			
        			//이동할 링크
        			response.sendRedirect("/gyp/gymMyPage.action");
        			return;
        			
                }
        	}
        	
        
        }
        
        //비로그인 시 적용될 필터
        if(dto==null) {
        	if(requestURI.equals("/gyp/faceLink.action")||requestURI.equals("/gyp/noticeCreated_ok.action")||
        		requestURI.equals("/gyp/noticeCreated.action")||requestURI.equals("/gyp/gymJjim.action")||requestURI.equals("/gyp/adminHome.action")||
        		requestURI.equals("/gyp/adminGymList.action")||requestURI.equals("/gyp/adminCustomerList.action")||
        		requestURI.equals("/gyp/adminProductList.action")||requestURI.equals("/gyp/gymMyPage.action")||
        		requestURI.equals("/gyp/productreviewCreated.action")||requestURI.equals("/gyp/mapGymJjim.action")) {
	        	//로그인 화면으로 보냄
	        	response.setContentType("text/html; charset=UTF-8");
	            PrintWriter out = response.getWriter();
	            out.println("<script>alert('로그인 후 이용해주세요');location.href='/gyp/login.action';</script>");
	            out.flush();
	        	return;
        	}
        }
       
        chain.doFilter(req, resp);
       
	}

	//필터가 소멸하면서 실행될 메소드
	@Override
	public void destroy() {
		System.out.println("LoginCheckFilter is destroyed!!");
	}

}
