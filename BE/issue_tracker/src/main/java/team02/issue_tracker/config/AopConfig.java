package team02.issue_tracker.config;

import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.*;
import org.springframework.context.annotation.EnableAspectJAutoProxy;
import org.springframework.stereotype.Component;
import org.springframework.util.StopWatch;
import team02.issue_tracker.dto.ApiResult;
import team02.issue_tracker.oauth.dto.JwtResponse;

/**
 * @date 2021.06.18
 * @author Shion
 */
@Slf4j
@EnableAspectJAutoProxy
@Aspect
@Component
public class AopConfig {

    private static int count = 0;

    @Pointcut("execution(* team02.issue_tracker.oauth.controller.OAuthController.*login*(..))")
    private void login() {}

    @Pointcut("execution(* team02.issue_tracker.controller..*.*(..))")
    private void all() {}

    @Before("all()")
    public void methodNameLog(JoinPoint joinPoint) {
        count++;
        log.info(count + " request name : " + joinPoint.getSignature().getName());
    }

    /**
     * OAuth 인증코드를 출력한다.
     * @param joinPoint
     */
    @Before("login()")
    public void authorizationCodeLog(JoinPoint joinPoint) {
        log.info("Authorization code : {}", joinPoint.getArgs());
    }

    /**
     * 발행한 jwt를 출력한다.
     * @param joinPoint
     * @param jwtResponse
     */
    @AfterReturning(pointcut = "login()", returning = "jwtResponse")
    public void jwtLog(JoinPoint joinPoint, ApiResult<JwtResponse> jwtResponse) {
        log.info("jwt : {}", jwtResponse.getData().getJwt());
    }
}
