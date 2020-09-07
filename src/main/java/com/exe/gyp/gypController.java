package com.exe.gyp;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.ResourceLoader;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.exe.dao.GypDAO;
import com.exe.dto.BookDTO;
import com.exe.dto.CartDTO;
import com.exe.dto.ChargeDTO;
import com.exe.dto.CusProductOrderDTO;
import com.exe.dto.CustomInfo;
import com.exe.dto.CustomerDTO;
import com.exe.dto.GymDTO;
import com.exe.dto.JjimDTO;
import com.exe.dto.ReviewDTO;
import com.exe.util.MyUtil;
import com.exe.util.MyUtil_Map;
import com.exe.dto.NoticeDTO;
import com.exe.dto.ProductDTO;
import com.exe.dto.ProductOrderDTO;
import com.exe.dto.ProductPayDTO;
import com.exe.dto.ProductPayDetailDTO;
import com.exe.dto.QnaDTO;

@Controller
public class gypController {
	
	/** 샘플 스레드 */
	@Resource(name = "asyncTaskSample")
    private AsyncTaskSample asyncTaskSample;
    
    /** AsyncConfig (스레드 설정) */
    @Resource(name = "asyncConfig")
    private AsyncConfig asyncConfig;
	
	@Autowired
	@Qualifier("gypDAO")
	GypDAO dao;
	
	@Autowired
	MyUtil myUtil;
	
	@Autowired
	MyUtil_Map myUtilMap;
	
	int n=0;//스레드에서 쓰임
	
	//☆☆☆ 이미지 파일 저장 경로 ☆☆☆ 
	// - 배포시 war파일로 만들때, 내부 서버의 파일들이 삭제되기에 외부 경로 파일 저장 폴더를 만든다. 
	// - 이 부분과 더불어 tomcat서버의 server.xml에 다음 문장을 추가해준다. 
	//	 		<Context docBase="D:/gyp_external_files/" path="/gyp/sfiles" reloadable="true"/>
	// 			</Host>태그 이전에 추가해야함
	// - 실제 파일 저장 경로는 D:/gyp_external_files/이고 프로그램 내에서 접근하는 가상 경로는 /gyp/sfiles/ 이다.
	
	// - <추후에 개인적으로 경로 변경가능>
	// - 바꿀곳 2군데 : 1.컨트롤러의 PATH  2. Servers폴더의 server.xml의 docBase경로
	
	// - 각 메소드에서 상세 링크변수를 따로 생성하여 파일을 저장해야 PATH 경로가 보존된다
	// - (예)imgPath = PATH + product\\를 따로 생성해서 사용한다
	// - 자세한 설명 참고 사이트:( https://byson.tistory.com/20)
	String PATH = "D:\\gyp_external_files\\";
	
	
	//*******************최보경*******************
	
	//home
	@RequestMapping(value="/",method = {RequestMethod.GET, RequestMethod.POST})
	public String home(HttpServletRequest request,HttpSession session) throws InterruptedException {
		
		//처음 메인 시작 시 예약을 체크하는 쓰레드 실행
		if(this.n==0) {
			this.n++;
			startBookCheck();
		}
		
		//세션에 올라온값 받기
		CustomInfo info = (CustomInfo)session.getAttribute("customInfo");
		
		
		//체육관 추천 리스트 선언 ------------------------------------------
		List<GymDTO> gymRecommendLists = null;
		
		//로그인되어 있지 않으면 "강남구" 리스트 추천
		gymRecommendLists = dao.getGymRecommendDefault();
		
		
		//로그인 되어 있고
		if(info!=null) {
			
			//체육관 회원이면 마이페이지로
			int result = dao.getDataCount(info.getSessionId());//유저로 로그인하면 result값은 1 gym으로 로그인 하면 0
			if(result==0 || info.getLoginType()=="gym") {
				return "redirect:/gymMyPage.action";
			}
			
			//일반 회원이면 주소 추출
			String customerAddr = dao.getCusAddr(info.getSessionId());
			
			
			//"구"가 존재하면 자름
			if(customerAddr.indexOf("구")!=-1) {
				customerAddr = customerAddr.substring(customerAddr.indexOf("구")-2, customerAddr.indexOf("구")+1);
				gymRecommendLists = dao.getGymRecommend(customerAddr);//해당 "구"의 체육관 리스트
			
			//주소에 "구"가 없으면 "강남구"리스트 추천
			}else {
				gymRecommendLists = dao.getGymRecommendDefault();
			}
			
			//체육관 리스트가 널인 경우, 기본 리스트로 대체 (에러방지)
			if(gymRecommendLists == null) {
				gymRecommendLists = dao.getGymRecommendDefault();
			}
		}
		
		
		
		//확장for문, 하나씩 꺼내서 글자길이 수정
		for(GymDTO show : gymRecommendLists) {
			
			int start = show.getGymName().indexOf("(");
			
			if(start>0) { //괄호가 존재하면
				show.setGymName(show.getGymName().substring(0, start)); //괄호부터 끝까지 자르고 다시 set
			}
			if(show.getGymProgram().length() > 13) { //프로그램 길면 자르기
				show.setGymProgram(show.getGymProgram().substring(0, 13) + " ...");
			}
		}

		//상품 추천 리스트 선언 ------------------------------------------
		List<ProductDTO> productRecommendLists = null;
		String productType = null;
		String gymType = null;
		
		productRecommendLists = dao.getProductRecommendDefault();
			
		if(info!=null) {//로그인 되어 있으면
			
			//최신 예약한 체육관 타입 추출
			gymType = dao.getCusRecentBookType(info.getSessionId());
			
			//최신 예약한 체육관 타입이 존재하면
			if(gymType != null) {
				
				if(gymType.equals("헬스")) {
					productType = "H";
				}else if(gymType.equals("필라테스")) {
					productType = "P";
				}else if(gymType.equals("요가")) {
					productType = "Y";
				}
				//producId의 첫글자가 같은것만 디비에서 추출 (조회순)
				productRecommendLists = dao.getProductRecommend(productType);

			//최신 예약이 없으면 default 리스트 추출
			}else if(gymType==null || gymType.equals("")) {
				productRecommendLists = dao.getProductRecommendDefault();
			}
		}
		
		//확장for문, 하나씩 꺼내서 글자길이 수정
		for(ProductDTO dto : productRecommendLists) {
			if(dto.getProductContent().length() > 13) { //프로그램 길면 자르기
				dto.setProductContent(dto.getProductContent().substring(0, 13) + " ...");
			}
		}
			
		request.setAttribute("info", info);
		request.setAttribute("gymRecommendLists", gymRecommendLists);
		request.setAttribute("productRecommendLists", productRecommendLists);
		return "home";
	}
	
	//이용방법
	@RequestMapping(value="/howToUse.action",method = {RequestMethod.GET, RequestMethod.POST})
	public String howToUse(HttpServletRequest request) {
		
		return "howToUse/howToUse";
	}
	
	//*******************원도현*******************

	// 로그인 화면
	@RequestMapping(value = "/login.action", method = { RequestMethod.GET, RequestMethod.POST })
	public String login() {
		return "login/login";
	}

	// 로그인시
	@RequestMapping(value = "/login_ok.action", method = { RequestMethod.GET, RequestMethod.POST })
	public String login_ok(HttpServletRequest request, HttpServletResponse response) throws Exception {

		HttpSession session = request.getSession(); // 세션 생성
		CustomInfo info = new CustomInfo(); // 세션값을 저장하기 위해 객체 생성
		String history = request.getParameter("history"); // 로그인 이전 페이지 기록

		if (history == null || history.equals("")) {
			history = "/";
		}

		history = history.substring(history.lastIndexOf("/"), history.length()); // 주소의 마지막 슬래시 추출

		// 회원가입 후, 로그인창으로 이동했을때, 로그인하고 이전페이지(회원가입 등)으로 돌아가기 방지
		if (history.equals("/createCustomer.action") || history.equals("/createGym.action")  
				|| history.equals("/login.action") || history.equals("/searchpw.action")) {
			history = "/";
		}
		// 제품 상세에서 로그인 안했을 경우, 로그인 창으로 이동했다가 productId를 못갖고 와서 에러 뜨는것 방지
		if (history.contains("/productDetail.action")) {
			history = "/productList.action";
		}

		String sessionId = request.getParameter("sessionId");// input 입력한값
		String sessionpwd = request.getParameter("sessionpwd");

		int result = dao.getDataCount(sessionId);// 유저로 로그인하면 result값은 1 gym으로 로그인 하면 0
		String loginType = null; // customer 인지, gym인지 저장

		if (result == 1) {// 유저가 로그인
			CustomerDTO dto = dao.getLoginReadData(sessionId);
			loginType = "customer";
			if (dto == null || !dto.getCusPwd().equals(sessionpwd)) {
				request.setAttribute("message", "아이디 또는 패스워드를 정확히 입력하세요! ");
				return "login/login";
			}

		} else if (result == 0) {// 체육관 로그인 ( 체육관 로그인시 바로 마이페이지 이동)
			GymDTO dto = dao.getGymLoginReadData(sessionId);
			loginType = "gym";
			if (dto == null || !dto.getGymPwd().equals(sessionpwd)) {
				request.setAttribute("message", "아이디 또는 패스워드를 정확히 입력하세요! ");
				return "login/login";
			}
		}

		info.setSessionId(sessionId); // 세션에 값 입력
		info.setLoginType(loginType);// 로그인 타입(customer, gym )
		session.setAttribute("customInfo", info); // 세션에 info에 들어가있는정보(userid,username)이 올라간다.

		if (loginType == "customer") {

			// 관리자 로그인
			if (sessionId.equals("admin") || info.getSessionId().equals("admin")) {
				return "redirect:/adminHome.action";
			}
			return "redirect:" + history; // 로그인 성공

		} else {
			return "redirect:/gymMyPage.action";
		}
	}

	// 유저 로그아웃
	@RequestMapping(value = "/logout.action", method = { RequestMethod.GET, RequestMethod.POST })
	public String logout_ok(HttpServletRequest request, HttpSession session, CustomerDTO dto) throws Exception {

		// 로그아웃시 세션 제거
		session.removeAttribute("customInfo"); // customInfo 안에 있는 데이터를 지운다
		session.invalidate(); // customInfo 라는 변수도 지운다.
		return "redirect:/";
	}

	// 유저 패스워드 보여주기창
	@RequestMapping(value = "/searchpw.action", method = { RequestMethod.GET, RequestMethod.POST })
	public String searchpw() {

		return "login/searchpw";
	}

	// 유저 패스워드 찾기
	@RequestMapping(value = "/searchpw_ok.action", method = { RequestMethod.GET, RequestMethod.POST })
	public String searchpw_ok(HttpServletRequest request) throws Exception {

		String cusId = request.getParameter("cusId");
		String custel = request.getParameter("custel");
		CustomerDTO dto = dao.getLoginReadData(cusId);
		
		if (dto == null || !dto.getCusTel().equals(custel)) { // 아이디가 틀리거나 전화번호가 틀린경우
			request.setAttribute("message", "아이디 또는 전화번호가 일치하지 않습니다");
			return "login/searchpw";

		} else if (dto.getCusId().equals(cusId) || dto.getCusTel().equals(custel)) {
			request.setAttribute("message", "비밀번호는 [" + dto.getCusPwd() + "] 입니다");

		}
		return login();
	}

	// 유저 아이디 찾는 보여주는창
	@RequestMapping(value = "/searchid.action", method = { RequestMethod.GET, RequestMethod.POST })
	public String searchid() {

		return "login/searchid";
	}

	// 유저 아이디 찾기
	@RequestMapping(value = "/searchid_ok.action", method = { RequestMethod.GET, RequestMethod.POST })
	public String searchid_ok(HttpServletRequest request) throws Exception {

		String cusName = request.getParameter("cusName");
		String cusTel = request.getParameter("cusTel");

		Map<String, Object> hMap = new HashMap<String, Object>();
		hMap.put("cusName", cusName);
		hMap.put("cusTel", cusTel);

		// 아이디 찾기는 이름으로 검색하기 때문에 이름으로 검색하는 dao를 하나더 만들어준다
		CustomerDTO dto = dao.getLoginIdReadData(hMap);

		if (dto == null || !dto.getCusTel().equals(cusTel)) { // 이름가 틀리거나 전화번호가 틀린경우
			request.setAttribute("message", "이름 또는 전화번호가 일치하지 않습니다"); ////
			return "login/searchid";

		} else if (dto.getCusName().equals(cusName) || dto.getCusTel().equals(cusTel)) {
			request.setAttribute("message", "아이디는 [" + dto.getCusId() + "] 입니다");
		}
		return "login/login";
	}

	// User 마이페이지
   @RequestMapping(value = "/customerMyPage.action", method = { RequestMethod.GET, RequestMethod.POST })
   public String customerMyPage(HttpServletRequest request, HttpSession session) {

      CustomInfo info = (CustomInfo)session.getAttribute("customInfo");
      if(info==null) {
         return "redirect:/login.action";
      }

      // 유저정보
      CustomerDTO cusdto = dao.getCustromerDTOReadData(info);

      // 리뷰 아이디값 검색하기 위해
      String reviewId = info.getSessionId();
      // 찜 아이디값 검색하기 위해
      String jjimId = info.getSessionId();
      // 예약 아이디값 검색하기 위해
      String bookId = info.getSessionId();
      

      // 체육관 리뷰리스트
      List<ReviewDTO> reviewlists = dao.reviewgetList(reviewId);
      // 찜 리스트
      List<JjimDTO> jjimlists = dao.jjimgetList(jjimId);
      // 예약 리스트
      List<BookDTO> booklists = dao.bookgetList(bookId);
      // 상품 결제 리스트 (S)
      List<CusProductOrderDTO> orderLists = dao.getCusOrderList(info.getSessionId());

      
      request.setAttribute("booklists", booklists);
      request.setAttribute("reviewlists", reviewlists);
      request.setAttribute("jjimlists", jjimlists);
      request.setAttribute("orderLists", orderLists);
      request.setAttribute("cusdto", cusdto);
      request.setAttribute("imagePath", "/gyp/sfiles/product/");

      return "myPage/customerMyPage";
   }
	   
   	// GYM 마이페이지
   	@RequestMapping(value = "/gymMyPage.action", method = { RequestMethod.GET, RequestMethod.POST })
   	public String gymMyPage(HttpServletRequest request, HttpSession session) throws ParseException {

      CustomInfo info = (CustomInfo) session.getAttribute("customInfo");

      // 리뷰 아이디값 검색하기 위해
      String reviewId = info.getSessionId();
      // 예약 아이디값 검색하기 위해
      String bookId = info.getSessionId();
      // 체육관 아이디
      String gymId = info.getSessionId();
      // 넘어오는값
      String strYear = request.getParameter("year");
      // 넘어오는값
      String strMonth = request.getParameter("month");

      // 캘린더 사용
      Calendar cal = Calendar.getInstance();
      // 현재 년도
      int year = cal.get(Calendar.YEAR);
      // 현재 월
      int month = cal.get(Calendar.MONTH) + 1;

      // 넘어오는 값이 없을 경우에, 현재 날짜 넣어줌
      if (strYear == null || strYear.equals(""))
         strYear = Integer.toString(year);
      if (strMonth == null || strMonth.equals(""))
         strMonth = Integer.toString(month);

      // 숫자로 변환
      year = Integer.parseInt(strYear);
      month = Integer.parseInt(strMonth);

      // book타입
      String type = "true";

      // 범위 검색하기위한 변수 생성
      String beforemonthdate = "";
      String aftermonthdate = "";

      // 달이 7이렇게 넘어오면 안되므로 07 이렇게 넘어와야 하므로 해준 조건식
      if (strMonth.length() == 2) {
         beforemonthdate = year + "-" + (month - 1);
      } else if (strMonth.length() == 1) {
         beforemonthdate = year + "-0" + (month - 1);
      }
      if (strMonth.length() == 2) {
         aftermonthdate = year + "-" + month;
      } else if (strMonth.length() == 1) {
         aftermonthdate = year + "-0" + month;
      }

      // 체육관 정보
      GymDTO gymdto = dao.getgymReadData(info.getSessionId());

      // 데이터 넘겨주기
      Map<String, Object> hMap = new HashMap<String, Object>();
      hMap.put("gymId", gymId);
      hMap.put("beforemonthdate", beforemonthdate);
      hMap.put("aftermonthdate", aftermonthdate);
      hMap.put("type", type);// 타입 값 검색하기위해

      // 예약 데이터 개수
      int bookdataCount = dao.bookgetDataCount(hMap);

      // 예약 리스트
      List<BookDTO> gymbooklists = dao.gymbookgetList(bookId);
      //화상링크 생성 (아이디+예약시간+트레이너)
       Iterator<BookDTO> iterator = gymbooklists.iterator();
       while(iterator.hasNext()) {
          String match = "[^\uAC00-\uD7A3xfe0-9a-zA-Z\\s]";
          BookDTO dto = iterator.next();
          String bookHour = dto.getBookHour().substring(0,13).replaceAll(match, "");
          String faceLink = dto.getCusId();
          faceLink += bookHour;
          faceLink += dto.getGymTrainerPick();
          dto.setFaceLink(faceLink);
       }
      // 리뷰리스트
      List<ReviewDTO> gymreviewlists = dao.gymreviewgetList(reviewId);

      ////////////////////////////////////////////////////////////////////////

      // 오늘 날짜 구하기
      // 이전버튼키(◀)
      int preYear = year;
      int preMonth = month - 1;
      if (preMonth < 1) {
         preYear = year - 1;
         preMonth = 12;
      }
      // 다음버튼키(▶)
      int nextYear = year;
      int nextMonth = month + 1;
      if (nextMonth > 12) {
         nextYear = year + 1;
         nextMonth = 1;
      }

      ////////////////////////////////////////////////////////////////////////

      request.setAttribute("gymbooklists", gymbooklists);
      request.setAttribute("gymreviewlists", gymreviewlists);
      request.setAttribute("gymdto", gymdto);
      request.setAttribute("bookdataCount", bookdataCount);
      request.setAttribute("year", year);
      request.setAttribute("month", month);
      request.setAttribute("preMonth", preMonth);
      request.setAttribute("nextMonth", nextMonth);
      request.setAttribute("preYear", preYear);
      request.setAttribute("nextYear", nextYear);
      
      return "myPage/gymMyPage";
   }

	// 유저 수정창으로 이동
	@RequestMapping(value = "/customerUpdate.action", method = { RequestMethod.GET, RequestMethod.POST })
	public String customerUpdate(HttpServletRequest request, HttpSession session) {

		CustomInfo info = (CustomInfo) session.getAttribute("customInfo");
		String mode = null;

		// 세션아이디로 고객정보 디비에서 dto가져옴
		CustomerDTO dto = dao.getCustromerDTOReadData(info);

		// 고객정보가 있으면 mode를 "updated"으로 넘겨준다
		if (dto != null) {
			mode = "updated";
		}

		request.setAttribute("mode", mode);
		request.setAttribute("dto", dto);
		return "create/createCustomer";
	}

	// 유저 정보 수정 후 업데이트
	@RequestMapping(value = "/customerUpdate_ok.action", method = { RequestMethod.GET, RequestMethod.POST })
	public String customerUpdate_ok(HttpServletRequest request, HttpSession session, CustomerDTO dto,
			HttpServletResponse response) throws IOException {

		dao.updateData(dto);
		request.setAttribute("dto", dto);

		return "redirect:/customerMyPage.action";
	}

	// 유저 탈퇴
	@RequestMapping(value = "/customerDeleted_ok.action", method = { RequestMethod.GET, RequestMethod.POST })
	public String customerDeleted_ok(HttpServletRequest request, CustomerDTO dto, HttpSession session,
			HttpServletResponse response) throws IOException {

		dao.deleteData(dto);

		// 삭제시 세션제거
		session.removeAttribute("customInfo"); // customInfo 안에 있는 데이터를 지운다
		session.invalidate(); // customInfo 라는 변수도 지운다.

		// 임시 회원탈퇴시 로그인창으로 넘어가기
		return "login/login";
	}
	
	// 체육관 수정창으로 이동 (채종완, 최보경)
	@RequestMapping(value = "/gymUpdate.action", method = { RequestMethod.GET, RequestMethod.POST })
	public String gymUpdate(HttpServletRequest request, HttpSession session) {
		
		// 세션에 올라온값
		CustomInfo info = (CustomInfo) session.getAttribute("customInfo");
		String mode=null; //초기화
		
		//세션아이디로 고객정보 디비에서 dto가져옴
		GymDTO dto = dao.getgymReadData(info.getSessionId());
		
		//고객정보가 있으면 mode를 "updated"으로 넘겨준다
		if(dto!=null) {
			mode = "updated";
		}
		
		System.out.println(info.getSessionId());
		
		
		//기존 트레이너 이름 뿌릴 준비
		if(dto.getGymTrainer()!=null && !dto.getGymTrainer().equals("")) {
			List<String> gymTrainerLists = Arrays.asList(dto.getGymTrainer().split(","));
			int startNumberForTrainer = gymTrainerLists.size()+1;//배열관련 숫자
			request.setAttribute("startNumberForTrainer", startNumberForTrainer);
			request.setAttribute("gymTrainerLists", gymTrainerLists);
		}
		
		//기존 트레이너 사진명 뿌릴 준비
		if( dto.getGymTrainerPic()!=null && !dto.getGymTrainerPic().equals("")) {
			List<String> gymTrainerPicLists = Arrays.asList(dto.getGymTrainerPic().split(","));
			request.setAttribute("gymTrainerPicLists", gymTrainerPicLists);
		}
		
		//기존 체육관 사진명 뿌릴 준비
		if(dto.getGymPic()!=null && !dto.getGymPic().equals("")) {
			List<String> gymPicLists = Arrays.asList(dto.getGymPic().split(","));
			int startNumberForGymPic = gymPicLists.size()+1;
			request.setAttribute("startNumberForGymPic", startNumberForGymPic);
			request.setAttribute("gymPicLists", gymPicLists);
		}
		
		//기존 체육관 시간 뿌릴 준비
		List<String> gymHourListsString = Arrays.asList(dto.getGymHour().split(","));
		List<Integer> gymHourListsInt = new ArrayList<Integer>();
		List<Integer> beforeAfter = new ArrayList<Integer>();
		
		//시간을 숫자로 바꾸기
		for(String one : gymHourListsString) {

			//시간 부분만 추출
			//예 : (01:00 ~ 02:00)에서 1과 2를 추출
			int startHour = Integer.parseInt(one.substring(0, 2));
			int endHour = Integer.parseInt(one.substring(8, 10));
			
			gymHourListsInt.add(startHour);
			gymHourListsInt.add(endHour);
		}
		
		//시간 앞뒤 숫자 생성
		for(int i=0; i<6; i++) {
			int temp = gymHourListsInt.get(i);
			int before = temp-1;
			int after = temp+1;
			
			//마지막 숫자들 처리
			if(before<0)
				before = 0;
			if(after>24)
				after = 24;
			
			//리스트에 추가
			beforeAfter.add(before);
			beforeAfter.add(after);
		}

		//리스트
		request.setAttribute("gymHourListsInt", gymHourListsInt);
		request.setAttribute("beforeAfter", beforeAfter);
		//기타
		request.setAttribute("mode", mode);
		request.setAttribute("dto", dto);
		return "create/createGym";
	}

	// 체육관 정보 수정 후 업데이트(채종완, 최보경)
	//※이름만 입력하고 사진을 입력하지 않은 경우는 등록되지 않는다※
	@RequestMapping(value = "/gymUpdate_ok.action", method = { RequestMethod.GET, RequestMethod.POST })
	public String gymUpdate_ok(HttpServletRequest request, HttpSession session, GymDTO gymdto,  MultipartHttpServletRequest multiReq) {
		
		//세션아이디로 체육관 정보 디비에서 dto가져옴
		CustomInfo info = (CustomInfo) session.getAttribute("customInfo");
		GymDTO dto = dao.getgymReadData(info.getSessionId());
		
		//trainerName : 수정한 트레이너 이름 
		//oldTrainerName : 기존 트레이너 이름
		//olyGymImage : 기존 체육관 사진의 """이름만!!!"""
		String trainerName1 = request.getParameter("trainerName1");
		String trainerName2 = request.getParameter("trainerName2");
		String trainerName3 = request.getParameter("trainerName3");
		String trainerName4 = request.getParameter("trainerName4");
		String oldTrainerImage1 = request.getParameter("oldTrainerImage1");
		String oldTrainerImage2 = request.getParameter("oldTrainerImage2");
		String oldTrainerImage3 = request.getParameter("oldTrainerImage3");
		String oldTrainerImage4 = request.getParameter("oldTrainerImage4");
		String oldGymImage1 = request.getParameter("oldGymImage1");
		String oldGymImage2 = request.getParameter("oldGymImage2");
		String oldGymImage3 = request.getParameter("oldGymImage3");
		String oldGymImage4 = request.getParameter("oldGymImage4");
		
		//html의 이미지 가져와서 객체 생성
		//newTrainerImage : 수정한 트레이너 사진
		//newGymImage: 수정한 체육관 사진
		MultipartFile newTrainerImage1 = multiReq.getFile("newTrainerImage1");
		MultipartFile newTrainerImage2 = multiReq.getFile("newTrainerImage2");
		MultipartFile newTrainerImage3 = multiReq.getFile("newTrainerImage3");
		MultipartFile newTrainerImage4 = multiReq.getFile("newTrainerImage4");
		MultipartFile newGymImage1 = multiReq.getFile("newGymImage1");
		MultipartFile newGymImage2 = multiReq.getFile("newGymImage2");
		MultipartFile newGymImage3 = multiReq.getFile("newGymImage3");
		MultipartFile newGymImage4 = multiReq.getFile("newGymImage4");
		
		//이미지 path (Controller최상단 PATH)
		String gymTrainerPicImgPath = PATH + "gymTrainerPic\\";
		String gymPicImgPath = PATH + "gymPic\\";
		
		//합쳐질 이름들
		String gymTrainerNameCombine = "";
		String gymTrainerPicCombine = "";
		String gymPicCombine ="";
		
		//이미지가 로컬에 저장될 이름들
		String newTrainerImage1LocalName = "";
		String newTrainerImage2LocalName = "";
		String newTrainerImage3LocalName = "";
		String newTrainerImage4LocalName = "";
		String newGymImage1LoclaName = "";
		String newGymImage2LoclaName = "";
		String newGymImage3LoclaName = "";
		String newGymImage4LoclaName = "";
		
		try {
			//트레이너 이미지 및 이름 함께처리함 (순서가 같아야 하므로 함께 처리한다)
			
			//----------트레이너1------------
			//트레이너 이미지 수정을 안하고, 이름만 수정한경우
			if((newTrainerImage1==null||newTrainerImage1.getOriginalFilename().equals("")) 
					&& oldTrainerImage1!=null) {
				gymTrainerNameCombine += trainerName1 + ",";
				gymTrainerPicCombine += oldTrainerImage1 + ",";
			}
			
			//트레이너 이미지 수정을 한 경우
			if(newTrainerImage1!=null && newTrainerImage1.getSize()>0) {
				
				//로컬저장용 이름 생성
				newTrainerImage1LocalName = gymdto.getGymId() + "-" + newTrainerImage1.getOriginalFilename();
					
				//디비에 들어가기 위해 이름을 하나로 합침
				gymTrainerNameCombine += trainerName1 + ",";
				gymTrainerPicCombine += newTrainerImage1LocalName+ ",";
				
				//fs 생성 및 저장
				FileOutputStream fs = new FileOutputStream(gymTrainerPicImgPath + newTrainerImage1LocalName); 
				fs.write(newTrainerImage1.getBytes());
				fs.close();
				
				//기존 파일이 있다면 지우기
				if(oldTrainerImage1!=null) {
					File deleteImage = new File(gymTrainerPicImgPath + oldTrainerImage1);
					deleteImage.delete();
				}
			}
			
			//----------트레이너2------------
			//트레이너 이미지 수정을 안하고, 이름만 수정한경우
			if((newTrainerImage2==null||newTrainerImage2.getOriginalFilename().equals("")) 
					&& oldTrainerImage2!=null ) {
				gymTrainerNameCombine += trainerName2 + ",";
				gymTrainerPicCombine += oldTrainerImage2 + ",";
			}
			
			//트레이너 이미지 수정을 한 경우
			if(newTrainerImage2!=null && newTrainerImage2.getSize()>0) {
				
				//로컬저장용 이름 생성
				newTrainerImage2LocalName = gymdto.getGymId() + "-" + newTrainerImage2.getOriginalFilename();
					
				//디비에 들어가기 위해 이름을 하나로 합침
				gymTrainerNameCombine += trainerName2 + ",";
				gymTrainerPicCombine += newTrainerImage2LocalName+ ",";
				
				//fs 생성 및 저장
				FileOutputStream fs = new FileOutputStream(gymTrainerPicImgPath + newTrainerImage2LocalName); 
				fs.write(newTrainerImage2.getBytes());
				fs.close();
				
				//기존 파일이 있다면 지우기
				if(oldTrainerImage2!=null) {
					File deleteImage = new File(gymTrainerPicImgPath + oldTrainerImage2);
					deleteImage.delete();
				}
			}
			
			//----------트레이너3------------
			//트레이너 이미지 수정을 안하고, 이름만 수정한경우
			if((newTrainerImage3==null||newTrainerImage3.getOriginalFilename().equals("")) 
					&& oldTrainerImage3!=null) {
				gymTrainerNameCombine += trainerName3 + ",";
				gymTrainerPicCombine += oldTrainerImage3 + ",";
			}
			
			//트레이너 이미지 수정을 한 경우
			if(newTrainerImage3!=null && newTrainerImage3.getSize()>0) {
				
				//로컬저장용 이름 생성
				newTrainerImage3LocalName = gymdto.getGymId() + "-" + newTrainerImage3.getOriginalFilename();
					
				//디비에 들어가기 위해 이름을 하나로 합침
				gymTrainerNameCombine += trainerName3 + ",";
				gymTrainerPicCombine += newTrainerImage3LocalName+ ",";
				
				//fs 생성 및 저장
				FileOutputStream fs = new FileOutputStream(gymTrainerPicImgPath + newTrainerImage3LocalName); 
				fs.write(newTrainerImage3.getBytes());
				fs.close();
				
				//기존 파일이 있다면 지우기
				if(oldTrainerImage3!=null) {
					File deleteImage = new File(gymTrainerPicImgPath + oldTrainerImage3);
					deleteImage.delete();
				}
			}
			
			//----------트레이너4------------
			//트레이너 이미지 수정을 안하고, 이름만 수정한경우
			if((newTrainerImage4==null||newTrainerImage4.getOriginalFilename().equals("")) 
					&& oldTrainerImage4!=null) {
				gymTrainerNameCombine += trainerName4 + ",";
				gymTrainerPicCombine += oldTrainerImage4 + ",";
			}
			
			//트레이너 이미지 수정을 한 경우
			if(newTrainerImage4!=null && newTrainerImage4.getSize()>0) {
				
				//로컬저장용 이름 생성
				newTrainerImage4LocalName = gymdto.getGymId() + "-" + newTrainerImage4.getOriginalFilename();
					
				//디비에 들어가기 위해 이름을 하나로 합침
				gymTrainerNameCombine += trainerName4 + ",";
				gymTrainerPicCombine += newTrainerImage4LocalName+ ",";
				
				//fs 생성 및 저장
				FileOutputStream fs = new FileOutputStream(gymTrainerPicImgPath + newTrainerImage4LocalName); 
				fs.write(newTrainerImage4.getBytes());
				fs.close();
				
				//기존 파일이 있다면 지우기
				if(oldTrainerImage4!=null) {
					File deleteImage = new File(gymTrainerPicImgPath + oldTrainerImage4);
					deleteImage.delete();
				}
			}
			
			//----------체육관 사진1------------
			//새로 체육관 사진을 올리지 않은 경우, 기존의 사진이름 그대로 디비에 삽입해야함
			if(newGymImage1.getSize()==0 && oldGymImage1!=null) {
				gymPicCombine += oldGymImage1 + ",";
			}
			
			//체육관 사진을 수정을 한 경우
			if(newGymImage1!=null && newGymImage1.getSize()>0) {
				
				//로컬저장용 이름 생성
				newGymImage1LoclaName = gymdto.getGymId() + "-" + newGymImage1.getOriginalFilename();
					
				//디비에 들어가기 위해 이름을 하나로 합침
				gymPicCombine += newGymImage1LoclaName+ ",";
				
				//fs 생성 및 저장
				FileOutputStream fs = new FileOutputStream(gymPicImgPath + newGymImage1LoclaName); 
				fs.write(newGymImage1.getBytes());
				fs.close();
				
				//기존 파일이 있다면 지우기
				if(oldGymImage1!=null) {
					File deleteImage = new File(gymPicImgPath + oldGymImage1);
					deleteImage.delete();
				}
			}
			
			//----------체육관 사진2------------
			//새로 체육관 사진을 올리지 않은 경우, 기존의 사진이름 그대로 디비에 삽입해야함
			if(newGymImage2.getSize()==0  && oldGymImage2!=null) {
				gymPicCombine += oldGymImage2 + ",";
			}
			
			//체육관 사진을 수정을 한 경우
			if(newGymImage2!=null && newGymImage2.getSize()>0) {
				
				//로컬저장용 이름 생성
				newGymImage2LoclaName = gymdto.getGymId() + "-" + newGymImage2.getOriginalFilename();
					
				//디비에 들어가기 위해 이름을 하나로 합침
				gymPicCombine += newGymImage2LoclaName+ ",";
				
				//fs 생성 및 저장
				FileOutputStream fs = new FileOutputStream(gymPicImgPath + newGymImage2LoclaName); 
				fs.write(newGymImage2.getBytes());
				fs.close();
				
				//기존 파일이 있다면 지우기
				if(oldGymImage2!=null) {
					File deleteImage = new File(gymPicImgPath + oldGymImage2);
					deleteImage.delete();
				}
			}
			
			//----------체육관 사진3------------
			//새로 체육관 사진을 올리지 않은 경우, 기존의 사진이름 그대로 디비에 삽입해야함
			if(newGymImage3.getSize()==0  && oldGymImage3!=null) {
				gymPicCombine += oldGymImage3 + ",";
			}
			
			//체육관 사진을 수정을 한 경우
			if(newGymImage3!=null && newGymImage3.getSize()>0) {
				
				//로컬저장용 이름 생성
				newGymImage3LoclaName = gymdto.getGymId() + "-" + newGymImage3.getOriginalFilename();
					
				//디비에 들어가기 위해 이름을 하나로 합침
				gymPicCombine += newGymImage3LoclaName+ ",";
				
				//fs 생성 및 저장
				FileOutputStream fs = new FileOutputStream(gymPicImgPath + newGymImage3LoclaName); 
				fs.write(newGymImage3.getBytes());
				fs.close();
				
				//기존 파일이 있다면 지우기
				if(oldGymImage3!=null) {
					File deleteImage = new File(gymPicImgPath + oldGymImage3);
					deleteImage.delete();
				}
			}
			
			
			//----------체육관 사진4------------
			//새로 체육관 사진을 올리지 않은 경우, 기존의 사진이름 그대로 디비에 삽입해야함
			if(newGymImage4.getSize()==0  && oldGymImage4!=null) {
				gymPicCombine += oldGymImage4 + ",";
			}
			
			//체육관 사진을 수정을 한 경우
			if(newGymImage4!=null && newGymImage4.getSize()>0) {
				
				//로컬저장용 이름 생성
				newGymImage4LoclaName = gymdto.getGymId() + "-" + newGymImage4.getOriginalFilename();
					
				//디비에 들어가기 위해 이름을 하나로 합침
				gymPicCombine += newGymImage4LoclaName+ ",";
				
				//fs 생성 및 저장
				FileOutputStream fs = new FileOutputStream(gymPicImgPath + newGymImage4LoclaName); 
				fs.write(newGymImage4.getBytes());
				fs.close();
				
				//기존 파일이 있다면 지우기
				if(oldGymImage4!=null) {
					File deleteImage = new File(gymPicImgPath + oldGymImage4);
					deleteImage.delete();
				}
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		
		//----------쉼표처리 (트레이너 이름)-----------
		if(gymTrainerNameCombine!=null && !gymTrainerNameCombine.equals("")) {
			
			//마지막글자에 쉼표 빼기
			String lastWord = gymTrainerNameCombine.substring(gymTrainerNameCombine.length()-1, gymTrainerNameCombine.length());
			
			//마지막 쉼표면, 쉼표 빼고 dto에 setting
			while(lastWord.equals(",")) { 
				//마지막 쉼표 빼기
				gymTrainerNameCombine = gymTrainerNameCombine.substring(0,gymTrainerNameCombine.length()-1); 
				//마지막 글자 다시 세팅(반복문)
				lastWord = gymTrainerNameCombine.substring(gymTrainerNameCombine.length()-1, gymTrainerNameCombine.length());
			}
		}
		 
		//----------쉼표처리 (트레이너 사진 이름)-----------
		if(gymTrainerPicCombine!=null && !gymTrainerPicCombine.equals("")) {
			//마지막글자에 쉼표 빼기
			String lastWord = gymTrainerPicCombine.substring(gymTrainerPicCombine.length()-1, gymTrainerPicCombine.length());
			
			//마지막 쉼표면, 쉼표 빼고 dto에 setting
			while(lastWord.equals(",")) { 
				//마지막 쉼표 빼기
				gymTrainerPicCombine = gymTrainerPicCombine.substring(0,gymTrainerPicCombine.length()-1); 
				//마지막 글자 다시 세팅(반복문)
				lastWord = gymTrainerPicCombine.substring(gymTrainerPicCombine.length()-1, gymTrainerPicCombine.length());
			}
		}
		//----------쉼표처리 (체육관 사진 이름)-----------
		if(gymPicCombine!=null && !gymPicCombine.equals("")) {
			//마지막글자에 쉼표 빼기
			String lastWord = gymPicCombine.substring(gymPicCombine.length()-1, gymPicCombine.length());
			
			//마지막 쉼표면, 쉼표 빼고 dto에 setting
			while(lastWord.equals(",")) { 
				//마지막 쉼표 빼기
				gymPicCombine = gymPicCombine.substring(0,gymPicCombine.length()-1); 
				//마지막 글자 다시 세팅(반복문)
				lastWord = gymPicCombine.substring(gymPicCombine.length()-1, gymPicCombine.length());
			}
		}

		
		/*디버깅 시작*/
		/*if(trainerName1!=null && newTrainerImage1.getSize()>0) {
			System.out.println("trainerName1 " + trainerName1);
			System.out.println("oldTrainerImage1 " + oldTrainerImage1);
			System.out.println(newTrainerImage1.getOriginalFilename());
			System.out.println("----");
		}
		if(trainerName2!=null && newTrainerImage2.getSize()>0) {
			System.out.println("trainerName2 " +trainerName2);
			System.out.println("oldTrainerImage2 " +oldTrainerImage2);
			System.out.println(newTrainerImage2.getOriginalFilename());
			System.out.println("----");
		}
		if(trainerName3!=null && newTrainerImage3.getSize()>0) {
			System.out.println("trainerName3 " +trainerName3);
			System.out.println("oldTrainerImage3 " +oldTrainerImage3);
			System.out.println(newTrainerImage3.getOriginalFilename());
			System.out.println("----");
		}
		if(trainerName4!=null && newTrainerImage4.getSize()>0) {
			System.out.println("trainerName4 " +trainerName4);
			System.out.println("oldTrainerImage4 " +oldTrainerImage4);
			System.out.println(newTrainerImage4.getOriginalFilename());
			System.out.println("----");
		}
		if(newGymImage1!=null  && newGymImage1.getSize()>0) {
			System.out.println("oldGymImage1 " + oldGymImage1);
			System.out.println(newGymImage1.getOriginalFilename());
			System.out.println("----");
		}
		if(newGymImage2!=null  && newGymImage2.getSize()>0) {
			System.out.println("oldGymImage2 " + oldGymImage2);
			System.out.println(newGymImage2.getOriginalFilename());
			System.out.println("----");
		}
		if(newGymImage3!=null  && newGymImage3.getSize()>0) {
			System.out.println("oldGymImage3 " + oldGymImage3);
			System.out.println(newGymImage3.getOriginalFilename());
			System.out.println("----");
		}
		if(newGymImage4!=null  && newGymImage4.getSize()>0) {
			System.out.println("oldGymImage4 " + oldGymImage4);
			System.out.println(newGymImage4.getOriginalFilename());
			System.out.println("----");
		}
		System.out.println("경로1 :" + gymTrainerPicImgPath);
		System.out.println("경로2 :" + gymPicImgPath);
		System.out.println("gymTrainerNameCombine " + gymTrainerNameCombine);
		System.out.println("gymTrainerPicCombine " + gymTrainerPicCombine);
		System.out.println("gymPicCombine " + gymPicCombine);*/
		/*디버깅 끝*/
		
		
		
		//======체육관 시간 등록===========
		
		//GymHour 매장오픈시간 닫는시간 선택하는거 다 합쳐서 한 컬럼에 집어넣기
		String gymHour1_1 = request.getParameter("gymHour1_1");
		String gymHour1_2 = request.getParameter("gymHour1_2");
		
		String gymHour2_1 = request.getParameter("gymHour2_1");
		String gymHour2_2 = request.getParameter("gymHour2_2");
		
		String gymHour3_1 = request.getParameter("gymHour3_1");
		String gymHour3_2 = request.getParameter("gymHour3_2");
		
		String gymHour1 = gymHour1_1 + " ~ " + gymHour1_2;
		String gymHour2 = gymHour2_1 + " ~ " + gymHour2_2;
		String gymHour3 = gymHour3_1 + " ~ " + gymHour3_2;
		
		String gymHour = "";
		gymHour += gymHour1 + ",";
		gymHour += gymHour2 + ",";
		gymHour += gymHour3 ;
		
		
		//디비에 들어갈 데이터 dto에 세팅
		gymdto.setGymTrainer(gymTrainerNameCombine);
		gymdto.setGymTrainerPic(gymTrainerPicCombine);
		gymdto.setGymPic(gymPicCombine);
		gymdto.setGymHour(gymHour);
		
		
		dao.gymupdateData(gymdto);//수정 완료
		request.setAttribute("gymdto", gymdto);
		return "redirect:/gymMyPage.action";
	}

	//체육관 정보 수정창에서 이미지 삭제 (최보경)
	@RequestMapping(value = "/gymImageDelete.action", method = {RequestMethod.GET})
	public String gymUpdate_deleteImage(HttpServletRequest request, HttpSession session) {
		
		//세션아이디로 체육관 정보 디비에서 dto가져옴
		CustomInfo info = (CustomInfo) session.getAttribute("customInfo");
		GymDTO dto = dao.getgymReadData(info.getSessionId());
		
		//지울 대상 넘어옴!!!!
		String whatToDelete = request.getParameter("whatToDelete");
		
		//이미지 path (Controller최상단 PATH)
		String gymTrainerPicImgPath = PATH + "gymTrainerPic\\";
		String gymPicImgPath = PATH + "gymPic\\";
		
		//합쳐질 이름들
		String gymTrainerNameCombine = "";
		String gymTrainerPicCombine = "";
		String gymPicCombine ="";

		//몇번째 트레이너인가
		String lastNumber = whatToDelete.substring(whatToDelete.length()-1, whatToDelete.length());
		int TrainerNumber = Integer.parseInt(lastNumber);
		
		
		//=======================================
		//트레이너 이름과 사진을 지울때
		//=======================================
		if(whatToDelete.contains("Trainer")) {
			
			//트레이너 이름 삭제 ----------------------------------------------------
			//기존 트레이너 이름을 배열로 만들기
			String[] gymTrainerNameLists = dto.getGymTrainer().split(",");
			
			//다시 이름들 합치기
			for(int i=0; i<gymTrainerNameLists.length; i++) {
				
				//삭제할 인덱스번호는 빼고 쉼표로 합치기
				if(i != TrainerNumber-1) {  
				gymTrainerNameCombine += gymTrainerNameLists[i] + ",";
				}
			}
			//마지막 쉼표 처리
			//마지막 쉼표면, 쉼표 빼고 dto에 setting

			//oldTrainerImage1 하나만 기존에 있었는데, 다 지울 경우에 예외처리
			if(!whatToDelete.equals("oldTrainerImage1") && gymTrainerNameLists.length==1 ) {
				
				String lastWord = gymTrainerNameCombine.substring(gymTrainerNameCombine.length()-1, gymTrainerNameCombine.length());
				
				while(lastWord.equals(",")) {
					gymTrainerNameCombine = gymTrainerNameCombine.substring(0, gymTrainerNameCombine.length()-1);
					lastWord = gymTrainerNameCombine.substring(gymTrainerNameCombine.length()-1, gymTrainerNameCombine.length());//마지막 글자 다시 세팅
				}
			}
			//dto에 세팅
			dto.setGymTrainer(gymTrainerNameCombine);
			
			
			
			//트레이너 이미지 (파일+DB) 삭제 ----------------------------------------------------
			//기존 트레이너 이미지을 배열로 만들기
			String[] gymTrainerImageLists = dto.getGymTrainerPic().split(",");
			
			//다시 이름들 합치기
			for(int i=0; i<gymTrainerImageLists.length; i++) {
				
				//해당 번호면 기존 파일지우기
				if(i == TrainerNumber-1) {
				File deleteImage = new File(gymTrainerPicImgPath + gymTrainerImageLists[i]);
				deleteImage.delete();
				}
				
				//삭제할 인덱스번호는 빼고 쉼표로 합치기
				if(i != TrainerNumber-1) {  
				gymTrainerPicCombine += gymTrainerImageLists[i] + ",";
				}
			}
			//마지막 쉼표 처리
			//마지막 쉼표면, 쉼표 빼고 dto에 setting
			
			//oldTrainerImage1 하나만 기존에 있었는데, 다 지울 경우에 예외처리
			if(!whatToDelete.equals("oldTrainerImage1") && gymTrainerNameLists.length!=1 ) {
				String lastWord = gymTrainerPicCombine.substring(gymTrainerPicCombine.length()-1, gymTrainerPicCombine.length());
				
				while(lastWord.equals(",")) {
					gymTrainerPicCombine = gymTrainerPicCombine.substring(0, gymTrainerPicCombine.length()-1);
					lastWord = gymTrainerPicCombine.substring(gymTrainerPicCombine.length()-1, gymTrainerPicCombine.length());//마지막 글자 다시 세팅
				}
			}
			//dto에 세팅
			dto.setGymTrainerPic(gymTrainerPicCombine);
			
			
		//=======================================			
		//체육관 사진을 지울때
		//=======================================
		}else if (whatToDelete.contains("Gym")) {
			
			//기존 트레이너 이미지을 배열로 만들기
			String[] gymImageLists = dto.getGymPic().split(",");
			
			//다시 이름들 합치기
			for(int i=0; i<gymImageLists.length; i++) {
				
				//해당 번호면 기존 파일지우기
				if(i == TrainerNumber-1) {
				File deleteImage = new File(gymPicImgPath + gymImageLists[i]);
				deleteImage.delete();
				}
				
				//삭제할 인덱스번호는 빼고 쉼표로 합치기
				if(i != TrainerNumber-1) {  
				gymPicCombine += gymImageLists[i] + ",";
				}
			}
			//마지막 쉼표 처리
			//마지막 쉼표면, 쉼표 빼고 dto에 setting

			//oldGymImage1 하나만 기존에 있었는데, 다 지울 경우에 예외처리
			if(!whatToDelete.equals("oldTrainerImage1") && gymImageLists.length!=1 ) {
				
				String lastWord = gymPicCombine.substring(gymPicCombine.length()-1, gymPicCombine.length());
				
				while(lastWord.equals(",")) {
					gymPicCombine = gymPicCombine.substring(0, gymPicCombine.length()-1);
					lastWord = gymPicCombine.substring(gymPicCombine.length()-1, gymPicCombine.length());//마지막 글자 다시 세팅
				}
			}
			
			//dto에 세팅
			dto.setGymPic(gymPicCombine);
		}
		
		dao.gymupdateData(dto);//수정 완료
		
		//다시 수정창으로
		//수정창에서 dto는 세션에서 받아오므로 넘겨줄 필요 없다
		return "redirect:/gymUpdate.action";
	}
	
	// 체육관 회원 탈퇴
	@RequestMapping(value = "/gymDeleted_ok.action", method = { RequestMethod.GET, RequestMethod.POST })
	public String gymDeleted_ok(HttpServletRequest request, GymDTO dto, HttpSession session) {
		dao.gymdeleteData(dto);
		// 삭제시 세션제거
		session.removeAttribute("customInfo"); // customInfo 안에 있는 데이터를 지운다
		session.invalidate(); // customInfo 라는 변수도 지운다.
		// 임시 회원탈퇴시 로그인창으로 넘어가기
		return "login/login";
	}

	// 리뷰 삭제
	@RequestMapping(value = "/reviewDelete.action", method = { RequestMethod.GET, RequestMethod.POST })
	public String reviewDelete(HttpServletRequest request, HttpSession session) {
		int reNum = Integer.parseInt(request.getParameter("reNum"));
		dao.reviewdeleteData(reNum);
		return "redirect:/customerMyPage.action";
	}

	// 찜 삭제
	@RequestMapping(value = "/jjimDelete.action", method = { RequestMethod.GET, RequestMethod.POST })
	public String jjimDelete(HttpServletRequest request, HttpSession session) {
		String gymId = request.getParameter("gymId");
		dao.jjimdeleteData(gymId);
		return "redirect:/customerMyPage.action";
	}

	// 예약 삭제
	@RequestMapping(value = "/bookDelete.action", method = { RequestMethod.GET, RequestMethod.POST })
	public String bookDelete(HttpServletRequest request, HttpSession session) {
		//예약 삭제
		int bookNum = Integer.parseInt(request.getParameter("bookNum"));
		dao.bookdeleteData(bookNum);
		
		//환불
		HashMap<String, Object> hashMap = new HashMap<String, Object>();
		String cusId = request.getParameter("cusId");
		String gymPass = request.getParameter("gymPass");
		hashMap.put("cusId", cusId);
		hashMap.put("gymPass", gymPass);
		dao.passRefund(hashMap);
		
		return "redirect:/gymMyPage.action";
	}
	
	////////////////
	// 상품 리스트
	@RequestMapping(value = "/productList.action", method = { RequestMethod.GET, RequestMethod.POST })
	public String productList(HttpServletRequest request) throws Exception {
	
	String type = "0";
	
	// 리스트 생성
	List<ProductDTO> lists = null;
	
	// 절대 경로 생성
	String cp = request.getContextPath();
	
	// 맵 객체 추가
	Map<String, Object> hMap = new HashMap<String, Object>();
	
	// 넘어오는값
	String pageNum = request.getParameter("pageNum");
	String searchValueCategory = request.getParameter("searchValueCategory"); // 카테고리
	String searchValueWord = request.getParameter("searchValueWord"); // 키보드 타이핑한 글자
	if(request.getParameter("type")!=null) {
		type = request.getParameter("type");// 정렬타입   
	}
	
	// 카테고리 검색 널 처리 + 인코딩 처리
	if (searchValueCategory == null) {
		searchValueCategory = ""; // 키워드 헬스 요가 필라테스
	} else if (searchValueCategory.equals("all")) {
		searchValueCategory = "";
	}
	
	// 타이핑 검색 널 처리 + 인코딩 처리
	if (searchValueWord == null) {
		searchValueWord = "";
	} else if (request.getMethod().equalsIgnoreCase("GET")) {
		searchValueWord = URLDecoder.decode(searchValueWord, "UTF-8");
	}
	
	
	// 페이징
	int currentPage = 1;
	
	if (pageNum != null) {
		currentPage = Integer.parseInt(pageNum);
	} else {
		pageNum = "1"; // 처음 페이지값
	}
	
	// 검색한 경우를 위한 페이징용 hMap
	hMap.put("searchValueCategory", searchValueCategory);
	hMap.put("searchValueWord", searchValueWord);
	
	int dataCount = dao.getProductCount(hMap);
	int numPerPage = 12;// 페이지에 보여주는 게시물수
	int totalPage = myUtil.getPageCount(numPerPage, dataCount);
	
	if (currentPage > totalPage) {
		currentPage = totalPage;
	}
	
	// 한 페이지의 첫과 끝 게시물 번호
	int start = (currentPage - 1) * numPerPage + 1;
	int end = currentPage * numPerPage;
	hMap.put("start", start);
	hMap.put("end", end);
	
	String param="";
	// 파람 생성
	if (!searchValueCategory.equals("")) {
		param = "searchValueCategory=" + searchValueCategory;
		param += "&searchValueWord=" + URLEncoder.encode(searchValueWord, "UTF-8");
		param += "&type=" + type;
	}
	
	// 전달할 url과 path
	String articleUrl = cp + "/productDetail.action?pageNum=" + currentPage;
	if (!param.equals(""))
		articleUrl = articleUrl + "&" + param;
	String searchUrl = "productList.action?" + param;
	String pageIndexList = myUtil.pageIndexList(currentPage, totalPage, searchUrl);
	String imagePath = "/gyp/sfiles/product"; // 이미지 경로
	
	// 정렬 타입에 따라 리스트가 달라진다
	// 1.높은가격순 2.낮은가격순 3.조회수 0.그냥 검색
	if (type.equals("1")) {
		lists = dao.searchListpayup(hMap);
	} else if (type.equals("2")) {
		lists = dao.searchListpaydown(hMap);
	} else if (type.equals("3")) {
		lists = dao.searchListhit(hMap);
	} else if (type.equals("0")) {
		lists = dao.searchList(hMap);
	}
	request.setAttribute("lists", lists);
	request.setAttribute("searchValueCategory", searchValueCategory);
	request.setAttribute("searchValueWord", searchValueWord);
	request.setAttribute("pageNum", pageNum);
	request.setAttribute("dataCount", dataCount);
	request.setAttribute("totalPage", totalPage);
	request.setAttribute("currentPage", currentPage);
	request.setAttribute("pageIndexList", pageIndexList);
	request.setAttribute("imagePath", imagePath);
	request.setAttribute("articleUrl", articleUrl);
	
	return "product/productList";
	
	}

	// 제품상세 페이지
	@RequestMapping(value = "/productDetail.action", method = { RequestMethod.GET, RequestMethod.POST })
	public String productDetail(HttpServletRequest request) throws Exception {
		
		String cp = request.getContextPath();

		// 넘어오는값
		String productId = request.getParameter("productId");
		String pageNum = request.getParameter("pageNum");
		String searchValueCategory = request.getParameter("searchValueCategory"); // 카테고리
		String searchValueWord = request.getParameter("searchValueWord"); // 키보드 타이핑한 글자

		// 카테고리 검색 널 처리 + 인코딩 처리
		if (searchValueCategory == null) {
			searchValueCategory = ""; // 키워드 헬스 요가 필라테스
		} else if (request.getMethod().equalsIgnoreCase("GET")) {
			searchValueCategory = URLDecoder.decode(searchValueCategory, "UTF-8");
		}

		// 타이핑 검색 널 처리 + 인코딩 처리
		if (searchValueWord == null) {
			searchValueWord = "";
		} else if (request.getMethod().equalsIgnoreCase("GET")) {
			searchValueWord = URLDecoder.decode(searchValueWord, "UTF-8");
		}
		
		// 페이지 번호가 안넘어올때 (홈에서 상세 들어갈때)
	    if(pageNum==null) {
	    	pageNum="1";
	    }
		
		// product 데이터 불러오기
		ProductDTO dto = dao.getProductReadData(productId);

		// 조회수 증가
		dao.updateHitCount(productId);

		String param = "pageNum=" + pageNum;
		if (searchValueCategory != null) {
			param += "&searchValueCategory=" + searchValueCategory;
			param += "&searchValueWord=" + URLEncoder.encode(searchValueWord, "UTF-8");
		}

		String imagePath = "/gyp/sfiles/product"; // 이미지 경로

		request.setAttribute("dto", dto);
		request.setAttribute("params", param);
		request.setAttribute("searchValueCategory", searchValueCategory);
		request.setAttribute("searchValueWord", searchValueWord);
		request.setAttribute("pageNum", pageNum);
		request.setAttribute("imagePath", imagePath);

		return "product/productDetail";
	}

	// 장바구니 추가
	@RequestMapping(value = "/productDetail_ok.action", method = { RequestMethod.GET, RequestMethod.POST })
	public String productDetail_ok(HttpServletRequest request, HttpSession session, CartDTO cartdto) throws Exception {

		// 장바구니 클릭시 로그인하게 만듦 (jsp에서)
		CustomInfo info = (CustomInfo) session.getAttribute("customInfo"); // 세션에 로그인값 가져올려고 생성
		
		if(info==null) {//돌발적 로그아웃 대비
			return "redirect:/login.action";
		}
		
		// 넘어오는값
		String productId = request.getParameter("productId");
		String pageNum = request.getParameter("pageNum");
		String searchValueCategory = request.getParameter("searchValueCategory"); // 카테고리
		String searchValueWord = request.getParameter("searchValueWord"); // 키보드 타이핑한 글자
		int count = Integer.parseInt(request.getParameter("count")); // 물건 갯수

		// 카테고리 검색 널 처리 + 인코딩 처리
		if (searchValueCategory == null) {
			searchValueCategory = ""; // 키워드 헬스 요가 필라테스
		} else if (request.getMethod().equalsIgnoreCase("GET")) {
			searchValueCategory = URLDecoder.decode(searchValueCategory, "UTF-8");
		}

		// 타이핑 검색 널 처리 + 인코딩 처리
		if (searchValueWord == null) {
			searchValueWord = "";
		} else if (request.getMethod().equalsIgnoreCase("GET")) {
			searchValueWord = URLDecoder.decode(searchValueWord, "UTF-8");
		}

		// cartMaxNum
		int maxNum = dao.getCartNumMax();

		cartdto.setCartNum(maxNum + 1);
		cartdto.setCusId(info.getSessionId()); // 세션에 있는 id
		cartdto.setProductId(productId);
		cartdto.setCount(count);

		// 삽입전, 같은 아이디에 같은 물품을 이미 넣었는지 확인하기
		int result = dao.cartCheckSame(cartdto);

		if (result == 0) {// 같은 사람이 같은 물품을 안담았다면!
			dao.cartInsertData(cartdto);// 삽입
		} else {
			dao.cartCountChange(cartdto);// 수량만 변경
		}

		return "redirect:/productDetail.action?productId=" + productId + "&pageNum=" + pageNum;
	}

	// 장바구니
	// cartdto 에 productName,productPrice 추가
	@RequestMapping(value = "/cart.action", method = { RequestMethod.GET, RequestMethod.POST })
	public String cart(HttpServletRequest request, HttpSession session) throws Exception {

		String cp = request.getContextPath();

		CustomInfo info = (CustomInfo) session.getAttribute("customInfo");
		
		if(info==null) {//돌발적 로그아웃 대비
			return "redirect:/login.action";
		}
		
		String cusId = info.getSessionId();

		List<CartDTO> cartLists = dao.cartList(cusId);

		int totPrice = 0; // 총합 변수

		for (CartDTO dto : cartLists) {
			totPrice += dto.getProductPrice();
		}

		String imagePath = "/gyp/sfiles/product"; // 이미지 경로

		request.setAttribute("imagePath", imagePath);
		request.setAttribute("cartLists", cartLists);
		request.setAttribute("totPrice", totPrice);

		return "product/cart";

	}

	// 장바구니 체크박스 삭제
	@RequestMapping(value = "/cart_delete.action", method = { RequestMethod.GET, RequestMethod.POST })
	public String cart_delete(HttpServletRequest request, HttpSession session) throws Exception {

		// 넘어오는값
		String chkNum = request.getParameter("cartChk");
		String[] chkNums = request.getParameterValues("cartChk");

		int numI = Integer.parseInt(chkNum); // 선택한 넘버값 정수로 바꿔줌

		int[] numsI = new int[chkNums.length]; // 배열 생성

		int result = dao.getCartNumMax(); // 전체 데이터 개수

		// System.out.println(chkNums.length); // 배열 크기
		// System.out.println(cartNum); // 마지막 넘버값
		// System.out.println(chkNum); // 선택 넘버

		if (chkNums.length >= 2) { // 여러개 선택시 (2개이상)
			if (chkNums.length == result) { // 전체선택
				dao.AlldeleteCart(); // 전체삭제
			}
			if (chkNums.length != result) // 여러개 선택
			{
				for (int i = 0; i < chkNums.length; i++) {
					numsI[i] = Integer.parseInt(chkNums[i]);
				}
			}
			dao.selectDeleteCart(numsI); // 선택한 번호삭제

		} else if (chkNums.length == 1) { // 하나 선택시
			dao.deleteCart(numI);// 하나삭제
		}

		return "redirect:/cart.action";
	}

	// 장바구니 버튼삭제
	@RequestMapping(value = "/cart_Onedelete.action", method = { RequestMethod.GET, RequestMethod.POST })
	public String cart_Onedelete(HttpServletRequest request, HttpSession session) throws Exception {

		// 넘어오는 카트 리스트 번호값
		int cartNum = Integer.parseInt(request.getParameter("cartNum"));

		// 삭제
		dao.OnedeleteCart(cartNum);

		return "redirect:/cart.action";
	}

	// 장바구니 수량 번경
	@RequestMapping(value = "/cart_count_update.action", method = { RequestMethod.GET, RequestMethod.POST })
	public String cart_count_update(HttpServletRequest request, HttpSession session) throws Exception {

		String Snum = request.getParameter("cartNum");
		int cartNum = Integer.parseInt(request.getParameter("cartNum"));
		int count = Integer.parseInt(request.getParameter("count" + Snum));

		Map<String, Object> hMap = new HashMap<String, Object>();
		hMap.put("cartNum", cartNum);
		hMap.put("count", count);

		dao.updateCartCount(hMap);

		return "redirect:/cart.action";
	}

	// 미구현: 결제 정보창 (값만 넘김) , 세션 로그인한 값으로 아이디값 받아와야함
	@RequestMapping(value = "/order.action", method = { RequestMethod.GET, RequestMethod.POST })
	public String order(HttpServletRequest request, HttpSession session) throws Exception {

		CustomInfo info = (CustomInfo) session.getAttribute("customInfo");

		String cusId = info.getSessionId();

		// String totPrice = req.getParameter("totPrice"); //나중에 결제 금액 넘김
		String[] chkNums = request.getParameterValues("cartChk"); // 배열에 선택한 cartNum값이 들어온다
		String chkNum = request.getParameter("cartChk");

		// 인트형 배열생성
		int[] numsI = new int[chkNums.length];

		// 스트링형 배열생성
		String[] proId = new String[chkNums.length];

		if (chkNums.length >= 2) { // 여러개 선택시 (2개이상)

			// 선택한 번호의 상품 id값 가져오기
			for (int i = 0; i < chkNums.length; i++) {
				numsI[i] = Integer.parseInt(chkNums[i]); // 선택한cartNum을 저장할 변수
			}
			List<CartDTO> lists = dao.getCartReadData2(numsI); // 배열을 넘겨서 cartNum에 해당하는 productId값을 가져오기 위해

			int i = 0;

			for (CartDTO dto : lists) {// 선택한 개수많큼 리스트를 돌린다
				proId[i] = dto.getProductId(); // 스트링 배열에 선택한 productId값을 넘겨준다
				i++;
			}

			// 스트링 배열proId에 내가 선택한 항목의 productId값이 들어가있다

			// 배열을 리스트에 넘겨준다
			List<ProductDTO> productlists = dao.getProductList(proId);

			// request.setAttribute("totPrice", totPrice);//나중에 물건 총합을 가져온다
			request.setAttribute("productlists", productlists);

		} else if (chkNums.length == 1) { // 하나 선택시

			// 선택한 번호의 상품 id값 가져오기
			CartDTO dto = dao.getCartReadData(chkNum);
			request.setAttribute("dto", dto);
		}

		return "product/order";
	}

	// 리뷰 추가 : 체육관 상세페이지 리뷰 추가 (ajax)
	@RequestMapping(value = "/productreviewCreated.action")
	public String productreviewCreated(HttpServletRequest request, ReviewDTO dto, HttpSession session) throws Exception {
		CustomInfo info = (CustomInfo) session.getAttribute("customInfo");
		if (info != null) {
			request.setAttribute("info", info);
		}
		int numMax = dao.getProductReviewNumMax(); // 삽입용 전체 리뷰 최댓값

		dto.setReNum(numMax + 1);
		dto.setReType("product");
		dao.insertProductReviewData(dto);

		String productId = dto.getProductId();

		// return reviewList(request,gymId); //리다이렉팅 안하고 메소드로 가야 한다. 왜? ajax이므로 새로고침하면
		// 안된다.
		// 이전에는 리다이렉팅을 통해 페이지 이동이므로 새로고침이 들어갔다.
		return productreviewList(request, productId, session);
	}

	// 리뷰 리스트 : 체육관 상세페이지 리뷰 리스트 (ajax)
   @RequestMapping(value = "/productreviewList.action", method = { RequestMethod.GET, RequestMethod.POST })
   public String productreviewList(HttpServletRequest request, String productId, HttpSession session)
         throws Exception {

      CustomInfo info = (CustomInfo) session.getAttribute("customInfo");
      String cusId = "";

      if (info == null || info.equals("")) {
         cusId = "";
      } else {
         cusId = info.getSessionId();
      }

      if (info != null) {
         request.setAttribute("info", info);
      }
      if (productId == null || productId.equals("")) {
         productId = request.getParameter("productId");
      }

      int numPerPage = 3;
      int totalPage = 0;
      int totalDataCount = 0;
      String pageNum = request.getParameter("pageNum");
      int currentPage = 1;

      if (pageNum != null && pageNum != "") {
         currentPage = Integer.parseInt(pageNum);
      } else {
         pageNum = "1";
      }

      // 전체 데이터 갯수
      totalDataCount = dao.getProductReviewNum(productId);

      if (totalDataCount != 0) {
         totalPage = myUtil.getPageCount(numPerPage, totalDataCount);
      }
      if (currentPage > totalPage) {
         currentPage = totalPage;
      }

      Map<String, Object> hMap = new HashMap<String, Object>();

      int start = (currentPage - 1) * numPerPage + 1;
      int end = currentPage * numPerPage;

      hMap.put("start", start);
      hMap.put("end", end);
      hMap.put("productId", productId);

      List<ReviewDTO> productreviewLists = dao.getProductReviewList(hMap);

      Iterator<ReviewDTO> it = productreviewLists.iterator();
      // 전체 평점 평균
      int starAvg = dao.getProductAvgReview(productId);

      while (it.hasNext()) {
         ReviewDTO vo = (ReviewDTO) it.next();
         vo.setReContent(vo.getReContent().replaceAll("\n", "<br/>"));
      }

      String pageIndexList = myUtil.pageIndexList(currentPage, totalPage);

      if (info != null) {
         request.setAttribute("info", info);
         String cusInfo = info.getSessionId();
      }

      // product 데이터 불러오기
      ProductDTO dto = dao.getProductReadData(productId);
      List<ProductPayDTO> paydto = null;
      int su = dao.getProductPayDataCount(cusId);//proPayNum 배열값 지정
      
      if(su == 0) { //구매한적이 없으면
         su = 99;
      }

      // productpay 데이터 불러오기
      if (!cusId.equals("")) { //로그인 했을때 

         paydto = dao.getProductPayReadData(cusId); //테이블 조회한값

         if (paydto != null) { //productpay 테이블을 조회했는데 로그인한 아이디값이 있으면 리뷰작성창이 나오도록

        	int proPayNum[] = new int[99];
            if(su==99) {
               
               request.setAttribute("starAvg", starAvg);
               request.setAttribute("productreviewLists", productreviewLists);
               request.setAttribute("pageIndexList", pageIndexList);
               request.setAttribute("totalDataCount", totalDataCount);
               request.setAttribute("pageNum", pageNum);
               return "product/productreviewList";
            }
            
            int n = 0;
            Iterator<ProductPayDTO> iterator = paydto.iterator();
            while (iterator.hasNext()) {
               ProductPayDTO dto2 = iterator.next();
               proPayNum[n] = dto2.getProPayNum();
               n++;
            }
            

            List<ProductPayDetailDTO> lists = dao.getProductPayList(proPayNum);
            int result = dao.getProductPayDetailDataCount(proPayNum);
            String[] proId = new String[result];
            int i = 0;

            for (ProductPayDetailDTO paydetaildto : lists) {// 선택한 개수많큼 리스트를 돌린다
               proId[i] = paydetaildto.getProductId(); // 스트링 배열에 선택한 productId값을 넘겨준다
               i++;
            }

            for (i = 0; i < result; i++) {
               if (proId[i].equals(dto.getProductId())) {
                  int reviewaccect = 1;
                  request.setAttribute("reviewaccect", reviewaccect);
               }
            }
         }
      }

      request.setAttribute("starAvg", starAvg);
      request.setAttribute("productreviewLists", productreviewLists);
      request.setAttribute("pageIndexList", pageIndexList);
      request.setAttribute("totalDataCount", totalDataCount);
      request.setAttribute("pageNum", pageNum);

      return "product/productreviewList";
   }

	// 리뷰 삭제 : 체육관 상세페이지 리뷰 삭제 (ajax)
	@RequestMapping(value = "/productreviewDeleted.action")
	public String productreviewDeleted(HttpServletRequest request, ReviewDTO dto, HttpSession session) throws Exception {
		CustomInfo info = (CustomInfo) session.getAttribute("customInfo");
		if (info != null) {
			request.setAttribute("info", info);
		}

		String productId = dto.getProductId();
		int reNum = dto.getReNum();

		dao.deleteProductReviewData(reNum);

		return productreviewList(request, productId, session);
	}

	
	//*******************김세이*******************
	
	
	// 체육관 상세 페이지 
		@RequestMapping(value="/gymDetail.action", method = {RequestMethod.GET, RequestMethod.POST})
	public String gymDetail(HttpServletRequest request, HttpSession session) throws Exception {
		//세션에 올라온값 확인
		CustomInfo info = (CustomInfo)session.getAttribute("customInfo");
		String cusId = null;
		if(info!=null && info.getLoginType()!="gym") {
			request.setAttribute("info", info);
			cusId = info.getSessionId();
			//예약시 사용할 사용자 잔여 pass 정보
			int cusPassLeft = dao.getCusPassLeft(cusId);
			request.setAttribute("cusPassLeft", cusPassLeft);
		}else if(info!=null && info.getLoginType()=="gym") {
			request.setAttribute("info", info);
			cusId = info.getSessionId();
		}
		
		String gymId = request.getParameter("gymId");
		
		// 체육관 정보
		GymDTO gymDto = dao.getGymData(gymId);
		
		List<String> gymTrainer = Arrays.asList(gymDto.getGymTrainer().split(","));
		List<String> gymTrainerPic = Arrays.asList(gymDto.getGymTrainerPic().split(","));
		
		/*  
		 * 리뷰 작성 : 회원 세션에 cusId가 올라가있으면서,
		 *  해당 체육관의 Book 목록에 cusId가 있으면서,
		 *  회원이 등록한 리뷰의 수가 book수보다 작을때 입력창 보이게 하기
		 */
		
		// 관련 인기 상품 뿌리기
		List<ProductDTO> productLists = null;
		
		if(gymDto.getGymType().equals("요가")) {
			// productId의 첫글자가 'Y'인 상품 중, productHit가 가장 높은 3개 상품
			// 클릭시 상품 상세 페이지로, 
			// 더보기 링크 클릭시 조건 가지고 검색결과/카테고리 페이지로 
			
			productLists = dao.getProductListForGym("Y");
		} else if (gymDto.getGymType().equals("헬스")){
			productLists = dao.getProductListForGym("H");
		} else if (gymDto.getGymType().equals("필라테스")){
			productLists = dao.getProductListForGym("P");
		} else {
			System.out.println("ERR) NO SUCH GYM TYPE EXISTS");
			return "redirect:/gyp/";
		}

		// 이용 시간 - 평일, 토요일, 주말
		List<String> gymHour = Arrays.asList(gymDto.getGymHour().split(","));
		
		// 예약 시간 뿌리기
		for (int i = 0; i < 3; i++) {
			ArrayList<String> optionTimes = new ArrayList<String>();
			
			int startTime = Integer.parseInt(gymHour.get(i).substring(0,2));
			int endTime = Integer.parseInt(gymHour.get(i).substring(8,10));
			
			if(startTime == endTime) {
				endTime += 24;
			}
			
			for (int j = startTime; j < endTime; j++) {
				String time;
				
				if (j<9) {
					time = "0" + j+":00~"+ "0" + (j+1)+":00";	// 08:00~09:00
				} else if(j==9) {
					time = "0" + j+":00~"+ (j+1)+":00";	// 09:00~10:00
				} else if(j==24) {
					time = "24:00~01:00";
				} else {
					time = j+":00~"+(j+1)+":00";	// 10:00~11:00
				}
				optionTimes.add(time);
			}
			
			
			request.setAttribute("optionTimes"+i, optionTimes);
		}
		
		// 찜 여부 확인
		if(info!=null) {
			Map<String, Object> hMap = new HashMap<String, Object>();
			hMap.put("gymId",gymId);
			hMap.put("cusId", cusId);
			
			int whetherJjim = dao.countJjimData(hMap);
			//System.out.println(whetherJjim);
			request.setAttribute("whetherJjim", whetherJjim);
		}
		 
		// 체육관 사진
		List<String> gymPic = Arrays.asList(gymDto.getGymPic().split(","));
		// 이용 가능 시설
		List<String> gymFacility = Arrays.asList(gymDto.getGymFacility().split(","));
		
		//확장for문, 하나씩 꺼내서 글자길이 수정
		for(ProductDTO dto : productLists) {
			if(dto.getProductContent().length() > 11) { //프로그램 길면 자르기
				dto.setProductContent(dto.getProductContent().substring(0, 11) + " ...");
			}
		}
		
		// request set
		request.setAttribute("productLists", productLists);
		request.setAttribute("gymDto", gymDto);
		request.setAttribute("gymTrainer", gymTrainer);
		request.setAttribute("gymTrainerPic", gymTrainerPic);
		request.setAttribute("gymPic", gymPic);
		request.setAttribute("gymFacility", gymFacility);
		request.setAttribute("gymHour", gymHour);
		
		
		return "gymDetail/gymDetail";
	}
		
	// 리뷰 추가 : 체육관 상세페이지 리뷰 추가 (ajax)
	@RequestMapping(value="/reviewCreated.action")
	public String reviewCreated(HttpServletRequest request, ReviewDTO dto, HttpSession session) throws Exception {
			CustomInfo info = (CustomInfo)session.getAttribute("customInfo");
			if(info!=null) {
				request.setAttribute("info", info);
			}
			int numMax = dao.getReviewNumMax(); //삽입용 전체 리뷰 최댓값
			
			dto.setReNum(numMax+1);
			dto.setReType("gym");
			dao.insertReviewData(dto);
			
			String gymId = dto.getGymId();
			
			//return reviewList(request,gymId);	//리다이렉팅 안하고 메소드로 가야 한다. 왜? ajax이므로 새로고침하면 안된다. 
			//이전에는 리다이렉팅을 통해 페이지 이동이므로 새로고침이 들어갔다. 
			return reviewList(request,gymId,session);
		}
	
	// 리뷰 리스트 : 체육관 상세페이지 리뷰 리스트 (ajax)
	@RequestMapping(value="/reviewList.action", method={RequestMethod.GET, RequestMethod.POST})
	public String reviewList(HttpServletRequest request, String gymId,HttpSession session) throws Exception{
		CustomInfo info = (CustomInfo)session.getAttribute("customInfo");
		if(info!=null) {
			request.setAttribute("info", info);
		}
		
		if(gymId==null||gymId.equals("")) {
			gymId = request.getParameter("gymId");
		}
      
		int numPerPage = 3;
		int totalPage = 0;
		int totalDataCount = 0;
      
		String pageNum = request.getParameter("pageNum");
      
		int currentPage = 1;
      
		if(pageNum!=null && pageNum!=""){
			currentPage = Integer.parseInt(pageNum);
		} else {
			pageNum = "1";
		}
		
		//전체 데이터 갯수
		totalDataCount = dao.getReviewNum(gymId);
		
		
		totalPage = myUtil.getPageCount(numPerPage, totalDataCount);
      
		if(currentPage>totalPage) {
			currentPage = totalPage;
		}   
      
		Map<String, Object> hMap = new HashMap<String, Object>();
      
		int start = (currentPage-1)*numPerPage+1;
		int end = currentPage*numPerPage;
      
		hMap.put("start", start);
		hMap.put("end", end);
		hMap.put("gymId",gymId);
      
		List<ReviewDTO> lists = dao.getReviewList(hMap);
      
		Iterator<ReviewDTO> it = lists.iterator();
		
		//전체 평점 평균
		if(lists!=null) {
			int starAvg = dao.getAvgReview(gymId);
			request.setAttribute("starAvg", starAvg);
		}
      
		while(it.hasNext()) {
			ReviewDTO vo = (ReviewDTO)it.next();
			vo.setReContent(vo.getReContent().replaceAll("\n", "<br/>"));
		}
      
		String pageIndexList = myUtil.pageIndexList(currentPage, totalPage);
		
		if(info!=null) {
			request.setAttribute("info", info);
			String cusInfo = info.getSessionId();

			//Map<String, Object> hMap = new HashMap<String, Object>();
			hMap.put("cusId", cusInfo);
			hMap.put("gymId", gymId);
         
			int timesCusBookedGym = dao.getTimesCusBookedGym(hMap);
			request.setAttribute("timesCusBookedGym", timesCusBookedGym);
			
			int timesCusReviewedGym = dao.getTimesCusReviewedGym(hMap);
			request.setAttribute("timesCusReviewedGym", timesCusReviewedGym);
		}
		
		if(totalDataCount==0) {
			request.setAttribute("totalDataCount",totalDataCount);
			return "gymDetail/reviewList";
		}
		request.setAttribute("reviewLists", lists);
		request.setAttribute("pageIndexList",pageIndexList);
		request.setAttribute("pageNum",pageNum);
		request.setAttribute("totalDataCount",totalDataCount);
		
		return "gymDetail/reviewList";
	}

	// 리뷰 삭제 : 체육관 상세페이지 리뷰 삭제 (ajax)
	@RequestMapping(value="/reviewDeleted.action")
	public String reviewDeleted(HttpServletRequest request, ReviewDTO dto,HttpSession session) throws Exception {
		CustomInfo info = (CustomInfo)session.getAttribute("customInfo");
		if(info!=null) {
			request.setAttribute("info", info);
		}
		
		String gymId = dto.getGymId();
		int reNum = dto.getReNum();
		
		dao.deleteReviewData(reNum);
		
		return reviewList(request,gymId,session);
	}

	// 체육관 예약 : 체육관 상세페이지에서 예약하기 
	@RequestMapping(value="/gymBook.action")
	public String gymBook(HttpServletRequest request, HttpServletResponse response,
			BookDTO dto,HttpSession session) throws IOException {
		
		CustomInfo info = (CustomInfo)session.getAttribute("customInfo");
		if(info==null) {//돌발적 로그아웃 대비
			return "redirect:/login.action";
		}
		//사용자 잔여 pass 가져오기
		String cusId = info.getSessionId();
		int cusPassLeft = dao.getCusPassLeft(cusId);
		// 체육관 정보
		GymDTO gymDto = dao.getGymData(dto.getGymId());
         
		String datePick = request.getParameter("datePick");
		String bookHourWd = request.getParameter("bookHourWd");
		String bookHourSat = request.getParameter("bookHourSat");
		String bookHourSun = request.getParameter("bookHourSun");
		String bookHour = "";
		
		System.out.println(bookHourWd);
		System.out.println(bookHourSat);
		System.out.println(bookHourSun);
      
		if(!bookHourWd.equals("") && bookHourWd!=null) {
			bookHour = datePick + "," + bookHourWd;
		}else
		if(!bookHourSat.equals("") && bookHourSat!=null) {
			bookHour = datePick + "," + bookHourSat;
		}else
		if(!bookHourSun.equals("") && bookHourSun!=null) {
			bookHour = datePick + "," + bookHourSun;
		}
      
      
		int numMax = dao.getBookNumMax(); //삽입용 전체 예약 최댓값
      
		dto.setBookNum(numMax + 1);
		dto.setCusId(info.getSessionId());
		dto.setBookHour(bookHour);
      
		// 중복 확인
		// gymId와 bookHour gymTrainerPick bookType bookOk가 일치하면 중복이라 간주하고 예약 취소하기
		int checkDuplicateBook = dao.checkDuplicateBook(dto);
      
		if(checkDuplicateBook>0) {
			response.setContentType("text/html; charset=utf-8");
			PrintWriter out = response.getWriter();
			out.println("<script>");
			out.println("alert('이미 예약된 시간이거나, 동일한 시간대에 예약한 기록이 있습니다.      "
					+ "다른 시간을 선택해주세요');");
			out.println("history.back();");
			out.println("</script>");
			out.close();
			return "gymDetail/gymDetail";
		}
      
      //사용자 pass 수 차감하기
      if(cusPassLeft<gymDto.getGymPass()) {
         //alert후 상세페이지로 돌아가기
         response.setContentType("text/html; charset=utf-8");
         PrintWriter out = response.getWriter();
         out.println("<script>");
         out.println("alert('잔여 pass 수가 부족합니다!');");
         out.println("history.back();");
         out.println("</script>");
         out.close();
         return "gymDetail/gymDetail";
      }
      
      //사용자 pass수 차감하여 update하기
      cusPassLeft = cusPassLeft - gymDto.getGymPass();
      
      Map<String, Object> hMap = new HashMap<String, Object>();
      hMap.put("cusId",cusId);
      hMap.put("cusPass",cusPassLeft);
      
      dao.updateCusPass(hMap);
      
      dao.insertBookData(dto);
      
      return "redirect:/gymBook_ok.action";
   }
	
	// 체육관 예약 완료
	@RequestMapping(value="/gymBook_ok.action", method = {RequestMethod.GET, RequestMethod.POST})
	public String gymBook_ok(HttpServletRequest request, BookDTO dto,HttpSession session) {
		return "gymDetail/gymBook_ok";
	}

	// 체육관 찜하기
	@RequestMapping(value="/gymJjim.action")
	public String gymJjim(HttpServletRequest request, HttpServletResponse response,JjimDTO dto,HttpSession session) throws Exception{
			
			CustomInfo info = (CustomInfo)session.getAttribute("customInfo");
			if(info==null) {//돌발적 로그아웃 대비
				return "redirect:/login.action";
			}
			
			String cusId = info.getSessionId();
			String gymId = request.getParameter("gymId");
			
			int whetherJjim = Integer.parseInt(request.getParameter("whetherJjim"));
			
			// 찜 추가하기
			if(whetherJjim==0) {
				
				dto.setCusId(cusId);
				dto.setGymId(gymId);
				dao.insertJjimData(dto);
				
			} else {
				dao.deleteJjimData(gymId);
			}
			return "redirect:/gymDetail.action?gymId="+gymId;
		}
	
	// 맵에서 체육관 찜하기
	@RequestMapping(value="/mapGymJjim.action")
	public void mapGymJjim(HttpServletRequest request, HttpServletResponse response,JjimDTO dto,HttpSession session) throws Exception{
				
		CustomInfo info = (CustomInfo)session.getAttribute("customInfo");
		String cusId = null;
		String gymId = null;
		if(info!=null) {
			cusId = info.getSessionId();
			gymId = request.getParameter("gymId");
		}
		//-----------------map.action에서 찜하기(경기민)----------------------
		
					response.setContentType("text/html; charset=UTF-8");
				    PrintWriter out = response.getWriter();
					HashMap<String, Object> hashMap = new HashMap<String, Object>();
					hashMap.put("cusId", cusId);
					hashMap.put("gymId", gymId);
							
					int count = dao.countJjimData(hashMap);
					if(count==0) {
						dto.setCusId(cusId);
						dto.setGymId(gymId);
						dao.insertJjimData(dto);
						out.println("찜 추가!");
						out.flush();
								            
					}else {
									
						dao.deleteJjimData(gymId);
						out.println("찜 제거!");
						out.flush();
					}
	}
	
	// 패스 선택
	@RequestMapping(value="/passCharge.action", method = {RequestMethod.GET, RequestMethod.POST})
	public String passCharge(HttpServletRequest request, HttpSession session) throws Exception {
		
		/*
		 * CustomInfo info = (CustomInfo)session.getAttribute("customInfo");
		 * if(info==null) {//돌발적 로그아웃 대비 return "redirect:/login.action"; }
		 */
		
        int pricePerPass = 5000;
        List<Integer> passKind = new ArrayList<Integer>();
        passKind.add(5);
        passKind.add(30);
        passKind.add(78);
        passKind.add(100);
        
        List<String> passDescription = new ArrayList<String>();
        passDescription.add("한번 체험해보세요");
        passDescription.add("재미를 붙여볼까요?");
        passDescription.add("건강한 생활의 시작");
        passDescription.add("당신은 운동 매니아");
        
        request.setAttribute("pricePerPass", pricePerPass);
        request.setAttribute("passKind", passKind);
        request.setAttribute("passDescription", passDescription);
        
		return "payment/passCharge";
	}
	
	// 결제하기(창)
	@RequestMapping(value="/payment.action", method = {RequestMethod.GET, RequestMethod.POST})
   	public String Payment(HttpServletRequest request, HttpSession session) throws Exception {
	   CustomInfo info = (CustomInfo)session.getAttribute("customInfo");
	   if(info==null) {//돌발적 로그아웃 대비
		   return "redirect:/login.action";
	   }
	   // 결제정보 작성을 위해 사용자 정보 불러와서 set시키기
	   CustomerDTO cusDto = dao.getCustromerDTOReadData(info);
      
	   if(cusDto.getCusPwd()=="naver" || cusDto.getCusPwd().equals("naver")) {//네이버로 로그인한 경우
		   request.setAttribute("cusTel", null);
		   request.setAttribute("cusAddr", null);
	   } else {
		   request.setAttribute("cusTel", cusDto.getCusTel());
		   request.setAttribute("cusAddr", cusDto.getCusAddr());
	   }
	   request.setAttribute("cusId", info.getSessionId());
	   request.setAttribute("cusName", cusDto.getCusName());
	   
	   // passSelected가 null이 아니면 pass결제, null이면 상품 결제
	   String passSelected = request.getParameter("pass");

	   //패스 결제하기
	   if(passSelected!=null) {
		   int passNum = Integer.parseInt(passSelected.substring(5));
		   int finalPayVal = passNum * 5000;
         
		   request.setAttribute("passSelected", passSelected);
		   request.setAttribute("finalPayVal", finalPayVal);
		   return "payment/payment";
	   }
	   
	   String productSelected = request.getParameter("productSelected");
	   //상품상세에서 결제하기
	   if(productSelected!=null) {

		   String productId = request.getParameter("productId");
		   int count = Integer.parseInt(request.getParameter("count"));
		   int price = Integer.parseInt(request.getParameter("price"));
		   
		   int finalPayVal = count * price;
		   ProductDTO productToBuy = dao.getProductReadData(productId);
		   
		   String imagePath = "/gyp/sfiles/product"; // 이미지 경로
		   
		   request.setAttribute("productToBuy", productToBuy);
		   request.setAttribute("count", count);
		   request.setAttribute("finalPayVal", finalPayVal);
		   request.setAttribute("imagePath", imagePath);
		   return "payment/payment";
	   }
	   
      
	   String totPrice = request.getParameter("totPrice2"); //나중에 결제 금액 넘김
	   String[] chkNums = request.getParameterValues("cartChk"); // 배열에 선택한 cartNum값이 들어온다
      
	   /*for (int i = 0; i < chkNums.length; i++) { System.out.println(chkNums[i]); }*/ //debug array of product
      
	   //결제할 상품 정보 리스트
	   int[] numI = null;
	   if (chkNums != null) {
		   numI = new int[chkNums.length];
		   for (int i = 0; i < chkNums.length; i++) {
			   numI[i] = Integer.parseInt(chkNums[i]);
		   }
	   }
      
	   //상품 결제
	   List<ProductOrderDTO> listsToBuy = dao.getProductOrderList(numI,info.getSessionId());

//            Iterator<ProductDTO> itr = lists.iterator();
//            while (itr.hasNext()) {
//                System.out.print(itr.next().getProductName() + " ");
//            }
      
	   String imagePath = "/gyp/sfiles/product"; // 이미지 경로

	   request.setAttribute("listsToBuy", listsToBuy);
	   request.setAttribute("finalPayVal", totPrice);
	   request.setAttribute("imagePath", imagePath);
      
	   return "payment/payment";
   }
   
   	// 실제 결제
   	@RequestMapping(value="/actualPayment.action", method=RequestMethod.POST)
   	public void actualPayment(HttpServletRequest request, HttpSession session) throws Exception {
      
   		CustomInfo info = (CustomInfo)session.getAttribute("customInfo");
   		String cusId = info.getSessionId();
   		
   		String params = request.getParameter("params");
   		String item = params.substring(params.indexOf("item=")+"item=".length(),params.indexOf("&"));
      
   		// pass 결제시
   		if(item.startsWith("pass_")) {
         
   			int chargePass = Integer.parseInt(item.substring(5)); // "pass_n"에서 n만 파싱해서 사용
   			String payMethod = params.substring(params.indexOf("payMethod=")+"payMethod=".length());
         
   			ChargeDTO chargeDto = new ChargeDTO();
         
   			//chargeDTO num데이터 타입 string에서 int로 수정함
   			int chargeNumMax = dao.getChargeNumMax();
   			chargeDto.setChargeNum(chargeNumMax+1);
   			chargeDto.setCusId(cusId);
   			chargeDto.setChargePass(chargePass);
   			chargeDto.setChargeType(payMethod);
         
   			//charge테이블에 추가하기
   			dao.insertChargeData(chargeDto);
         
   			//사용자 pass 수 수정
   			int cusPassLeft = dao.getCusPassLeft(cusId);

   			cusPassLeft += chargePass;
   			Map<String, Object> hMap = new HashMap<String, Object>();
   			hMap.put("cusId",cusId);
   			hMap.put("cusPass",cusPassLeft);
         
   			//charge 테이블 업데이트
   			dao.updateCusPass(hMap);

   			return;
   		}      
      
   		// 상품 결제시 -> item이 pass_로 시작하지 않으면
      
   		int proPayNumMax = dao.getProPayNumMax();

   		String amount = params.substring(params.indexOf("amount=")+"amount=".length(),params.indexOf("&",params.indexOf("amount=")));
   		//String payMethod = params.substring(params.indexOf("payMethod=")+"payMethod=".length(),params.indexOf("&",params.indexOf("payMethod=")));
   		//String receiver_name = params.substring(params.indexOf("receiver_name=")+"receiver_name=".length(),params.indexOf("&",params.indexOf("receiver_name=")));
   		String receiver_tel = params.substring(params.indexOf("receiver_tel=")+"receiver_tel=".length(),params.indexOf("&",params.indexOf("receiver_tel=")));
   		String receiver_addr = params.substring(params.indexOf("receiver_addr=")+"receiver_addr=".length(),params.indexOf("&",params.indexOf("receiver_addr=")));
   		String productIdArr = params.substring(params.indexOf("productIdArr=")+"productIdArr=".length(),params.indexOf("&",params.indexOf("productIdArr=")));
   		String productCountArr = params.substring(params.indexOf("productCountArr=")+"productCountArr=".length());
      
   		// productPay테이블에 삽입
   		ProductPayDTO ppdto = new ProductPayDTO();
   		ppdto.setProPayNum(proPayNumMax+1);
   		ppdto.setCusId(cusId);
   		ppdto.setPriceTotal(Integer.parseInt(amount));
   		ppdto.setProPayAddr(receiver_addr);
   		ppdto.setProPayTel(receiver_tel);
   		dao.insertProductPay(ppdto);   // 삽입
      
   		// productPayDetail테이블에 삽입
   		int proPayDetailNumMax = dao.getProPayDetailNumMax();
   		
   		List<String> productIdList = new ArrayList<String>(Arrays.asList(productIdArr.split(",")));
   		List<String> productCountList = new ArrayList<String>(Arrays.asList(productCountArr.split(",")));
      
   		for (int i = 0; i < productIdList.size(); i++) {
         
   			ProductPayDetailDTO ppddto = new ProductPayDetailDTO();
   			ppddto.setProPayDetailNum(proPayDetailNumMax+(i+1));
   			ppddto.setProductId(productIdList.get(i));
   			ppddto.setProPayNum(ppdto.getProPayNum());
   			ppddto.setCount(Integer.parseInt(productCountList.get(i)));
   			dao.insertProductPayDetail(ppddto);
         
   		}

   		//장바구니에서 삭제
   		dao.deleteFromCartAfterPayment(productIdList,cusId);
   		return;
   	}
	
	// 결제 완료 (창)
	@RequestMapping(value="/payment_ok.action")
	public String payment_ok(HttpServletRequest request, JjimDTO dto,HttpSession session) throws Exception{
			
		CustomInfo info = (CustomInfo)session.getAttribute("customInfo");
		if(info==null) {//돌발적 로그아웃 대비
			//return "redirect:/login.action";
		}
		
		return "payment/payment_ok";
	}
	
	//네이버 로그인 (사용자만 가능. 체육관 X)
	@SuppressWarnings("null")
	@RequestMapping(value = "/naverLogin_ok.action" , method = {RequestMethod.GET,RequestMethod.POST})
	public String naverLogin_ok(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception{
			
			String clientId = "P84rJHPRvVU6zfXj1ZXD";//애플리케이션 클라이언트 아이디값";
		    String clientSecret = "Q_VuYrdAQN";//애플리케이션 클라이언트 시크릿값";
		    String code = request.getParameter("code");
		    String state = request.getParameter("state");
		    String redirectURI = URLEncoder.encode("http://192.168.16.9:8000/gyp/naverLogin_ok.action", "UTF-8");
		    String apiURL;
		    apiURL = "https://nid.naver.com/oauth2.0/token?grant_type=authorization_code&";
		    apiURL += "client_id=" + clientId;
		    apiURL += "&client_secret=" + clientSecret;
		    apiURL += "&redirect_uri=" + redirectURI;
		    apiURL += "&code=" + code;
		    apiURL += "&state=" + state;
		    String access_token = "";
		    String refresh_token = "";
		    //System.out.println("apiURL="+apiURL);
		    try {
		      URL url = new URL(apiURL);
		      HttpURLConnection con = (HttpURLConnection)url.openConnection();
		      con.setRequestMethod("GET");
		      int responseCode = con.getResponseCode();
		      BufferedReader br;
		      //System.out.println("responseCode="+responseCode);
		      if(responseCode==200) { // 정상 호출
		        br = new BufferedReader(new InputStreamReader(con.getInputStream()));
		      } else {  // 에러 발생
		        br = new BufferedReader(new InputStreamReader(con.getErrorStream()));
		      }
		      String inputLine;
		      StringBuffer res = new StringBuffer();
		      while ((inputLine = br.readLine()) != null) {
		        res.append(inputLine);
		      }
		      br.close();
		      if(responseCode==200) {	//정상 로그인 시
		        //System.out.println("res: " + res.toString());
		         
		        JSONParser parsing = new JSONParser();
		        Object obj = parsing.parse(res.toString());
		        JSONObject jsonObj = (JSONObject)obj;
		        
		    	access_token = (String)jsonObj.get("access_token");
		    	refresh_token = (String)jsonObj.get("refresh_token");
		    	
		    	// 사용자 회원정보 api response parsing
		        String header = "Bearer " + access_token; // Bearer 다음에 공백 추가
		        String apiURL2 = "https://openapi.naver.com/v1/nid/me";
	
		        Map<String, String> requestHeaders = new HashMap<String, String>();
		        requestHeaders.put("Authorization", header);
		        String responseBody = get(apiURL2,requestHeaders);
		        String responsebodyparse = responseBody.substring(responseBody.indexOf("response")+11,responseBody.length()-2);
		        
				Map<String, String> naverMap = new HashMap<String, String>();
				String[] pairs = responsebodyparse.split(","); 
				
				for (int i=0;i<pairs.length;i++) { 
					String pair = pairs[i]; 
					String[] keyValue = pair.split(":"); 
					naverMap.put(keyValue[0], String.valueOf(keyValue[1])); 
				}
				//System.out.println("naverMap: " + naverMap);
				 
		    	String naverId = naverMap.get("\"id\"");
		    	String naverName = naverMap.get("\"name\"");
		    		naverName = convertString(naverName);
		    	String naverEmail = naverMap.get("\"email\"");
		    	
		    	// 일반 로그인 처리
				CustomInfo info = new CustomInfo(); 
				String sessionId = naverId.replaceAll("\"", "");	// 네이버 식별정보 ID 잘라서 삽입
				String loginType = "customer"; //customer 인지, gym인지 저장
				
				int result = dao.getDataCount(sessionId);//첫 로그인이라면 결과는 0, 이전에 로그인한적 있다면 결과는 1
				
				if (result == 0){//유저가 네이버 로그인이 처음이라면 회원 추가하기
					System.out.println("네이버 회원을 추가합니다. ");
					// 데이터베이스에 회원 추가하고 
					CustomerDTO naverCusDto = new CustomerDTO();
					naverCusDto.setCusId(naverId.replaceAll("\"", ""));
					naverCusDto.setCusName(naverName.replaceAll("\"", ""));
					naverCusDto.setCusPwd("naver");
					naverCusDto.setCusEmail(naverEmail.replaceAll("\"", ""));
					naverCusDto.setCusTel("naver");
					naverCusDto.setCusAddr("naver");
					naverCusDto.setCusAddrDetail("naver");
					dao.cusCreated(naverCusDto);
					System.out.println("데이터베이스에 네이버 회원 추가 완료");
				}
				// 로그인이 처음이 아니라면 추가하지 않고 세션에만 올린다. 
				
				//세션에 올리기
				info.setSessionId(sessionId); //세션에 값 입력
				info.setLoginType(loginType);//로그인 타입(customer, gym )
				session.setAttribute("customInfo", info); // 세션에 info에 들어가있는정보(userid,username)이 올라간다.
				return "home";
				
		      }else {  // 에러 발생
		    	  br = new BufferedReader(new InputStreamReader(con.getErrorStream()));
		    	  return "login/login";
		      }
		    } catch (Exception e) {
		      System.out.println(e);
		    }
			return "login/naverLogin_ok";
			
		}
		
	//네이버 로그인시 필요한 메소드(1)
	private static String get(String apiUrl, Map<String, String> requestHeaders){
	    HttpURLConnection con = connect(apiUrl);
	    try {
	        con.setRequestMethod("GET");
	        for(Map.Entry<String, String> header :requestHeaders.entrySet()) {
	            con.setRequestProperty(header.getKey(), header.getValue());
	        }
	
	        int responseCode = con.getResponseCode();
	        if (responseCode == HttpURLConnection.HTTP_OK) { // 정상 호출
	            return readBody(con.getInputStream());
	        } else { // 에러 발생
	            return readBody(con.getErrorStream());
	        }
	    } catch (IOException e) {
	        throw new RuntimeException("API 요청과 응답 실패", e);
	    } finally {
	        con.disconnect();
	    }
	}
	
	//네이버 로그인시 필요한 메소드(2)
	private static HttpURLConnection connect(String apiUrl){
	    try {
	        URL url = new URL(apiUrl);
	        return (HttpURLConnection)url.openConnection();
	    } catch (MalformedURLException e) {
	        throw new RuntimeException("API URL이 잘못되었습니다. : " + apiUrl, e);
	    } catch (IOException e) {
	        throw new RuntimeException("연결이 실패했습니다. : " + apiUrl, e);
	    }
	}
	
	//네이버 로그인시 필요한 메소드(3)
	private static String readBody(InputStream body){
	    InputStreamReader streamReader = new InputStreamReader(body);
	    
	    try{
	    	BufferedReader lineReader = new BufferedReader(streamReader);
	        StringBuilder responseBody = new StringBuilder();
	
	        String line;
	        while ((line = lineReader.readLine()) != null) {
	            responseBody.append(line);
	        }
	
	        return responseBody.toString();
	    } catch (IOException e) {
	        throw new RuntimeException("API 응답을 읽는데 실패했습니다.", e);
	    }
	}
	
	// 유니코드에서 String으로 변환
	public static String convertString(String val) {
		StringBuffer sb = new StringBuffer();
		for (int i = 0; i < val.length(); i++) {
		if ('\\' == val.charAt(i) && 'u' == val.charAt(i + 1)) {
		Character r = (char) Integer.parseInt(val.substring(i + 2, i + 6), 16);
		sb.append(r);
		i += 5;
		} else {
		sb.append(val.charAt(i));
		}
		}
		return sb.toString();
	}
	
	
	//*******************서예지*******************
	//-------------------notice-------------------
	
	@RequestMapping(value="/noticeList.action",method = {RequestMethod.GET,RequestMethod.POST})
	public String noticeList(HttpServletRequest request,HttpSession session) throws Exception{
		
		session = request.getSession();
		CustomInfo info = (CustomInfo)session.getAttribute("customInfo");
		int result = 1;
		
		//0:관리자 / 로그인했을때만 qnaList.jsp 뜬다.(수정해야됨)
		if(info!=null && info.getSessionId().equals("admin")) {
			result = 0;
			session.getId();
		}
	
		String cp = request.getContextPath();
		String pageNum = request.getParameter("pageNum");
		int currentPage = 1;
		
		if(pageNum != null) {//처음 페이지는 1
			currentPage = Integer.parseInt(pageNum);
		}
		
		int dataCount = dao.getNoticeDataCount();//데이터전체출력
		int numPerPage = 6; //한 페이지에 10개
	
		int totalPage = myUtil.getPageCount(numPerPage, dataCount);
		if(currentPage > totalPage)
			currentPage = totalPage;
		
		int start = (currentPage-1)*numPerPage+1;
		int end = currentPage*numPerPage;
		
		//한 페이지에 뿌릴 리스트 가져옴
		List<NoticeDTO> lists = dao.getNoticeList(start,end); 
		
		//listNum
		int n = 0;
		int listNum = 0;
		Iterator<NoticeDTO> it = lists.iterator();
		while(it.hasNext()) {
			NoticeDTO data = (NoticeDTO)it.next();
			listNum = dataCount - (start + n - 1);
			data.setListNum(listNum);
			n++;
		}
		
		//주소
		String listUrl = cp + "/noticeList.action";
		String pageIndexList = myUtil.pageIndexList(currentPage, totalPage, listUrl);
		String articleUrl = cp + "/noticeArticle.action?pageNum=" + currentPage;
		
		request.setAttribute("lists", lists);
		request.setAttribute("result",result);
		request.setAttribute("pageIndexList",pageIndexList);
		request.setAttribute("pageNum",pageNum);
		request.setAttribute("dataCount",dataCount);
		request.setAttribute("articleUrl",articleUrl);
		
		return "notice/noticeList";
	}
	
	//공지사항 등록 페이지로 가기
	@RequestMapping(value="/noticeCreated.action",method = {RequestMethod.GET,RequestMethod.POST})
	public String noticeCreated(HttpServletRequest request,HttpServletResponse response,NoticeDTO dto) throws Exception{
	
		//maxnum 을 불러와서 +1해서 dto에 집어넣은 뒤 보내기
		int maxNum = dao.getNoticeMaxNum();
		dto.setNotiNum(maxNum+1);
		
		request.setAttribute("dto", dto);
		request.setAttribute("mode", "insert");
		return "notice/noticeCreated";
	}
	
	//공지사항 등록 삽입
	@RequestMapping(value="/noticeCreated_ok.action",method = {RequestMethod.GET,RequestMethod.POST})
	public String noticeCreated_ok(HttpServletRequest request,NoticeDTO dto) throws Exception{
		
		//notiNum 최대값 +1을 넘긴다. 
		int noticeNumMax = dao.getNoticeMaxNum();
		dto.setNotiNum(noticeNumMax + 1);
		
		dao.insertNotice(dto);
		return "redirect:/noticeList.action";
	}	
	
	//공지사항 게시글
	@RequestMapping(value="/noticeArticle.action",method = {RequestMethod.GET,RequestMethod.POST})
	public String noticeArticle(HttpServletRequest request) throws Exception{
		
		HttpSession session = request.getSession();
		CustomInfo info = (CustomInfo)session.getAttribute("customInfo");
		int result = 1;//1:일반회원 
				
		//0:관리자 / 관리자일 경우에만 qnaList.jsp 뜬다.(수정해야됨)
		if(info!=null && info.getSessionId().equals("admin")) {
			result = 0;
			session.getId();
		}
		
		//넘어오는 값 받아옴
		int notiNum = Integer.parseInt(request.getParameter("notiNum"));
		String pageNum = request.getParameter("pageNum");
		
		//notiNum으로 게시글 DTO 가져옴
		NoticeDTO dto = (NoticeDTO)dao.getNoticeReadData(notiNum);
		
		if(dto == null) {
			return "redirect:/noticeList.action";
		}
		
		//줄바꿈 변형
		dto.setNotiContent(dto.getNotiContent().replaceAll("\r\n", "<br/>"));
		
		//이전글
		NoticeDTO preReadData = (NoticeDTO)dao.getNoticePreReadData(notiNum);
		int preNotiNum = 0;
		String preNotiTitle = "";
		if(preReadData!=null) {
			preNotiNum = preReadData.getNotiNum();
			preNotiTitle = preReadData.getNotiTitle();
		}
		
		//다음글
		NoticeDTO nextReadData = (NoticeDTO)dao.getNoticeNextReadData(notiNum);
		int nextNotiNum = 0;
		String nextNotiTitle = "";
		if(nextReadData!=null) {
			nextNotiNum = nextReadData.getNotiNum();
			nextNotiTitle = nextReadData.getNotiTitle();
		}
		
		//주소
		String params = "pageNum="+pageNum;
		
		request.setAttribute("result", result);
		request.setAttribute("dto", dto);
		request.setAttribute("preNotiNum", preNotiNum);
		request.setAttribute("preNotiTitle", preNotiTitle);
		request.setAttribute("nextNotiNum", nextNotiNum);
		request.setAttribute("nextNotiTitle", nextNotiTitle);
		request.setAttribute("pageNum", pageNum);
		request.setAttribute("params", params);
		
		return "notice/noticeArticle";
	}
	
	//공지사항 수정페이지로 이동
	@RequestMapping(value="/noticeUpdated.action",method = {RequestMethod.GET,RequestMethod.POST})
	public String noticeUpdate(HttpServletRequest request) throws Exception{
		
	
		//넘어오는 값 받음
		int notiNum = Integer.parseInt(request.getParameter("notiNum"));
		String pageNum = request.getParameter("pageNum");
		
		//디비에서 수정할 notice객체 받아옴
		NoticeDTO dto = (NoticeDTO)dao.getNoticeReadData(notiNum);
		if(dto==null) {
			return "redirect:/noticeList.action?pageNum=" + pageNum;
		}
		request.setAttribute("mode", "update");
		request.setAttribute("pageNum", pageNum);
		request.setAttribute("dto", dto);
		
		return "notice/noticeCreated";
	}
	
	//공지사항 수정 처리
	@RequestMapping(value="/noticeUpdated_ok.action",method = {RequestMethod.GET,RequestMethod.POST})
	public String noticeUpdated_ok(NoticeDTO dto,HttpServletRequest request) throws Exception{
				
		//넘어오는 값
		String pageNum = request.getParameter("pageNum");
		//수정
		dao.updateNoticeData(dto);
		
		return "redirect:/noticeList.action?pageNum="+pageNum;
	}	
	
	//공지사항 삭제
	@RequestMapping(value="/noticeDeleted.action",method = {RequestMethod.GET,RequestMethod.POST})
	public String noticeDeleted(HttpServletRequest request) throws Exception{
		
		//넘어오는 값
		String pageNum = request.getParameter("pageNum");
		int notiNum = Integer.parseInt(request.getParameter("notiNum"));
		//삭제
		dao.deleteNoticeData(notiNum);
		
		return "redirect:/noticeList.action?pageNum="+pageNum;
	}	
		
	//-------------------qna-------------------
	
	//질문게시판 리스트
	@RequestMapping(value="/qnaList.action",method = {RequestMethod.GET,RequestMethod.POST})
	public String qnaList(HttpServletRequest request,HttpServletResponse response,QnaDTO dto,HttpSession session) throws Exception{
	
		session = request.getSession();
		CustomInfo info = (CustomInfo)session.getAttribute("customInfo");
		int result = 1;
		
		if(info!=null && info.getSessionId().equals("admin")) {
			result = 0;
			session.getId();
		}

	
		//dto의 get로 만들경우 readData할 때 dto가 초기화되므로 매개변수 값 받고 진행 
		String cp = request.getContextPath();
		String pageNum = request.getParameter("pageNum");
		String searchValue = request.getParameter("searchValue");
		String searchValue2 = request.getParameter("searchValue2");
		String searchKey = "qnaType";
		
		//검색값 없을 경우
		if(searchValue == null || searchValue2 == null) {
			searchKey = "qnaType";
			searchValue = "";
			searchValue2 = "";
		}
		
		//검색값 있을 경우 한글디코딩
		if(request.getMethod().equalsIgnoreCase("GET")){
			searchValue = URLDecoder.decode(searchValue,"UTF-8");
			searchValue2 = URLDecoder.decode(searchValue2,"UTF-8");
		}
		
		
		//페이징
		int currentPage = 1;
		int numPerPage = 6;
		
		// Q&A 데이터 갯수 가져오기
		int dataCount = dao.getQnaDataCount(searchKey,searchValue,searchValue2);
		
		if(pageNum != null)
			currentPage = Integer.parseInt(pageNum);
		
		int totalPage = myUtil.getPageCount(numPerPage, dataCount);
		
		if(currentPage > totalPage)
			currentPage = totalPage;
		
		int start = (currentPage-1)*numPerPage+1;
		int end = currentPage*numPerPage;
		
		//검색 + 한페이지에 뿌릴 qna객체 리스트
		List<QnaDTO> lists = dao.getQnaList(start, end,searchKey,searchValue, searchValue2);
		
		//listNum
		int n=0;
		int listNum=0;
		Iterator<QnaDTO> it = lists.iterator();
		while(it.hasNext()) {
			QnaDTO data = (QnaDTO)it.next();
			listNum = dataCount - (start + n - 1);
			data.setListNum(listNum);
			n++;
		}
		
		//주소
		String params = "";
		String listUrl = "";
		String articleUrl = "";
		
		if(!searchValue.equals("") || !searchValue2.equals("")) {
			searchValue = URLEncoder.encode(searchValue,"UTF-8");
			searchValue2 = URLEncoder.encode(searchValue2,"UTF-8");
			params = "searchKey=" + searchKey + "&searchValue=" + searchValue+
			"&searchValue2=" + searchValue2;
			}
		
		if(params.equals("")) {
			listUrl = cp + "/qnaList.action";
			articleUrl = cp + "/qnaArticle.action?pageNum=" + currentPage;
		}else {
			listUrl = cp + "/qnaList.action?" + params;
			articleUrl = cp + "/qnaArticle.action?pageNum=" + currentPage + "&" + params;
		}
		
		String pageIndexList = myUtil.pageIndexList(currentPage, totalPage, listUrl);
	
		
		request.setAttribute("result",result);
		request.setAttribute("lists", lists);
		request.setAttribute("pageIndexList",pageIndexList);
		request.setAttribute("pageNum",pageNum);
		request.setAttribute("dataCount",dataCount);
		request.setAttribute("articleUrl",articleUrl);
		request.setAttribute("params", params);
		session.setAttribute("customInfo", info);
		
		return "qna/qnaList";
	}
	
	
	//질문게시판 작성 페이지로 이동
	@RequestMapping(value="/qnaCreated.action",method = {RequestMethod.GET,RequestMethod.POST})
	public String qnaCreated(HttpServletRequest request,QnaDTO dto) throws Exception{
		
		//로그인 유지하기 위해 세션 생성
		HttpSession session = request.getSession();
		CustomInfo info = (CustomInfo)session.getAttribute("customInfo");
		String cusId = info.getSessionId();
		
		
		//maxNum 을 불러와서 +1해서 dto에 집어넣은 뒤 보내기
		int qnaNumMax = dao.getQnaMaxNum();
		dto.setQnaNum(qnaNumMax+1);
		dto.setCusId(cusId);
		
		String searchKey="qnaType";
		String searchValue="";
		String searchValue2="";

		int listNumMax = dao.getQnaDataCount(searchKey, searchValue,searchValue2);
		dto.setListNum(listNumMax+1);
		
		request.setAttribute("dto", dto);
		request.setAttribute("mode", "insert");
		
		return "qna/qnaCreated";
		
	}
	
	//질문게시판 작성 삽입 처리
	@RequestMapping(value="/qnaCreated_ok.action",method = {RequestMethod.GET,RequestMethod.POST})
	public String qnaCreated_ok(HttpServletRequest request,QnaDTO dto) throws Exception{
		
		//로그인 유지하기 위해 세션 생성
		HttpSession session = request.getSession();
		CustomInfo info = (CustomInfo)session.getAttribute("customInfo");
		String cusId = info.getSessionId();
		
		//maxNum 을 불러와서 +1해서 dto에 집어넣은 뒤 보내기
		int qnaNumMax = dao.getQnaMaxNum();
		dto.setQnaNum(qnaNumMax + 1);
		
		//"admin" 대신 cusId를 넣었다.
		dto.setCusId(cusId);
		
		//처음 생성할 때는 다 0으로 설정
		dto.setQnaDepth(0);
		dto.setQnaOrderNo(0);
		dto.setQnaParent(0);
		
		//처음 생성할 때는 qnaNum을 그대로 넣는다.
		dto.setQnaGroupNum(dto.getQnaNum());
		
		//insert
		dao.insertQna(dto);
		return "redirect:/qnaList.action";
		
	}	
	
	//질문게시글 페이지로 이동
	@RequestMapping(value="/qnaArticle.action",method = {RequestMethod.GET,RequestMethod.POST})
	public String qnaArticle(HttpServletRequest request,QnaDTO dto,HttpSession session) throws Exception{
		
		//사용값 불러오기
		int qnaNum = Integer.parseInt(request.getParameter("qnaNum"));
		String pageNum = request.getParameter("pageNum");
		
		session = request.getSession();
		CustomInfo info = (CustomInfo)session.getAttribute("customInfo");
		
		int result=1;
		
		if(info!=null && info.getSessionId().equals("admin")) {
			result = 0;
			session.getId();
		}
		
		//searchKey는 qnaType으로 고정
		String searchKey = "qnaType";
		String searchValue = request.getParameter("searchValue");
		String searchValue2 = request.getParameter("searchValue2");
		
		//에러방지
		int groupNum = 0;
		String orderNo = request.getParameter("orderNo");
		
		if(searchValue==null) {
			searchKey = "qnaType";
			searchValue = "";
		}
		
		//검색값 없을 경우
	    if(searchValue2 == null) {
	         searchValue2 = "";
	    }
	    
		//검색값 인코딩
		if(request.getMethod().equalsIgnoreCase("GET")) {
			searchValue = URLDecoder.decode(searchValue,"UTF-8");
			searchValue2 = URLDecoder.decode(searchValue2,"UTF-8");
		}
		
		//qna 객체 가져오기
		dto = (QnaDTO)dao.getQnaReadData(qnaNum);
		if(dto == null) {
			return "redirect:/qnaList.action";
		}
		
		//줄바꿈
		dto.setQnaContent(dto.getQnaContent().replaceAll("\r\n", "<br/>"));
		
		//이전글
		QnaDTO preReadData = (QnaDTO)dao.getQnaPreReadData(qnaNum,searchKey,searchValue,searchValue2,groupNum,orderNo);
		int preQnaNum = 0;
		String preQnaTitle = "";
		if(preReadData!=null) {
			preQnaNum = preReadData.getQnaNum();
			preQnaTitle = preReadData.getQnaTitle();
		}
		
		//다음글
		QnaDTO nextReadData = (QnaDTO)dao.getQnaNextReadData(qnaNum,searchKey,searchValue,searchValue2,groupNum,orderNo);
		int nextQnaNum = 0;
		String nextQnaTitle = "";
		if(nextReadData!=null) {
			nextQnaNum = nextReadData.getQnaNum();
			nextQnaTitle = nextReadData.getQnaTitle();
		}
		
		//파람 생성
		String params = "pageNum=" +pageNum;
		if(!searchValue.equals("") || !searchValue2.equals("")) {
			searchValue = URLEncoder.encode(searchValue,"UTF-8");
			searchValue2 = URLEncoder.encode(searchValue2,"UTF-8");
			params += "&searchKey=" + searchKey + "&searchValue=" + searchValue + "&searchValue2=" + searchValue2; 
		}
		
		request.setAttribute("result", result);
		request.setAttribute("dto", dto);
		request.setAttribute("preQnaNum", preQnaNum);
		request.setAttribute("preQnaTitle", preQnaTitle);
		request.setAttribute("nextQnaNum", nextQnaNum);
		request.setAttribute("nextQnaTitle", nextQnaTitle);
		request.setAttribute("pageNum", pageNum);
		request.setAttribute("params", params);
		request.setAttribute("info", info);
		if(info!=null)
			request.setAttribute("cusId", info.getSessionId());
		
		return "qna/qnaArticle";
	}
	
	//질문게시판 수정페이지로 이동
	@RequestMapping(value="/qnaUpdated.action",method = {RequestMethod.GET,RequestMethod.POST})
	public String qnaUpdate(HttpServletRequest request,QnaDTO dto) throws Exception{
		
		
		//넘어오는 값
		int qnaNum = Integer.parseInt(request.getParameter("qnaNum"));
		String pageNum = request.getParameter("pageNum");
		
		//수정할 객체 가져옴
		dto = (QnaDTO)dao.getQnaReadData(qnaNum);
		if(dto==null) {
			return "redirect:/qnaList.action?pageNum=" + pageNum;
		}
		
		String searchKey="qnaType";
		String searchValue="";
		String searchValue2="";

		int listNumMax = dao.getQnaDataCount(searchKey, searchValue,searchValue2);
		dto.setListNum(listNumMax+1);
		
		request.setAttribute("mode", "update");
		request.setAttribute("pageNum", pageNum);
		request.setAttribute("dto", dto);
		
		return "qna/qnaCreated";
	}
	
	//질문게시판 수정 처리
	@RequestMapping(value="/qnaUpdated_ok.action",method = {RequestMethod.GET,RequestMethod.POST})
	public String qnaUpdated_ok(QnaDTO dto,HttpServletRequest request) throws Exception{

		//수정 후 리스트로 돌아가기
		String pageNum = request.getParameter("pageNum");
		dao.updateQnaData(dto);
		return "redirect:/qnaList.action?pageNum="+pageNum;
	}	
	
	//질문게시판 삭제
	@RequestMapping(value="/qnaDeleted.action",method = {RequestMethod.GET,RequestMethod.POST})
	public String qnaDeleted(HttpServletRequest request) throws Exception{
		
		//사용할 값 가져오기
		String pageNum = request.getParameter("pageNum");
		int qnaNum = Integer.parseInt(request.getParameter("qnaNum"));
		
		//삭제 후 리스트로 돌아가기
		dao.deleteQnaData(qnaNum);
		return "redirect:/qnaList.action?pageNum="+pageNum;
	}	
	
	//질문게시판 답글쓰기
	@RequestMapping(value="/qnaReply.action",method = {RequestMethod.GET,RequestMethod.POST})
	public String qnaReply(HttpServletRequest request,QnaDTO dto) throws Exception{
			
		//2개 값 가져오기
		String pageNum = request.getParameter("pageNum");
		int qnaNum = Integer.parseInt(request.getParameter("qnaNum"));
		
		//qnaNum에 일치하는 데이터 가져오기
		dto = (QnaDTO)dao.getQnaReadData(qnaNum);
		
		//답변 구분
		String temp = "\r\n\r\n----------------------------------------\r\n\r\n";
		temp += "Re: \r\n";
		
		String searchKey="qnaType";
		String searchValue="";
		String searchValue2="";

		int listNumMax = dao.getQnaDataCount(searchKey, searchValue,searchValue2);
		dto.setListNum(listNumMax+1);
		
		//dto에 제목,내용을 넣는다.(위의 temp도 함께)
		dto.setQnaTitle("Re: " + dto.getQnaTitle());
		dto.setQnaContent(dto.getQnaContent() + temp);
		
		request.setAttribute("mode", "reply");	
		request.setAttribute("dto", dto);
		request.setAttribute("pageNum", pageNum);
		return "qna/qnaCreated";
		
		
	}

	//질문게시판 답변처리
	@RequestMapping(value="/qnaReply_ok.action",method = {RequestMethod.GET,RequestMethod.POST})
	public String qnaReply_ok(HttpServletRequest request,QnaDTO dto) throws Exception{
			
			//값 가져오기
			String pageNum = request.getParameter("pageNum");
			int qnaGroupNum = Integer.parseInt(request.getParameter("qnaGroupNum"));
			int qnaOrderNo = Integer.parseInt(request.getParameter("qnaOrderNo"));
			
			//답변작성
			//orderNo 변경
			dao.orderNoUpdate(qnaGroupNum,qnaOrderNo);
			
			//관리자아이디는 admin
			dto.setCusId("admin");
			//답변입력
			dto.setQnaNum(dao.getQnaMaxNum() + 1);
			//답변이 밑에 달리도록
			dto.setQnaDepth(dto.getQnaDepth()+1);
			dto.setQnaOrderNo(dto.getQnaOrderNo() + 1);
			dao.insertQna(dto);
					
			return "redirect:/qnaList.action?pageNum="+pageNum;
			
			
		}
	
	
	
	//*******************채종완*******************
	
	//회원가입 유형 2가지 중 선택하는 페이지로 이동
	@RequestMapping(value = "/create.action")
	public String create() {
		return "create/create";
	}
	
	//개인 회원가입 페이지로 이동
	@RequestMapping(value = "/createCustomer.action", method = { RequestMethod.GET, RequestMethod.POST })
	public String createCustomer(HttpServletRequest request, HttpSession session) {
		//세션에 올라온값 받기
		CustomInfo info = (CustomInfo)session.getAttribute("customInfo");
		request.setAttribute("info", info);
		return "create/createCustomer";
	}
	
	//개인 회원가입 완료 (삽입)
	//@ResponseBody
	@RequestMapping(value = "/createCustomer_ok.action", method = {RequestMethod.GET,RequestMethod.POST})
	public String createCustomer_ok(HttpServletRequest request,CustomerDTO dto,
			HttpServletResponse response) throws Exception{
		
		//---------지번주소와 상세주소 이름 합치기---------
		
		String cusAddrJibun = request.getParameter("cusAddrJibun");
		String cusAddrDetail = request.getParameter("cusAddrDetail");
		
		dto.setCusAddr(cusAddrJibun);
		dto.setCusAddrDetail(cusAddrDetail);
		
		dao.cusCreated(dto);
		return "redirect:/login.action";
	}

	//체육관 회원가입 페이지로 이동
	@RequestMapping(value = "/createGym.action",method = { RequestMethod.GET, RequestMethod.POST })
	public String createGym(HttpServletRequest request, HttpSession session) {
		//세션에 올라온값 받기
		CustomInfo info = (CustomInfo)session.getAttribute("customInfo");
		request.setAttribute("info", info);
 		return "create/createGym";
	}
	
	//체육관 회원가입 완료 (삽입 + 파일업로드)
	//체육관 회원가입 완료 후 처리
	@RequestMapping(value = "/createGym_ok.action",method = {RequestMethod.GET,RequestMethod.POST})
	public String createGym_ok(HttpServletRequest request,GymDTO dto, HttpServletResponse response,
			String hidden1, MultipartHttpServletRequest multiReq, String str)throws Exception{
		
		//경로생성	
		/*
		 * String path = multiReq.getSession().getServletContext().getRealPath(
		 * "/resources/img/gymTrainerPic/");
		 */
		
		//이미지 path (Controller최상단 PATH)
		String gymTrainerPicImgPath = PATH + "gymTrainerPic\\";
		String gymPicImgPath = PATH + "gymPic\\";
		
		//---------트레이너 이름 합치기---------
		
		String gymTrainer1 = request.getParameter("gymTrainer1");
		String gymTrainer2 = request.getParameter("gymTrainer2");
		String gymTrainer3 = request.getParameter("gymTrainer3");
		String gymTrainer4 = request.getParameter("gymTrainer4");
		String gymTrainer = "";
		
		
		if(gymTrainer1!=null) {
			gymTrainer += gymTrainer1 + ",";
		}
		if(gymTrainer2!=null) {
			gymTrainer += gymTrainer2 + ",";
		}
		if(gymTrainer3!=null) {
			gymTrainer += gymTrainer3 + ",";
		}
		if(gymTrainer4!=null) {
			gymTrainer += gymTrainer4;
		}
		
		//마지막글자에,  <- 이거 빼기
		String lastWord = gymTrainer.substring(gymTrainer.length()-1, gymTrainer.length());
		
		//마지막 쉼표면, 쉼표 빼고 dto에 setting
		while(lastWord.equals(",")) {
			gymTrainer = gymTrainer.substring(0, gymTrainer.length()-1);
			lastWord = gymTrainer.substring(gymTrainer.length()-1, gymTrainer.length());//마지막 글자 다시 세팅
		}
		dto.setGymTrainer(gymTrainer);
	
		
		//---------트레이너 파일 합치기---------

		//파일 리스트 생성
		Iterator<String> files = multiReq.getFileNames();
		MultipartFile mfile = multiReq.getFile(files.next());
		
		//파일 용량 없음 검사
		if(mfile == null || mfile.getSize() <= 0) {
			System.out.println("파일용량 x"); //v파일 alert
			return "redirect:/";
		}
		
		//html의 upload 가져와서 파일 리스트 생성 (트레이너사진)
		List<MultipartFile> fileList = multiReq.getFiles("upload");
		String gymTrainerPic = "";
		String newFileName = ""; 
		
		//확장 for문으로 하나씩 처리
		for (MultipartFile fileShowOne : fileList) {
			try {
				if(!fileShowOne.getOriginalFilename().equals("")) { //파일 이름이 null이 아니면
					
					//로컬저장용 이름 생성
					newFileName = dto.getGymId() + "-" + fileShowOne.getOriginalFilename();
					
					//DB저장용 파일이름 합침 (아이디로 사진명 중복되지 않게) (예) suzi-트레이너1.jpg
					gymTrainerPic += newFileName + ",";
					
					//fs 생성 및 저장
					FileOutputStream fs = new FileOutputStream(gymTrainerPicImgPath + newFileName); 
					fs.write(fileShowOne.getBytes());
					fs.close();
				}
			} catch (Exception e) {
				e.toString();
			}
		}
		
		//마지막글자에   ,  <- 이거 빼기
		lastWord = gymTrainerPic.substring(gymTrainerPic.length()-1, gymTrainerPic.length());
				
		//마지막 쉼표면, 쉼표 빼고 dto에 setting
		while(lastWord.equals(",")) {
			gymTrainerPic = gymTrainerPic.substring(0, gymTrainerPic.length()-1);
			lastWord = gymTrainerPic.substring(gymTrainerPic.length()-1, gymTrainerPic.length());//마지막 글자 다시 세팅
		}
		
		
		//======체육관 사진 등록===========
				
		//html의 upload2 가져와서 파일 리스트 생성
				List<MultipartFile> fileList2 = multiReq.getFiles("upload2");
				String gymPic = "";
				String newFileGymName = ""; 
				
				//확장 for문으로 하나씩 처리
				for (MultipartFile fileShowOne : fileList2) {
					try {
						if(!fileShowOne.getOriginalFilename().equals("")) { //파일 이름이 null이 아니면
							
							//로컬저장용 이름 생성
							newFileGymName = dto.getGymId() + "-" + fileShowOne.getOriginalFilename();
							
							//DB저장용 파일이름 합침 (아이디로 사진명 중복되지 않게) (예) 곰돌이체육관-체육관1.jpg
							gymPic += newFileGymName + ",";
							
							//fs 생성 및 저장
							FileOutputStream fs = new FileOutputStream(gymPicImgPath + newFileGymName); 
							fs.write(fileShowOne.getBytes());
							fs.close();
						}
					} catch (Exception e) {
						e.toString();
					}
				}
		
		
				//마지막글자
				lastWord = gymPic.substring(gymPic.length()-1, gymPic.length());
						
				//마지막 쉼표면, 쉼표 빼고 dto에 setting
				while(lastWord.equals(",")) {
					gymPic = gymPic.substring(0, gymPic.length()-1);
					lastWord = gymPic.substring(gymPic.length()-1, gymPic.length());//마지막 글자 다시 세팅
				}
		
		//======체육관 시간 등록===========
				
		//GymHour 매장오픈시간 닫는시간 선택하는거 다 합쳐서 한 컬럼에 집어넣기
		String gymHour1_1 = request.getParameter("gymHour1_1");
		String gymHour1_2 = request.getParameter("gymHour1_2");
		
		String gymHour2_1 = request.getParameter("gymHour2_1");
		String gymHour2_2 = request.getParameter("gymHour2_2");
		
		String gymHour3_1 = request.getParameter("gymHour3_1");
		String gymHour3_2 = request.getParameter("gymHour3_2");
		
		String gymHour1 = gymHour1_1 + gymHour1_2;
		String gymHour2 = gymHour2_1 + gymHour2_2;
		String gymHour3 = gymHour3_1 + gymHour3_2;
		
		String gymHour = "";
		gymHour += gymHour1 + ",";
		gymHour += gymHour2 + ",";
		gymHour += gymHour3 ;
		
		//dto에 setting
		dto.setGymHour(gymHour);			
		dto.setGymTrainerPic(gymTrainerPic);
		dto.setGymPic(gymPic);

		//디비 삽입
		dao.gymCreated(dto);
        
 		return "redirect:/login.action";
			 	
	}
	
	/*
	//개인회원 아이디 중복체크
		@RequestMapping(value = "/cusidck", method = {RequestMethod.GET,RequestMethod.POST})
		public @ResponseBody String AjaxView(  
			        @RequestParam("cusId") String cusId){
			String str = "";
			//int idcheck = dbPro.idCheck(id);
			
			int idcheck = dao.cusidCheck(cusId);
			
			if(idcheck==1){ //이미 존재하는 계정
				str = "NO";	
			}else{	//사용 가능한 계정
				str = "YES";	
			}
			return str;
		}
		
		*/
	
	//개인 아이디 중복 체크
	@RequestMapping(value = "/cusIdck", method = RequestMethod.POST)
	public @ResponseBody String AjaxView(  
			        @RequestParam("cusId") String cusId){
			String str = "";
			int idcheck = dao.cusidCheck(cusId);
			if(idcheck==1){ //이미 존재하는 계정
				str = "NO";	
			}else{	//사용 가능한 계정
				str = "YES";	
			}
			return str;
		}

	//체육관회원 아이디 중복체크
	@RequestMapping(value = "/gymIdck", method = RequestMethod.POST)
	public @ResponseBody String AjaxView2(  
			        @RequestParam("gymId") String gymId){
			String str = "";
			
			//int idcheck = dbPro.idCheck(id);
			
			int idcheck = dao.gymidCheck(gymId);
			
			if(idcheck==1){ //이미 존재하는 계정
				str = "NO";	
			}else{	//사용 가능한 계정
				str = "YES";	
			}
			return str;
		}
		
	//개인회원 전화번호 중복체크
	@RequestMapping(value = "/cusTelck", method = RequestMethod.POST)
	public @ResponseBody String AjaxView3(  
			        @RequestParam("cusTel") String cusTel){
			String str = "";
			
			//int idcheck = dbPro.idCheck(id);
			
			int telcheck = dao.custelCheck(cusTel);
			
			if(telcheck==1){ //이미 존재하는 계정
				str = "NO";	
			}else{	//사용 가능한 계정
				str = "YES";	
			}
			return str;
		}
	
	//체육관회원 전화번호 중복체크
	@RequestMapping(value = "/gymTelck", method = RequestMethod.POST)
	public @ResponseBody String AjaxView4(  
					      @RequestParam("gymTel") String gymTel){
			String str = "";
					
			//int idcheck = dbPro.idCheck(id);
					
			int telcheck = dao.gymtelCheck(gymTel);
					
			if(telcheck==1){ //이미 존재하는 계정
				str = "NO";	
			}else{	//사용 가능한 계정
				str = "YES";	
			}
			return str;
		}	
	
	
	//*******************경기민*******************
	
	//제휴시설 찾기로 이동 (첫화면만)
	@RequestMapping(value = "/map.action", method = { RequestMethod.GET, RequestMethod.POST })
	public String map(HttpServletRequest req) throws Exception {
		
		CustomInfo customInfo = null;
		String sessionId = "";
		String loginType = "";
		String cusAddrGoo = "";
		HttpSession httpSession = req.getSession(true);		
		if(httpSession.getAttribute("customInfo")!=null) {
			customInfo = (CustomInfo)httpSession.getAttribute("customInfo");
			sessionId = customInfo.getSessionId();
			loginType = customInfo.getLoginType();
			CustomerDTO dto = dao.getCustomerGoo(sessionId);
			if(dto != null) {
	               cusAddrGoo = dto.getCusAddr();
	            }
		}
		String searchKey = "gymName";
		String searchValue = "";
		if(req.getParameter("searchKey")!=null) {
			searchKey = req.getParameter("searchKey");
		}
		if(req.getParameter("searchValue")!=null) {
			searchValue = req.getParameter("searchValue");
		}
		
		//체육관 리스트
		List<GymDTO> lists = dao.getMapList(1, 10000, searchKey, searchValue);
		
		//체육관 이미지
		for(GymDTO eachGym : lists) {
			List<String> subPic = new ArrayList<String>(Arrays.asList(eachGym.getGymPic().split(",")));
			eachGym.setGymPicAryList(subPic);
		}
		
		req.setAttribute("lists", lists);
		req.setAttribute("tempSearchKey", searchKey);
		req.setAttribute("tempSearchValue", searchValue);
		req.setAttribute("mode", "print");
		req.setAttribute("loginType", loginType);
		req.setAttribute("sessionId", sessionId);
		req.setAttribute("cusAddrGoo", cusAddrGoo);
		
		return "map/map";
	}

	//페이징 처리 + 제휴시설 리스트 가져오기
	@RequestMapping(value = "/mapSearchList.action", method = { RequestMethod.GET, RequestMethod.POST })
	public String mapSearchList(HttpServletRequest req) throws Exception {
		
		CustomInfo customInfo = null;
		String loginType = "";
		HttpSession httpSession = req.getSession(true);		
		if(httpSession.getAttribute("customInfo")!=null) {
			customInfo = (CustomInfo)httpSession.getAttribute("customInfo");
			loginType = customInfo.getLoginType();
		}
		
		String cp = req.getContextPath();

		String searchGymAddr = req.getParameter("searchGymAddr");
		String pageNum = req.getParameter("pageNum");
		int currentPage = 1;

		if (pageNum != null) {
			currentPage = Integer.parseInt(pageNum);
		} else {
			pageNum = "1";
		}
		String searchKey = req.getParameter("searchKey");
		String searchValue = req.getParameter("searchValue");
		if (searchKey == null) {
			searchKey = "gymName";
			searchValue = "";
		} else {
			if (req.getMethod().equalsIgnoreCase("GET")) {
				searchValue = URLDecoder.decode(searchValue, "UTF-8");
				searchGymAddr = URLDecoder.decode(searchGymAddr, "UTF-8");
			}
		}
		
		// 검색한 조건의 데이터 갯수
		int dataCount = dao.getMapDataCount(searchKey, searchValue);

		// 페이징
		int numPerPage = 4;
		int totalPage = myUtilMap.getPageCount(numPerPage, dataCount);

		if (currentPage > totalPage) {
			currentPage = totalPage;
		}
		int start = (currentPage - 1) * numPerPage + 1;
		int end = currentPage * numPerPage;
		
		List<GymDTO> lists = dao.getMapList(start, end, searchKey, searchValue);
		Iterator<GymDTO> iterator = lists.iterator();
		while (iterator.hasNext()) {
			GymDTO dto = iterator.next();
			String[] hour = dto.getGymHour().split(",");
			String open = "평일 : " + hour[0] + ", 토요일 :" + hour[1] + ", 일요일 : " + hour[2];
			dto.setGymHour(open);
		}
		// URL
		String param = "";
		if (!searchValue.equals("")) {
			param = "searchKey=" + searchKey;
			param += "&searchValue=" + URLEncoder.encode(searchValue, "UTF-8");
		}

		String ajaxPageIndexList = myUtilMap.ajaxPageIndexList(currentPage, totalPage, searchKey, searchValue);
		//
		String searchGymAddrUrl = cp + "/map.action?searchGymAddr=";
		
		
		req.setAttribute("loginType", loginType);
		req.setAttribute("searchGymAddr", searchGymAddr);
		req.setAttribute("lists", lists);
		req.setAttribute("ajaxPageIndexList", ajaxPageIndexList);
		req.setAttribute("param", param);
		req.setAttribute("searchGymAddrUrl", searchGymAddrUrl);
		req.setAttribute("dataCount", dataCount);
		req.setAttribute("searchValue", searchValue);
		
		return "map/mapList";

	}
	
	//지도만 불러오기 (리다이렉트) (새로고침)
	@RequestMapping(value = "/mapReload.action", method = {RequestMethod.GET})
	public String mapReload() throws Exception {
		return "redirect:map.action";
	}
	
	//지도만 불러오기 (뷰로 이동) (검색결과가 있을때)
	@RequestMapping(value = "/mapReload.action", method = {RequestMethod.POST })
	public String mapReload(HttpServletRequest req) throws Exception {
		CustomInfo customInfo = null;
		String sessionId = "";
		String loginType = "";
		String cusAddrGoo = "";
		HttpSession httpSession = req.getSession(true);		
		if(httpSession.getAttribute("customInfo")!=null) {
			customInfo = (CustomInfo)httpSession.getAttribute("customInfo");
			sessionId = customInfo.getSessionId();
			loginType = customInfo.getLoginType();
			CustomerDTO dto = dao.getCustomerGoo(sessionId);
				if(dto != null) {
					cusAddrGoo = dto.getCusAddr();
				}
		}
		String searchKey = req.getParameter("searchKey");
		String searchValue = req.getParameter("searchValue");
		if(searchValue.equals("")) {
			searchKey = "gymName";
		}
		
		//체육관리스트
		List<GymDTO> lists = dao.getMapList(1, 10000, searchKey, searchValue);
		
		//체육관 이미지
		for(GymDTO eachGym : lists) {
			List<String> subPic = new ArrayList<String>(Arrays.asList(eachGym.getGymPic().split(",")));
			eachGym.setGymPicAryList(subPic);
		}
		
		req.setAttribute("searchKey", searchKey);
		req.setAttribute("searchValue", searchValue);
		req.setAttribute("sessionId", sessionId);
		req.setAttribute("loginType", loginType);
		req.setAttribute("cusAddrGoo", cusAddrGoo);
		req.setAttribute("lists", lists);
		req.setAttribute("tempSearchKey", searchKey);
		req.setAttribute("tempSearchValue", searchValue);
		req.setAttribute("mode", "map");
		
		return "map/map";

	}
	
	//검색어 제시 (자동완성)
	@RequestMapping(value = "/map_ok.action", method = { RequestMethod.GET, RequestMethod.POST})
	public String map_ok(HttpServletRequest req) throws Exception {

		String cp = req.getContextPath();
		String[] gymName = null;
		String[] gymAddr = null;
		String[] gymType = null;

		String searchKey = req.getParameter("searchKey");
		String searchValue = req.getParameter("searchValue");
		if (req.getMethod().equalsIgnoreCase("GET")) {
			searchValue = URLDecoder.decode(searchValue, "UTF-8");
		}

		if (searchKey.equals("gymName")) {
			List<GymDTO> lists = dao.getSearchName(1, 5, searchValue);
			gymName = new String[lists.size()];
			int n = 0;
			Iterator<GymDTO> iterator = lists.iterator();
			while (iterator.hasNext()) {
				GymDTO dto = iterator.next();
				gymName[n] = dto.getGymName();
				n++;
			}
			req.setAttribute("gymName", gymName);
		} else if (searchKey.equals("gymAddr")) {
			List<GymDTO> lists = dao.getSearchGoo(1, 5, searchValue);
			gymAddr = new String[lists.size()];
			int n = 0;
			Iterator<GymDTO> iterator = lists.iterator();
			while (iterator.hasNext()) {
				GymDTO dto = iterator.next();
				gymAddr[n] = dto.getGymAddr();
				n++;
			}
			req.setAttribute("gymAddr", gymAddr);
		} else if (searchKey.equals("gymType")) {
			List<GymDTO> lists = dao.getSearchType(1, 5, searchValue);
			gymType = new String[lists.size()];
			int n = 0;
			Iterator<GymDTO> iterator = lists.iterator();
			while (iterator.hasNext()) {
				GymDTO dto = iterator.next();
				gymType[n] = dto.getGymType();
				n++;
			}
			req.setAttribute("gymType", gymType);
		}

		return "map/map_ok";
	}
	
	//수업링크 나올 화면
	@RequestMapping(value = "/faceLink.action", method = { RequestMethod.GET, RequestMethod.POST })
	public String faceLink(HttpServletRequest req) throws Exception {

		CustomInfo info=null;
		BookDTO dto=null;
		HttpSession httpSession = req.getSession(true);		
		if(httpSession.getAttribute("customInfo")==null) {
			return "login/login";
		}else {
			info = (CustomInfo)httpSession.getAttribute("customInfo");
		}
		dto = dao.getOnlineBookSearch(info);
			
		req.setAttribute("dto", dto);
			
		return "faceLink/faceLink";
	}
	
	//예약확인 스레드
	public void startBookCheck() throws InterruptedException {
		asyncTaskSample.logger(this.dao);
	}
	
	
	//*******************최보경*******************
	
	//관리자 페이지로 이동
	@RequestMapping(value = "/adminHome.action", method = { RequestMethod.GET, RequestMethod.POST })
	public String adminHome(HttpServletRequest request, HttpSession session) {
		
		//세션에 올라온값 받기
		CustomInfo info = (CustomInfo)session.getAttribute("customInfo");
		request.setAttribute("info", info);
		return "admin/adminHome";
	}
	
	
	//관리자가 일반회원 강제 탈퇴
	@RequestMapping(value = "/customerDeleted_ok_admin.action", method = { RequestMethod.GET, RequestMethod.POST })
	public String customerDeleted_ok_admin(HttpServletRequest request, CustomerDTO dto, HttpSession session,
			HttpServletResponse response) throws IOException {

		dao.deleteData(dto);

		// 임시 회원탈퇴시 로그인창으로 넘어가기
		return "redirect:adminCustomerList.action";
	}

	
	//체육관(매장) 리스트
	@RequestMapping(value = "/adminGymList.action", method = { RequestMethod.GET, RequestMethod.POST })
	public String gymList(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {
		String cp = request.getContextPath();

		String pageNum = request.getParameter("pageNum");
		int currentPage = 1;

		if (pageNum != null)
			currentPage = Integer.parseInt(pageNum);

		String searchKey = request.getParameter("searchKey");
		String searchValue = request.getParameter("searchValue");

		if (searchKey == null) {//아무것도 없이 검색만 눌럿을떄
			searchKey = "gymName";
			searchValue = "";

		} else {
			if (request.getMethod().equalsIgnoreCase("GET"))
				searchValue = URLDecoder.decode(searchValue, "UTF-8");
		}

		//페이징처리
		int dataCount = dao.gymGetDataCount(searchKey, searchValue);
		int numPerPage = 10;
		int totalPage = myUtil.getPageCount(numPerPage, dataCount);

		if (currentPage > totalPage)
			currentPage = totalPage;

		int start = (currentPage - 1) * numPerPage + 1;
		int end = currentPage * numPerPage;

		//사진컬럼 ,구분 배열처리
		List<GymDTO> lists =
				dao.gymGetList(start, end, searchKey, searchValue);
		
		Iterator<GymDTO> itrT = lists.iterator();
		GymDTO dto;
		
		while( itrT.hasNext() ) {
			dto = itrT.next();
			
			dto.setGymTrainerAry(dto.getGymTrainer().split(",")); 
			dto.setGymTrainerPicAry(dto.getGymTrainerPic().split(","));
			dto.setGymPicAry(dto.getGymPic().split(","));
			dto.setGymFacilityAry(dto.getGymFacility().split(","));
			
		}
		
		List<GymDTO> falselists =
				dao.gymGetFalseList();
		
		Iterator<GymDTO> itr = falselists.iterator();
		
		//GymDTO dto;
		
		while( itr.hasNext() ) {
			dto = itr.next();
			dto.setGymTrainerAry(dto.getGymTrainer().split(",")); 
			dto.setGymTrainerPicAry(dto.getGymTrainerPic().split(","));
			dto.setGymPicAry(dto.getGymPic().split(","));
			dto.setGymFacilityAry(dto.getGymFacility().split(","));
			
		}
		
		//param 생성
		String param = "";
		if (!searchValue.equals("")) {
			param = "searchKey=" + searchKey;
			param += "&searchValue=" + URLEncoder.encode(searchValue, "UTF-8");
		}

		String listUrl = cp + "/adminGymList.action";

		if (!param.equals("")) {
			listUrl = listUrl + "?" + param;
		}

		String pageIndexList =

				myUtil.pageIndexList(currentPage, totalPage, listUrl);

		//이미지
		String imgPath = "/gyp/sfiles";

		//request set
		request.setAttribute("lists", lists);
		request.setAttribute("falselists", falselists);
		request.setAttribute("pageIndexList", pageIndexList);
		request.setAttribute("dataCount", dataCount);
		request.setAttribute("pageNum", pageNum);
		request.setAttribute("imgPath", imgPath);
		return "admin/adminGymList";

	}

	//체육관 gymOk false -> true
	@RequestMapping(value = "/adminGymUpdated_ok.action",
			method = { RequestMethod.GET, RequestMethod.POST})
	public String adminGymUpdated_ok(GymDTO dto ,HttpServletRequest request, HttpServletResponse response) throws Exception {

		String pageNum = request.getParameter("pageNum");
		String gymId = request.getParameter("gymId");
		
		dao.gymUpdateData(dto);

		return "redirect:/adminGymList.action";

	}

	//매장 리스트 삭제 gymOk false 거절용
	@RequestMapping(value = "/adminGymDeleted.action",
			method = { RequestMethod.GET, RequestMethod.POST })
	public String gymDeleted(HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		String pageNum = request.getParameter("pageNum");
		String str = request.getParameter("gymId");

		dao.gymDeleteData(str);

		return "redirect:/adminGymList.action";

	}

	//회원 리스트
	@RequestMapping(value = "/adminCustomerList.action", method = { RequestMethod.GET, RequestMethod.POST })
	public String customerList(HttpServletRequest request, HttpServletResponse response) throws Exception {

		String cp = request.getContextPath();
		String pageNum = request.getParameter("pageNum");
		int currentPage = 1;

		if (pageNum != null)
			currentPage = Integer.parseInt(pageNum);

		String searchKey = request.getParameter("searchKey");
		String searchValue = request.getParameter("searchValue");

		if (searchKey == null) {//아무것도 없이 검색만 눌럿을떄
			searchKey = "cusId";
			searchValue = "";

		} else {
			if (request.getMethod().equalsIgnoreCase("GET"))
				searchValue = URLDecoder.decode(searchValue, "UTF-8");
		}

		//페이징 처리
		int dataCount = dao.customerGetDataCount(searchKey, searchValue);
		int numPerPage = 10;
		int totalPage = myUtil.getPageCount(numPerPage, dataCount);

		if (currentPage > totalPage)
			currentPage = totalPage;

		int start = (currentPage - 1) * numPerPage + 1;
		int end = currentPage * numPerPage;

		List<CustomerDTO> lists = dao.customerGetList(start, end, searchKey, searchValue);

		//파람 생성
		String param = "";
		if (!searchValue.equals("")) {

			param = "searchKey=" + searchKey;
			param += "&searchValue=" + URLEncoder.encode(searchValue, "UTF-8");

		}

		String listUrl = cp + "/adminCustomerList.action";

		if (!param.equals("")) {
			listUrl = listUrl + "?" + param;
		}

		String pageIndexList = myUtil.pageIndexList(currentPage, totalPage, listUrl);

		//request set
		request.setAttribute("lists", lists);
		request.setAttribute("pageIndexList", pageIndexList);
		request.setAttribute("dataCount", dataCount);
		request.setAttribute("pageNum", pageNum);

		return "admin/adminCustomerList";

	}

	//상품 리스트
	@RequestMapping(value = "/adminProductList.action", method = { RequestMethod.GET, RequestMethod.POST })
	public String productList(HttpServletRequest request, HttpServletResponse response) throws Exception {

		String cp = request.getContextPath();
		String pageNum = request.getParameter("pageNum");
		String searchKey = request.getParameter("searchKey");
		String searchValue = request.getParameter("searchValue");
		int currentPage = 1;

		if (pageNum != null && !pageNum.equals(""))
			currentPage = Integer.parseInt(pageNum);

		if (searchValue == null) {//아무것도 없이 검색만 눌럿을떄
			searchKey = "productId";
			searchValue = "";

		} else {//검색을 했을 경우 디코딩
			if (request.getMethod().equalsIgnoreCase("GET"))
				searchValue = URLDecoder.decode(searchValue, "UTF-8");
		}

		//페이징 처리
		int dataCount = dao.productGetDataCount(searchKey, searchValue);
		int numPerPage = 10;
		int totalPage = myUtil.getPageCount(numPerPage, dataCount);

		if (currentPage > totalPage)
			currentPage = totalPage;

		int start = (currentPage - 1) * numPerPage + 1;
		int end = currentPage * numPerPage;

		//한 페이지에 뿌릴 상품 리스트 가져오기
		List<ProductDTO> lists = dao.productGetList(start, end, searchKey, searchValue);

		//파람 생성
		String params = "";
		if (!searchValue.equals("")) {
			params = "&searchKey=" + searchKey;
			params += "&searchValue=" + URLEncoder.encode(searchValue, "UTF-8");
		}
		
		//pageIndexList생성
		String listUrl = cp + "/adminProductList.action";
		if (!params.equals("")) {
			listUrl = listUrl + "?" + params;
		}

		String pageIndexList = myUtil.pageIndexList(currentPage, totalPage, listUrl);
		
		//이미지 path
		String imgPath = "/gyp/sfiles/product/";

		//request set
		request.setAttribute("pageNum", currentPage);
		request.setAttribute("lists", lists);
		request.setAttribute("params", params);
		request.setAttribute("pageIndexList", pageIndexList);
		request.setAttribute("dataCount", dataCount);
		request.setAttribute("pageNum", pageNum);
		request.setAttribute("imgPath", imgPath);

		return "admin/adminProductList";
	}

	//상품 입력 페이지로 이동
	@RequestMapping(value = "/adminProductCreated.action", method = { RequestMethod.GET, RequestMethod.POST })
	public String productCreated(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		return "admin/adminProductCreated";
	}

	//상품 입력 (등록)
	@RequestMapping(value = "/adminProductCreated_ok.action", method = { RequestMethod.GET, RequestMethod.POST })
	public String created_ok(ProductDTO dto, HttpServletRequest request, 
			HttpServletResponse response, MultipartHttpServletRequest multiReq) throws Exception {
		
		//날짜생성용 객체
		Calendar cal = Calendar.getInstance();
		int year = cal.get(Calendar.YEAR);
		int month = cal.get(Calendar.MONTH) + 1;
		int day = cal.get(Calendar.DATE);
		int hour = cal.get(Calendar.HOUR_OF_DAY);
		int min = cal.get(Calendar.MINUTE);
		String nowTime = Integer.toString(year)
				+Integer.toString(month)
				+Integer.toString(day)
				+Integer.toString(hour)
				+Integer.toString(min);

		//이미지 path (Controller최상단 PATH)
		String imgPath = PATH + "product\\";
		
		//html의 productImg 가져와서 객체 생성
		MultipartFile upload = multiReq.getFile("upload");
		
		try {
			if(!upload.getOriginalFilename().equals("")) { //파일 이름이 null이 아니면
				
				//확장자 위치 구하기
				int dotStart = upload.getOriginalFilename().indexOf(".");
				
				//원래 파일이름_202007171530.jpg
				String newProductImgName = upload.getOriginalFilename().substring(0, dotStart) 
						+"_"+ nowTime + upload.getOriginalFilename().substring(dotStart);		
				
				//fs 생성 및 저장
				FileOutputStream fs = new FileOutputStream(imgPath + newProductImgName); 
				fs.write(upload.getBytes());
				fs.close();
				
				//dto에 덮어씌우기
				dto.setProductImg(newProductImgName);
			}
		} catch (Exception e) {
			e.toString();
		}
		
		//디비삽입
		dao.productInsertData(dto);
		
		return "redirect:/adminProductList.action";
	}

	//상품 수정 페이지로 이동
	@RequestMapping(value = "/adminProductUpdated.action",
			method = { RequestMethod.GET, RequestMethod.POST })
	public String productUpdated(HttpServletRequest request, HttpServletResponse response) throws Exception {

		String productId = request.getParameter("productId");
		String pageNum = request.getParameter("pageNum");
		String searchKey = request.getParameter("searchKey");
		String searchValue = request.getParameter("searchValue");
		String mode = "update";
		
		
		
		
		//상품 DTO 가져오기
		ProductDTO dto = dao.productGetReadData(productId);
		
		if (dto == null) {
			return "redirect:/adminProductList.action";
		}
		
		//기존 상품 이미지 이름
		String oldImageName = dto.getProductImg();
		
		//파람 생성
		String params = "";
		if (searchValue!=null) {
			params = "&searchKey=" + searchKey;
			params += "&searchValue=" + URLEncoder.encode(searchValue, "UTF-8");
		}
		
		request.setAttribute("pageNum", pageNum);
		request.setAttribute("params", params);
		request.setAttribute("oldImageName", oldImageName);
		request.setAttribute("mode", mode);
		request.setAttribute("dto", dto);
		request.setAttribute("pageNum", pageNum);

		return "admin/adminProductCreated";
	}

	//상품 수정 반영
	@RequestMapping(value = "/adminProductUpdated_ok.action",method = { RequestMethod.GET, RequestMethod.POST })
	public String productUpdated_ok(ProductDTO dto, HttpServletRequest request, 
			HttpServletResponse response, MultipartHttpServletRequest multiReq) throws Exception {
		
		String oldImageName = request.getParameter("oldImageName");
		
		//날짜생성용 객체
		Calendar cal = Calendar.getInstance();
		int year = cal.get(Calendar.YEAR);
		int month = cal.get(Calendar.MONTH) + 1;
		int day = cal.get(Calendar.DATE);
		int hour = cal.get(Calendar.HOUR_OF_DAY);
		int min = cal.get(Calendar.MINUTE);
		String nowTime = Integer.toString(year)
				+Integer.toString(month)
				+Integer.toString(day)
				+Integer.toString(hour)
				+Integer.toString(min);
		
		//이미지 path (Controller최상단 PATH)
		String imgPath = PATH + "product\\";
		
		//html의 productImg 가져와서 객체 생성
		MultipartFile upload = multiReq.getFile("upload");
		
		try {//파일 이름이 null이 아니면 (즉, 파일업로드가 존재하면)
			if(!upload.getOriginalFilename().equals("")) { 
				
				//확장자 위치 구하기
				int dotStart = upload.getOriginalFilename().indexOf(".");
				
				//원래 파일이름_202007171530.jpg
				String newProductImgName = upload.getOriginalFilename().substring(0, dotStart) 
						+"_"+ nowTime + upload.getOriginalFilename().substring(dotStart);		
				
				//fs 생성 및 저장
				FileOutputStream fs = new FileOutputStream(imgPath + newProductImgName); 
				fs.write(upload.getBytes());
				fs.close();
				
				//기존 파일 지우기
				File deleteImage = new File(imgPath + oldImageName);
				deleteImage.delete();
				
				
				//dto에 덮어씌우기
				dto.setProductImg(newProductImgName);
			}
		} catch (Exception e) {
			e.toString();
		}
		
		//수정
		dao.productUpdateData(dto);
		
		return "redirect:/adminProductList.action";
	}
	
	//상품 삭제
	@RequestMapping(value = "/adminProductDeleted.action",method = { RequestMethod.GET, RequestMethod.POST })
	public String productDeleted(HttpServletRequest request) throws Exception {
		
		String productId = request.getParameter("productId");
		dao.productDeleteData(productId);
		
		return "redirect:/adminProductList.action";
	}
}



























