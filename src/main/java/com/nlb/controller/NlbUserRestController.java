package com.nlb.controller;

import com.nlb.dto.response.CMResDTO;
import com.nlb.service.EmailService;
import com.nlb.service.NlbUserService;
import com.nlb.util.PasswordUtil;
import com.nlb.vo.NlbUserVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.HttpRequestMethodNotSupportedException;
import org.springframework.web.bind.annotation.*;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping(value = "/api/users")
public class NlbUserRestController {

    @Autowired
    private NlbUserService nlbUserService;

    @Autowired
    private EmailService emailService;

    //회원 조회
    @RequestMapping(value = "/info/{userId}", method = RequestMethod.GET)
    public ResponseEntity<CMResDTO<NlbUserVO>> getUser(@PathVariable("userId") int userId) {

        NlbUserVO uvo = nlbUserService.getUser(userId);

        return new ResponseEntity<>(CMResDTO.successDataRes(uvo), HttpStatus.OK);
    }

    @RequestMapping(value = "/update", method = RequestMethod.PUT)
    public ResponseEntity<CMResDTO<String>> updateUser(@RequestBody NlbUserVO uvo) {

        int rows = nlbUserService.updateUser(uvo);


        return new ResponseEntity<>(CMResDTO.successNoRes(), HttpStatus.OK);
    }


    @RequestMapping(value = "/deactivate", method = RequestMethod.PUT)
    public ResponseEntity<CMResDTO<String>> setUserDeactivate(@RequestBody NlbUserVO uvo) {


        int rows = nlbUserService.setUserDeactivate(uvo);

        return new ResponseEntity<>(CMResDTO.successNoRes(), HttpStatus.OK);
    }

    // 아이디 중복 확인 API
    @GetMapping("/check-id")
    public ResponseEntity<CMResDTO<String>> checkUserId(@RequestParam("loginId") String loginId) {
        if (nlbUserService.isLoginIdExist(loginId)) {
            return new ResponseEntity<>(CMResDTO.errorWithMsgRes(null, "이미 존재하는 아이디"), HttpStatus.BAD_REQUEST);
        }
        return new ResponseEntity<>(CMResDTO.successNoRes(), HttpStatus.OK);
    }

    // 닉네임 중복 확인 API
    @GetMapping("/check-nickname")
    public ResponseEntity<CMResDTO<String>> checkNickname(@RequestParam("nickname") String nickname) {
        if (nlbUserService.isNicknameExist(nickname)) {
            return new ResponseEntity<>(CMResDTO.errorWithMsgRes(null, "이미 존재하는 닉네임"), HttpStatus.BAD_REQUEST);
        }
        return new ResponseEntity<>(CMResDTO.successNoRes(), HttpStatus.OK);
    }

    // 이메일 중복 확인 API
    @GetMapping("/check-email")
    public ResponseEntity<CMResDTO<String>> checkEmail(@RequestParam("email") String email) {
        if (nlbUserService.isEmailExist(email)) {
            return new ResponseEntity<>(CMResDTO.errorWithMsgRes(null, "이미 사용 중인 이메일입니다."), HttpStatus.BAD_REQUEST);
        }
        return new ResponseEntity<>(CMResDTO.successNoRes(), HttpStatus.OK);
    }

    // 회원가입 API
    @PostMapping("/register")
    public ResponseEntity<CMResDTO<String>> registerUser(@RequestBody NlbUserVO uvo) {
        try {
            int result = nlbUserService.registerUser(uvo);
            if (result > 0) {
                return ResponseEntity.status(HttpStatus.CREATED).body(CMResDTO.successDataRes("회원가입이 완료되었습니다."));
            } else {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(CMResDTO.errorWithMsgRes(null, "회원가입에 실패하였습니다. 다시 시도해주세요."));
            }
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(CMResDTO.errorWithMsgRes(null, "서버 오류 발생: " + e.getMessage()));
        }
    }


    @PostMapping("/send-email")
    public ResponseEntity<?> sendEmail(@RequestBody Map<String, String> request) {
        String email = request.get("email");

        if (nlbUserService.isEmailExist(email)) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                .body(Map.of("code", 400, "errorMessage", "이미 사용 중인 이메일입니다."));
        }

        try {
            emailService.sendEmailVerificationCode(email);
            return ResponseEntity.ok(Map.of(
                "code", 200,
                "message", "이메일 인증 코드가 전송되었습니다."
            ));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(Map.of("code", 500, "errorMessage", "이메일 인증 요청 실패."));
        }
    }

    @PostMapping("/verify-email")
    public ResponseEntity<?> verifyEmail(@RequestBody Map<String, String> request) {
        String email = request.get("email");
        String code = request.get("code");

        if (emailService.verifyEmailCode(email, code)) {
            return ResponseEntity.ok(Map.of(
                "code", 200,
                "message", "이메일 인증 성공."
            ));
        } else {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                .body(Map.of("code", 400, "errorMessage", "이메일 인증 실패. 코드가 유효하지 않습니다."));
        }
    }

    @PostMapping("/login")
    public ResponseEntity<CMResDTO<String>> login(@RequestBody Map<String, String> request, HttpSession session) {
        String loginId = request.get("loginId");
        String password = request.get("password");

        NlbUserVO user = nlbUserService.getUserByLoginId(loginId);
        if (user != null && PasswordUtil.checkPassword(password, user.getPassword())) {
            session.setAttribute("userId", user.getUserId());
            return new ResponseEntity<>(CMResDTO.successNoRes(), HttpStatus.OK);
        }
        return new ResponseEntity<>(CMResDTO.errorWithMsgRes(null, "아이디 또는 비밀번호가 올바르지 않습니다."), HttpStatus.BAD_REQUEST);
    }

}
