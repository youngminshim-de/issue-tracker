import UIKit
import GoogleSignIn
import KakaoSDKCommon

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        GIDSignIn.sharedInstance().clientID = "689416066060-dpkqo93md5p0jd5hjam6ffk91194ur23.apps.googleusercontent.com"
        
        KakaoSDKCommon.initSDK(appKey: "d1fe723c06b88fc6be36ca194be3398a")
        
        return true
    }
    
}
