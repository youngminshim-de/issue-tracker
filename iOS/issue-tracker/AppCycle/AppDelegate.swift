import UIKit
import GoogleSignIn
import KakaoSDKCommon
import NaverThirdPartyLogin

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        GIDSignIn.sharedInstance().clientID = "689416066060-dpkqo93md5p0jd5hjam6ffk91194ur23.apps.googleusercontent.com"
        
        KakaoSDKCommon.initSDK(appKey: "d1fe723c06b88fc6be36ca194be3398a")
        
        let naverLogin = NaverThirdPartyLoginConnection.getSharedInstance()
        naverLogin?.isInAppOauthEnable = true
        naverLogin?.serviceUrlScheme = kServiceAppUrlScheme
        naverLogin?.consumerKey = kConsumerKey
        naverLogin?.consumerSecret = kConsumerSecret
        naverLogin?.appName = kServiceAppName
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        NaverThirdPartyLoginConnection.getSharedInstance().application(app, open: url, options: options)
        
        return true
    }
    
}
