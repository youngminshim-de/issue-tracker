package team02.issue_tracker.oauth.service;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import team02.issue_tracker.domain.User;
import team02.issue_tracker.oauth.dto.*;
import team02.issue_tracker.oauth.jwt.JwtFactory;
import team02.issue_tracker.service.UserService;

@Slf4j
@Service
public class LoginService {

    private final GithubLoginService githubLoginService;
    private final GoogleLoginService googleLoginService;
    private final KakaoLoginService kakaoLoginService;
    private final NaverLoginService naverLoginService;

    private final UserService userService;
    private final JwtFactory jwtFactory;

    public LoginService(GithubLoginService githubLoginService,
                        GoogleLoginService googleLoginService,
                        KakaoLoginService kakaoLoginService,
                        NaverLoginService naverLoginService,
                        UserService userService, JwtFactory jwtFactory) {
        this.githubLoginService = githubLoginService;
        this.googleLoginService = googleLoginService;
        this.kakaoLoginService = kakaoLoginService;
        this.naverLoginService = naverLoginService;
        this.userService = userService;
        this.jwtFactory = jwtFactory;
    }

    public JwtResponse loginWithCode(final String code, final SocialLogin oauthResource) {
        SocialProfile socialProfile;
        switch (oauthResource) {
            case GITHUB_WEB:
                socialProfile = githubLoginService.requestUserProfileWeb(code);
                break;
            case GITHUB_IOS:
                socialProfile = githubLoginService.requestUserProfileIos(code);
                break;
            case GOOGLE_WEB:
                socialProfile = googleLoginService.requestUserProfile(code);
                break;
            case KAKAO_WEB:
                socialProfile = kakaoLoginService.requestUserProfile(code);
                break;
            case NAVER_WEB:
                socialProfile = naverLoginService.requestUserProfile(code);
                break;
            default:
                throw new IllegalStateException("Unexpected value: " + oauthResource);
        }
        User user = userFrom(socialProfile.becomeUser());
        return jwtFactory.codeUserToJwt(user);
    }

    /**
     * iOS 소셜 로그인의 경우 깃허브를 제외한 구글, 네이버, 카카오에서는 프론트에서 인증코드부터 유저정보까지 받아옵니다.
     * 백엔드 API는 프론트에서 받은 유저정보로 로그인을 수행합니다(자동 회원가입)
     * @param loginRequestWithUserInfo
     * @param oauthResource
     * @return
     */
    public JwtResponse loginWithUserInfo(final LoginRequestWithUserInfo loginRequestWithUserInfo,
                                         final SocialLogin oauthResource) {
        User loginRequestedUser = loginRequestWithUserInfo.becomeUser(oauthResource);
        User user = userFrom(loginRequestedUser);
        log.info(user.toString());
        return jwtFactory.codeUserToJwt(user);
    }

    private User userFrom(final User loginRequestedUser) {
        User user = userService.findByUser(loginRequestedUser);
        if (user == null) {
            user = userService.enroll(loginRequestedUser);
        }
        return user;
    }
}
