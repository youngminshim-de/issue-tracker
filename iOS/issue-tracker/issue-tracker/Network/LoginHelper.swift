import Foundation
import Combine

class LoginHelper {
    
    private let callbackURLScheme = "issueTracker"
    private let gitHubLoginUrlString = "https://github.com/login/oauth/authorize?client_id=04fb3475fc652d5304a3"
    private let naverLoginUrlString = "https://openapi.naver.com/v1/nid/me"
    
    func callbackURLscheme() -> String {
        return callbackURLScheme
    }
    
    func gitHubLoginURL() -> URL? {
        return URL(string: gitHubLoginUrlString)
    }
    
    func naverLoginURL() -> URL? {
        return URL(string: naverLoginUrlString)
    }
    
    func extractedAuthorizationCode(from url: URL) -> String {
        guard let code = url.absoluteString.components(separatedBy: "=").last else {
            return ""
        }
        return code
    }
    
    func convertedToURL(with code: String) -> URL? {
        let loginURLString = "http://www.sionn.net/api/login/github/ios?code=\(code)"
        return URL(string: loginURLString)
    }
    
}
