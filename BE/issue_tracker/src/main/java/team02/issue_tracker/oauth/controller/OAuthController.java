package team02.issue_tracker.oauth.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import team02.issue_tracker.annotation.LogExecutionTime;
import team02.issue_tracker.dto.ApiResult;
import team02.issue_tracker.oauth.dto.JwtResponse;
import team02.issue_tracker.oauth.dto.SocialLogin;
import team02.issue_tracker.oauth.service.LoginService;

@Slf4j
@RequestMapping("/api")
@RestController
public class OAuthController {

    private final LoginService loginService;

    public OAuthController(LoginService loginService) {
        this.loginService = loginService;
    }

    @LogExecutionTime
    @GetMapping("/login/github/web")
    public ApiResult<JwtResponse> loginGithubWeb(@RequestParam("code") String code) {
        return ApiResult.success(loginService.login(code, SocialLogin.GITHUB_WEB));
    }

    @LogExecutionTime
    @GetMapping("/login/github/ios")
    public ApiResult<JwtResponse> loginGithubIos(@RequestParam("code") String code) {
        return ApiResult.success(loginService.login(code, SocialLogin.GITHUB_IOS));
    }

    @LogExecutionTime
    @GetMapping("/login/google")
    public ApiResult<JwtResponse> loginGoogle(@RequestParam("code") String code) {
        return ApiResult.success(loginService.login(code, SocialLogin.GOOGLE));
    }

    @LogExecutionTime
    @GetMapping("/login/kakao")
    public ApiResult<JwtResponse> loginKakao(@RequestParam("code") String code) {
        return ApiResult.success(loginService.login(code, SocialLogin.KAKAO));
    }

    @LogExecutionTime
    @GetMapping("/login/naver")
    public ApiResult<JwtResponse> loginNaver(@RequestParam("code") String code) {
        return ApiResult.success(loginService.login(code, SocialLogin.NAVER));
    }
}
