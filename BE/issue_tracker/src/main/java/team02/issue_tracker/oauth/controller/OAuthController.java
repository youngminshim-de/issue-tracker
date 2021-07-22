package team02.issue_tracker.oauth.controller;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;
import team02.issue_tracker.annotation.LogExecutionTime;
import team02.issue_tracker.dto.ApiResult;
import team02.issue_tracker.oauth.annotation.LoginRequired;
import team02.issue_tracker.oauth.annotation.UserId;
import team02.issue_tracker.oauth.dto.JwtResponse;
import team02.issue_tracker.oauth.dto.LoginRequestWithUserInfo;
import team02.issue_tracker.oauth.dto.SocialLogin;
import team02.issue_tracker.oauth.service.LoginService;

@Api(tags = {"소셜 로그인 API"}, description = "소셜 로그인을 처리합니다.")
@Slf4j
@RequestMapping("/api")
@RestController
public class OAuthController {

    private final LoginService loginService;

    public OAuthController(LoginService loginService) {
        this.loginService = loginService;
    }

    @ApiOperation(value = "깃헙 로그인 for WEB", notes = "전달 받은 인증 코드를 이 url로 보내주세요. (WEB 전용)")
    @LogExecutionTime
    @GetMapping("/login/github/web")
    public ApiResult<JwtResponse> loginGithubWeb(@ApiParam("인증 코드") @RequestParam("code") String code) {
        return ApiResult.success(loginService.loginWithCode(code, SocialLogin.GITHUB_WEB));
    }

    @ApiOperation(value = "깃헙 로그인 for iOS", notes = "전달 받은 인증 코드를 이 url로 보내주세요. (iOS 전용)")
    @LogExecutionTime
    @GetMapping("/login/github/ios")
    public ApiResult<JwtResponse> loginGithubIos(@ApiParam("인증 코드") @RequestParam("code") String code) {
        return ApiResult.success(loginService.loginWithCode(code, SocialLogin.GITHUB_IOS));
    }

    @ApiOperation(value = "구글 로그인 for WEB", notes = "전달 받은 인증 코드를 이 url로 보내주세요. (WEB 전용)")
    @LogExecutionTime
    @GetMapping("/login/google")
    public ApiResult<JwtResponse> loginGoogleWeb(@ApiParam("인증 코드") @RequestParam("code") String code) {
        return ApiResult.success(loginService.loginWithCode(code, SocialLogin.GOOGLE_WEB));
    }

    @ApiOperation(value = "구글 로그인 for iOS", notes = "로그인을 원하는 유저의 username, email" +
            ", profile_image를 json으로 보내주세요.(iOS)")
    @PostMapping("/login/google/ios")
    public ApiResult<JwtResponse> loginGoogleIos(
            @RequestBody LoginRequestWithUserInfo loginRequestWithUserInfo) {
        return ApiResult.success(loginService.loginWithUserInfo(loginRequestWithUserInfo,
                SocialLogin.GOOGLE));
    }

    @LogExecutionTime
    @GetMapping("/login/kakao")
    public ApiResult<JwtResponse> loginKakaoWeb(@RequestParam("code") String code) {
        return ApiResult.success(loginService.loginWithCode(code, SocialLogin.KAKAO_WEB));
    }

    @ApiOperation(value = "카카오 로그인 for iOS", notes = "로그인을 원하는 유저의 username, email" +
            ", profile_image를 json으로 보내주세요.(iOS)")
    @PostMapping("/login/kakao/ios")
    public ApiResult<JwtResponse> loginKakaoIos(
            @RequestBody LoginRequestWithUserInfo loginRequestWithUserInfo) {
        return ApiResult.success(loginService.loginWithUserInfo(loginRequestWithUserInfo,
                SocialLogin.KAKAO));
    }

    @LogExecutionTime
    @GetMapping("/login/naver")
    public ApiResult<JwtResponse> loginNaverWeb(@RequestParam("code") String code) {
        return ApiResult.success(loginService.loginWithCode(code, SocialLogin.NAVER_WEB));
    }

    @ApiOperation(value = "네이버 로그인 for iOS", notes = "로그인을 원하는 유저의 username, email" +
            ", profile_image를 json으로 보내주세요.(iOS)")
    @PostMapping("/login/naver/ios")
    public ApiResult<JwtResponse> loginNaverIos(
            @RequestBody LoginRequestWithUserInfo loginRequestWithUserInfo) {
        return ApiResult.success(loginService.loginWithUserInfo(loginRequestWithUserInfo,
                SocialLogin.NAVER));
    }

    @LoginRequired
    @GetMapping("/jwt")
    public String checkJwt(@UserId Long userId) {
        log.info("user id : {}", userId);
        return userId.toString();
    }
}
