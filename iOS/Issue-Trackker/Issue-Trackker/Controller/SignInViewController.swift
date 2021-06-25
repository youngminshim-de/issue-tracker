//
//  ViewController.swift
//  Issue-Trackker
//
//  Created by 심영민 on 2021/06/08.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var githubSignInButton: UIButton!
    @IBOutlet weak var appleSignInButton: UIButton!
    
    private var oauthManager: OAuthManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        oauthManager = OAuthManager(parentViewController: self)
    }
    
    @IBAction func signInButtonToucehd(_ sender: UIButton) {
        moveNetxViewController()
    }
    
    @IBAction func githubSignInButtonTouched(_ sender: UIButton) {
        oauthManager.excuteOAuth() { result in
            switch result {
            case .success(_):
                self.moveNetxViewController()
            case .failure(_):
                break
            }
        }
    }
    
    private func moveNetxViewController() {
        let issueViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "Tabbar")
        issueViewController.modalPresentationStyle = .fullScreen
        self.present(issueViewController, animated: true, completion: nil)
    }
}

