import Foundation
import Combine
import Alamofire

class LoginUseCase {
    
    private let jwtManager: JWTManageable
    private let loginHelper: LoginHelper
    private let endPoint: EndPoint
    private let networkManager: NetworkManager
    private var subscriptions: Set<AnyCancellable>
    
    init() {
        self.jwtManager = JWTManager()
        self.loginHelper = LoginHelper()
        self.endPoint = EndPoint(scheme: Scheme.http.rawValue, host: Host.base.rawValue, path: Path.api.rawValue + Path.login.rawValue)
        self.networkManager = NetworkManager(requestManager: RequestManager(jwtManager: jwtManager), session: URLSession.shared)
        self.subscriptions = Set<AnyCancellable>()
    }

    func gitHubLoginURL() -> URL? {
        return loginHelper.gitHubLoginURL()
    }
    
    func callbackURLscheme() -> String {
        return loginHelper.callbackURLscheme()
    }
    
    func naverLoginURL() -> URL? {
        return loginHelper.naverLoginURL()
    }
    
    func convertToGitHubLogInURL(from callbackURL: URL) -> URL? {
        let code = self.loginHelper.extractedAuthorizationCode(from: callbackURL)
        return self.loginHelper.convertedToURL(with: code)
    }
    
    func executeGitHubLogIn(url: URL?, completion: @escaping (Bool) -> Void) {
        self.networkManager.sendRequest(with: url, method: .get, type: JWTResponseDTO.self)
            .sink { result in
                switch result {
                case .failure(_):
                    completion(false)
                case .finished:
                    break
                }
            } receiveValue: { [weak self] jwtResponseDTO in
                if self?.jwtManager.set(jwt: jwtResponseDTO.data.jwt) == false {
                    completion(false)
                } else {
                    completion(true)
                }
            }.store(in: &subscriptions)
    }
    
    func executeSocialLogIn(url: SocialLogin, userInfo: LoginDTO, completion: @escaping (Bool) -> Void) {
        let url = endPoint.makeURL(with: url.rawValue)
        self.networkManager.sendRequest(with: url, method: .post, type: JWTResponseDTO.self, body: userInfo)
            .sink { result in
                switch result {
                case .failure(_):
                    completion(false)
                case .finished:
                    break
                }
            } receiveValue: { [weak self] jwtResponseDTO in
                if self?.jwtManager.set(jwt: jwtResponseDTO.data.jwt) == false {
                    completion(false)
                } else {
                    completion(true)
                }
            }.store(in: &subscriptions)
    }
    
    func executeFetchingNaverUserInfo(url: URL, authorization: String, userInfo: @escaping (LoginDTO) -> Void) {
        let urlRequest = AF.request(url, method: .get, headers: ["Authorization" : authorization])
        urlRequest.responseJSON { response in
            guard let result = response.value as? [String: Any],
                  let object = result["response"] as? [String: Any],
                  let username = object["name"] as? String,
                  let email = object["email"] as? String,
                  let profileImage = object["profile_image"] as? String else { return }
            let naverUserInfo = LoginDTO(email: email, username: username, profileImage: profileImage)
            userInfo(naverUserInfo)
        }
    }
    
}
