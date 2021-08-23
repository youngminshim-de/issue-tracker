package team02.issue_tracker.controller;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import team02.issue_tracker.domain.User;
import team02.issue_tracker.dto.ApiResult;
import team02.issue_tracker.dto.UserInfoResponse;
import team02.issue_tracker.oauth.annotation.LoginRequired;
import team02.issue_tracker.oauth.annotation.UserId;
import team02.issue_tracker.service.UserService;

import java.util.List;

@Api(tags = {"유저 관련 API"}, description = "로그인된 유저의 정보 조회 가능합니다.")
@RestController
public class UserController {

    private final UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
    }

    @ApiOperation(value = "유저 정보 조회", notes = "Authorization 헤더에 JWT 토큰을 담아서 요청하시면 유저 정보를 불러올 수 있습니다.")
    @LoginRequired
    @GetMapping("/api/user")
    public ApiResult<UserInfoResponse> showUserInfo(@UserId Long id) {
        User user = userService.findOne(id);
        return ApiResult.success(new UserInfoResponse(user));
    }

    @ApiOperation(value = "전체 유저 조회", notes = "전체 유저 정보를 조회합니다")
    @GetMapping("/api/users")
    public ApiResult<List<UserInfoResponse>> showAllUsers() {
        return ApiResult.success(userService.getAllUserInfoResponses());
    }
}
