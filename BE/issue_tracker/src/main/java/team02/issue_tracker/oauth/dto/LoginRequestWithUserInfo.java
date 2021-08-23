package team02.issue_tracker.oauth.dto;

import lombok.Getter;
import team02.issue_tracker.domain.User;

@Getter
public class LoginRequestWithUserInfo {
    private String username;
    private String email;
    private String profile_image;

    public User becomeUser(SocialLogin oauthResource) {
        return User.builder()
                .oauthResource(oauthResource)
                .username(username)
                .email(email)
                .profileImage(profile_image)
                .build();
    }
}
