package com.exe.gyp;

import java.util.Iterator;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import com.exe.dao.GypDAO;
import com.exe.dto.BookDTO;
 
//스레드 상세 행동 클래스

@Service("asyncTaskSample")
public class AsyncTaskSample {
    
    @Async
    public void logger(GypDAO dao) throws InterruptedException {
        System.out.println("==============>>>>>>>>>>>> THREAD START");
        
        while(true) {
        	System.out.println("while start");
        	
        	//예약리스트 (예약시간 5분전인 리스트)
        	List<BookDTO> FiveBooklist = dao.getFiveBookIdList(); 
        	
        	//예약리스트 하나씩 꺼내서
        	//화상링크 생성 (아이디+예약시간+트레이너)
        	Iterator<BookDTO> iterator = FiveBooklist.iterator();
        	while(iterator.hasNext()) {
        		BookDTO dto = iterator.next();
        		String faceLink = dto.getCusId();
        		faceLink += dto.getBookHour();
        		faceLink += dto.getGymTrainerPick();
        		dao.setFaceLink(faceLink,dto.getBookNum());
        	}
        	
        	//예약리스트 (예약시간 1시간 후인 리스트) - 삭제
        	List<BookDTO> oneHourlist = dao.getOneHourIdList();
        	Iterator<BookDTO> iterator2 = oneHourlist.iterator();
        	while(iterator2.hasNext()) {
        		BookDTO dto = iterator2.next();
        		dao.delFaceLink(dto.getBookNum());
        	}
        	System.out.println("while end");
        	Thread.sleep(25000); //25초마다 반복
        }
    	
    }
    
}

