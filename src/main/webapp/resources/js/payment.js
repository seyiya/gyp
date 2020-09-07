
/*------------------ 결제 api 사용 ------------------*/
    $(function(){
        var IMP = window.IMP;
        IMP.init('imp43882577'); // 가맹점 식별코드
        
        $("#buyit").click(function(){
           
           var check = validateUserInput();   // 사용자 입력 검사
           if(check!=false) {
               requestPay();   // 결제
           }
        });
        
        copyCusInfo();
    });
    
    //start up function requestPay
    function requestPay(){
       var msg;
       IMP.request_pay({
           pg : 'html5_inicis',
           pay_method : $("#payMethod").val(),
           merchant_uid : 'gypPayment_' + new Date().getTime(),
           name : $("#item").html(), //상품명
           amount : 100, //$("#amount").val(),
           buyer_name : realTimeValIn("#buyer_name"),   
           buyer_tel : realTimeValIn("#buyer_tel"),
           buyer_addr : realTimeValIn("#buyer_addr"),
           buyer_postcode : '123-456',
           card_quota : undefined,
           m_redirect_url: "/gyp/gymBook_ok.action"
       }, function(rsp) {
           if ( rsp.success ) {
           
             if($("#item").html().startsWith("pass_")) {
                var params = "item=" + $("#item").html() 
                       + "&payMethod=" + $("#payMethod").val();
             } else {
                var productIdArr = new Array();
                $("input[name=productIdArr]").each(function() {
                   productIdArr.push($(this).val());
                });
                
                var productCountArr = new Array();
                $("input[name=productCountArr]").each(function() {
                   productCountArr.push($(this).val());
                });
                
                var params = "item=" + $("#item").html() 
                       + "&amount=" + $("#amount").val()
                       + "&payMethod=" + $("#payMethod").val()
                       + "&receiver_name=" + $("#receiver_name").val()
                       + "&receiver_tel=" + $("#receiver_tel").val()
                       + "&receiver_addr=" + $("#sample6_address").val()+" "+ $("#detail_address").val()
                       + "&productIdArr=" + productIdArr
                       + "&productCountArr=" + productCountArr;
         	}
              
           jQuery.ajax({
            url: "/gyp/actualPayment.action",
            type: 'POST',
            dataType: 'json',
            data: {
              imp_uid: rsp.imp_uid,
             //기타 필요한 데이터가 있으면 추가 전달
                merchant_uid: rsp.merchant_uid,
                params
            }
           });
           
           window.location.replace("/gyp/payment_ok.action");
             
       } else {
           var msg = '결제에 실패하였습니다.';
           msg += '에러내용 : ' + rsp.error_msg;

           alert(msg);
       }
       
   });
    
  }//end of function requestPay

    
    /*--------- input값이 변할때마다 값 세팅하는 함수 ---------*/
    function realTimeValIn(inputId) {
       var result = $(inputId).val();
       $(inputId).on("propertychange change keyup paste input", function() {
            var realTimeVal = $(this).val();
            if(realTimeVal == result) {
                return;
            }
            result = realTimeVal;
        });
       return result;
    }

    /*--------- 사용자가 입력한 값을 검사하는 함수 ---------*/
    function validateUserInput() {
       
       var f = document.payForm;
       
       //전화번호 제약조건
       var cc3 = /^(01[016789]{1}|02|0[3-9]{1}[0-9]{1})-[0-9]{3,4}-[0-9]{4}$/;
       
       if($("#item").html().startsWith("pass_")) {
          
          if(!cc3.test(f.buyerTel.value)) {
             alert('전화번호를 바르게 입력하세요');
             f.buyerTel.focus();
             return false;
           }
          
       } else {
          if(!cc3.test(f.buyerTel.value)) {
             alert('전화번호를 바르게 입력하세요');
             f.buyerTel.focus();
             return false;
           }
           
           if(!f.receiverName.value){
             alert("이름을 입력하세요");
             f.receiverName.focus();
             return false; 
          }
           
           if(!cc3.test(f.receiverTel.value)) {
             alert('전화번호를 바르게 입력하세요');
             f.receiverTel.focus();
             return false;
           }
           
           if(!f.receiverAddr.value || !f.receiverDetailAddr.value) {
              alert("주소를 입력하세요");
              return false
           }
           
           if(f.receiverAddr.value) {
              $("#detail_address").disabled=false;
           }
       }
    }
    
    /*--------- 배송지 입력 라디오버튼 기능 ---------*/
    function copyCusInfo() {
       $("#receiver_name").val($("#buyer_name").val());
       $("#receiver_tel").val($("#buyer_tel").val());
       $("#sample6_address").val($("#buyer_addr").val());
       $("#detail_address").val($("#buyer_addr_detail").val());
    }
    
    function resetValue() {
       $("#receiver_name").val("");
       $("#receiver_tel").val("");
       $("#sample6_address").val("");
       $("#detail_address").val("");
    }
    
    /*--------- 주소지 api---------*/
   function sample6_execDaumPostcode() {
      new daum.Postcode({
          oncomplete: function(data) {
              // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

              // 각 주소의 노출 규칙에 따라 주소를 조합한다.
              // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
              var addr = ''; // 주소 변수

              //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
              if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                  addr = data.roadAddress;
              } else { // 사용자가 지번 주소를 선택했을 경우(J)
                 addr = data.roadAddress;
                  addr = data.jibunAddress;
              }

              // 우편번호와 주소 정보를 해당 필드에 넣는다.
              document.getElementById("sample6_address").value = addr;
              // 커서를 상세주소 필드로 이동한다.
            //  document.getElementById("sample6_detailAddress").focus();
          }
      }).open();
   }

    