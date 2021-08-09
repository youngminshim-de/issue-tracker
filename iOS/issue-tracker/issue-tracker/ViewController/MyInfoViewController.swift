import UIKit
import Combine

class MyInfoViewController: UIViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var logInResourceLabel: UILabel!
    @IBOutlet weak var postingsCountLabel: UILabel!
    @IBOutlet weak var logOutButton: UIButton!
    
    private var myInfoViewModel = MyInfoViewModel()
    private var subscriptions = Set<AnyCancellable>()
    
    private let jwtManager = JWTManager()
    private let myInfo = MyInfo.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        configureUserInfo()
        configureButtonBackgroundColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.myInfoViewModel.configurePostingsCount(myInfo.postingsCount)
    }
    
    private func bind() {
        self.myInfoViewModel.didUpdatePostingsCount()
            .sink { [weak self] count in
                self?.postingsCountLabel.text = count
            }.store(in: &subscriptions)
        
        self.myInfoViewModel.didUpdateLogInResource()
            .sink { [weak self] resource in
                self?.logInResourceLabel.text = resource
            }.store(in: &subscriptions)
    }
    
    private func configureButtonBackgroundColor() {
        logOutButton.setBackgroundColor(UIColor(white: 1, alpha: 1), for: .normal)
    }
    
    private func configureUserInfo() {
        self.usernameLabel.text = myInfo.userName
        self.myInfoViewModel.configureLogInResource(myInfo.oauthResource)
        setProfileImage(urlString: myInfo.profileImage)
    }
    
    private func setProfileImage(urlString: String) {
        DispatchQueue.global().async {
            guard let url = URL(string: urlString) else { return }
            let imageData = try? Data(contentsOf: url)
            guard let data = imageData, let profileImage = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
                self.profileImageView.image = profileImage
            }
        }
    }
    
    @IBAction func pressedLogOutButton(_ sender: UIButton) {
        // JWT 지우기 실패시
        guard self.jwtManager.remove() else { return }
        
        guard let logInViewController = self.storyboard?.instantiateViewController(identifier: LoginViewController.identifier) as? LoginViewController else { return }
        
        guard let delegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
        delegate.changeRootViewController(logInViewController)
    }
    
}
