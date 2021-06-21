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
        let url = URL(string: "https://github.com/login/oauth/authorize?client_id=4e0168ba02f62f435d04")
        
        webAuthSession = ASWebAuthenticationSession.init(url: url!, callbackURLScheme: callbackUrlScheme, completionHandler: { (callBack:URL?, error:Error?) in
            guard error == nil, let successURL = callBack else {
                print("실패")
                return
            }
            
            let oauthToken = NSURLComponents(string: (successURL.absoluteString))?.queryItems?.filter({$0.name == "code"}).first
            
            let tempString: String = "\(oauthToken!)"
            OAuthManager.code = tempString
            let urlurl: URL = URL(string: "http://3.35.2.191/git/login?code=\(tempString)")!
            var request: URLRequest = URLRequest(url: urlurl)
            request.httpMethod = "GET"
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                print(String(data: data!, encoding: String.Encoding.utf8))
            }.resume()
        })
        
        webAuthSession?.presentationContextProvider = self
        webAuthSession?.start()
    }
    
}
