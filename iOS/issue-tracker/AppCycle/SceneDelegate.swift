import UIKit
import GoogleSignIn

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let scheme = URLContexts.first?.url.scheme else { return }
        if scheme.contains("com.googleusercontent.apps") {
            GIDSignIn.sharedInstance().handle(URLContexts.first?.url)
        }
    }
    
}
