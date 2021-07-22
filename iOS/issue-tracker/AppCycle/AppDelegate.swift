import UIKit
import GoogleSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        GIDSignIn.sharedInstance().clientID = "689416066060-dpkqo93md5p0jd5hjam6ffk91194ur23.apps.googleusercontent.com"
        
        return true
    }
    
}
