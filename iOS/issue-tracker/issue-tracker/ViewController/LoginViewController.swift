import UIKit
import Combine
import AuthenticationServices
import GoogleSignIn
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser
import NaverThirdPartyLogin

class LoginViewController: UIViewController, ASWebAuthenticationPresentationContextProviding {

    private var webAuthSession: ASWebAuthenticationSession?
    private let loginUseCase = LoginUseCase()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureGitHubLogin()
        configureGoogleLogin()
    }
    
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return self.view.window ?? ASPresentationAnchor()
    }
    
    private func configureGitHubLogin() {
        guard let githubLoginURL = loginUseCase.gitHubLoginURL() else { return }
        let callbackURLScheme = loginUseCase.callbackURLscheme()
        
        self.webAuthSession = ASWebAuthenticationSession.init(url: githubLoginURL, callbackURLScheme: callbackURLScheme, completionHandler: { [weak self] callBack, error in
            guard error == nil, let callBack = callBack else {
                return
            }
            
            let logInURL = self?.loginUseCase.convertToGitHubLogInURL(from: callBack) 
            
            self?.loginUseCase.executeGitHubLogIn(url: logInURL) { completion in
                if completion {
                    DispatchQueue.main.async {
                        self?.performSegue(withIdentifier: "ToIssueList", sender: nil)
                    }
                } else {
                    // 알러트 띄우기
                    print("로그인 에러")
                }
            }
        })
        self.webAuthSession?.presentationContextProvider = self
    }
    
    @IBAction func pressedGithubLogin(_ sender: UIButton) {
        webAuthSession?.start()
    }
    
    @IBAction func pressedGoogleLogin(_ sender: UIButton) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func pressedKakaoLogin(_ sender: UIButton) {
        UserApi.shared.loginWithKakaoAccount(prompts: [.Login]) {[weak self] _, error in
            if let error = error {
                // 알러트
                print(error.localizedDescription)
                return
            } else {
                UserApi.shared.me { user, error in
                    if let error = error {
                        // 알러트
                        print(error.localizedDescription)
                    } else {
                        if let username = user?.kakaoAccount?.profile?.nickname, let email = user?.kakaoAccount?.email, let profileImage = user?.kakaoAccount?.profile?.thumbnailImageUrl {
                            let userInfo = LoginDTO(email: email, username: username, profileImage: profileImage.absoluteString)
                            self?.loginUseCase.executeSocialLogIn(url: .kakao, userInfo: userInfo, completion: { [weak self] completion in
                                if completion {
                                    DispatchQueue.main.async {
                                        self?.performSegue(withIdentifier: "ToIssueList", sender: nil)
                                    }
                                } else {
                                    // 알러트
                                    print("로그인 에러")
                                }
                            })
                        }
                        
                    }
                }
            }
        }
    }
    
    @IBAction func pressedNaverLogin(_ sender: UIButton) {
        let naverLogin = NaverThirdPartyLoginConnection.getSharedInstance()
        naverLogin?.delegate = self
        naverLogin?.resetToken()
        naverLogin?.requestThirdPartyLogin()
    }
    
}

extension LoginViewController: GIDSignInDelegate {
    
    func configureGoogleLogin() {
        GIDSignIn.sharedInstance().presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            // 알러트
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print(error.localizedDescription)
            }
            return
        }
        
        let dimension = UInt(round(100 * UIScreen.main.scale))
        if let username = user.profile.name, let email = user.profile.email,
           let profileImage = user.profile.imageURL(withDimension: dimension) {
            let userInfo = LoginDTO(email: email, username: username, profileImage: profileImage.absoluteString)
            self.loginUseCase.executeSocialLogIn(url: .google, userInfo: userInfo) { [weak self] completion in
                if completion {
                    DispatchQueue.main.async {
                        self?.performSegue(withIdentifier: "ToIssueList", sender: nil)
                    }
                } else {
                    // 알러트
                    print("로그인 에러")
                }
            }
        }
    }
    
}

extension LoginViewController: NaverThirdPartyLoginConnectionDelegate {
    
    func getNaverInfo() {
        let naverLogin = NaverThirdPartyLoginConnection.getSharedInstance()
        guard let isValidAccessToken = naverLogin?.isValidAccessTokenExpireTimeNow(), isValidAccessToken == true else { return }
        
        guard let tokenType = naverLogin?.tokenType else { return }
        guard let accessToken = naverLogin?.accessToken else { return }
        guard let naverLoginURL = loginUseCase.naverLoginURL() else { return }
        let authorization = "\(tokenType) \(accessToken)"
        
        self.loginUseCase.executeFetchingNaverUserInfo(url: naverLoginURL, authorization: authorization) { [weak self] userInfo in
            self?.loginUseCase.executeSocialLogIn(url: .naver, userInfo: userInfo, completion: { [weak self] completion in
                if completion {
                    DispatchQueue.main.async {
                        self?.performSegue(withIdentifier: "ToIssueList", sender: nil)
                    }
                } else {
                    // 알러트
                    print("로그인 에러")
                }
            })
        }
        
    }
    
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        getNaverInfo()
    }
    
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        
    }
    
    func oauth20ConnectionDidFinishDeleteToken() {
        let naverLogin = NaverThirdPartyLoginConnection.getSharedInstance()
        naverLogin?.requestDeleteToken()
    }
    
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        
    }
    
}

extension LoginViewController: Identifying { }
