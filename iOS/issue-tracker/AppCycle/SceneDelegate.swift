import UIKit
import GoogleSignIn
import NaverThirdPartyLogin

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let scheme = URLContexts.first?.url.scheme else { return }
        if scheme.contains("com.googleusercontent.apps") {
            GIDSignIn.sharedInstance().handle(URLContexts.first?.url)
        }
        
        if scheme.contains("naver") {
            NaverThirdPartyLoginConnection.getSharedInstance().receiveAccessToken(URLContexts.first?.url)
        }
    }
    
    func changeRootViewController(_ viewController: UIViewController) {
        guard let window = self.window else {
            return
        }
        
        window.rootViewController = viewController
        
        UIView.transition(with: window, duration: 0.8, options: [.transitionCurlUp], animations: nil, completion: nil)
    }
    
}
