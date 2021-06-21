//
//  OAuthManager.swift
//  Issue-Trackker
//
//  Created by 심영민 on 2021/06/20.
//

import Foundation
import AuthenticationServices

class OAuthManager: NSObject, ASWebAuthenticationPresentationContextProviding {
    
    private var parentViewController: UIViewController
    private (set) static var code: String = ""
    
    init(parentViewController: UIViewController) {
        self.parentViewController = parentViewController
    }
    
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return parentViewController.view.window ?? ASPresentationAnchor()
    }
    
    func excuteOAuth() {
        var webAuthSession: ASWebAuthenticationSession?
        
        let callbackUrlScheme = "Issue-Trackker"
        let url = URL(string: "https://github.com/login/oauth/authorize?client_id=a29c360109b82f566f16")
        
        webAuthSession = ASWebAuthenticationSession.init(url: url!, callbackURLScheme: callbackUrlScheme, completionHandler: { (callBack:URL?, error:Error?) in
            guard error == nil, let successURL = callBack else {
                print("실패")
                return
            }
            
            let oauthToken = NSURLComponents(string: (successURL.absoluteString))?.queryItems?.filter({$0.name == "code"}).first
            
            let tempString: String = "\(oauthToken!)"
            OAuthManager.code = tempString
            let urlurl: URL = URL(string: "http://3.35.141.227:8080/git/login/ios?\(tempString)")!
            var request: URLRequest = URLRequest(url: urlurl)
            request.httpMethod = "POST"
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                StorageManager.shared.createUser(String(data: data!, encoding: String.Encoding.utf8) ?? "")
//                print(String(data: data!, encoding: String.Encoding.utf8))
            }.resume()
        })
        
        webAuthSession?.presentationContextProvider = self
        webAuthSession?.start()
    }
}
