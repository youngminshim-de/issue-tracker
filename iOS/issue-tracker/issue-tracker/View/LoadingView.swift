import UIKit

class LoadingView {
    
    private var viewController: UIViewController?
    private var alert: UIAlertController!
    private var message: String?
    
    func initilize(viewController: UIViewController, message: String? = nil) {
        self.viewController = viewController
        self.alert = UIAlertController(title: nil, message: message ?? "잠시만 기다려주세요.", preferredStyle: .alert)
        let indicatorFrame = CGRect(x: 10, y: 5, width: 50, height: 50)
        let loadingIndicator = UIActivityIndicatorView(frame: indicatorFrame)
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = .medium
        loadingIndicator.startAnimating()
        alert.view.addSubview(loadingIndicator)
    }
    
    func start() {
        viewController?.present(alert, animated: true, completion: nil)
    }
    
    func stop() {
        alert.dismiss(animated: true, completion: nil)
    }
    
}
