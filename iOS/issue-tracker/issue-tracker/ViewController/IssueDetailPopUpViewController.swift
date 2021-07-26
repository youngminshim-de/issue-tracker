import UIKit

class IssueDetailPopUpViewController: UIViewController {
    @IBOutlet weak var dimmedView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    let defaultHeight: CGFloat = 310
    let defaultBottomOffset: CGFloat = 10
    let dismissibleHeight: CGFloat = 150
    let maximumContainerHeight: CGFloat = 400
    var currentContainerHeight: CGFloat = 310
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPanGesture()
        configureButtonsBackgroudColor()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animatePresentViewController()
        animateShowDimmedView()
    }
    
    func animatePresentViewController() {
        UIView.animate(withDuration: 0.3) {
            self.containerBottomConstraint.constant = self.defaultBottomOffset
            self.view.layoutIfNeeded()
        }
    }

    func animateShowDimmedView() {
        let dimmedViewMaxAlpha: CGFloat = 0.6
        dimmedView.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = dimmedViewMaxAlpha
        }
    }
    
    func animateDismissView() {
        UIView.animate(withDuration: 0.3) {
            self.containerBottomConstraint.constant = self.defaultHeight
            self.view.layoutIfNeeded()
        }
        
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = 0
        } completion: { _ in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    func animateContainerHeight(_ height: CGFloat) {
        UIView.animate(withDuration: 0.4) {
            self.containerHeightConstraint.constant = height
            self.view.layoutIfNeeded()
        }
        currentContainerHeight = height
    }

    func setupPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(gesture:)))
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        view.addGestureRecognizer(panGesture)
    }
    
    func configureButtonsBackgroudColor() {
        self.editButton.setBackgroundColor(UIColor(white: 1, alpha: 1), for: .normal)
        self.closeButton.setBackgroundColor(UIColor(white: 1, alpha: 1), for: .normal)
        self.deleteButton.setBackgroundColor(UIColor(white: 1, alpha: 1), for: .normal)
    }
    
    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let isDraggingDown = translation.y > 0
        let newHeight = currentContainerHeight - translation.y
        
        switch gesture.state {
        case .changed:
            if newHeight < maximumContainerHeight {
                containerHeightConstraint.constant = newHeight
                view.layoutIfNeeded()
            }
        case .ended:
            if newHeight < dismissibleHeight {
                self.animateDismissView()
            } else if newHeight < defaultHeight {
                self.animateContainerHeight(defaultHeight)
            } else if newHeight < maximumContainerHeight && isDraggingDown {
                self.animateContainerHeight(defaultHeight)
            } else if newHeight > defaultHeight && !isDraggingDown {
                self.animateContainerHeight(defaultHeight)
            }
        default:
            break
        }
    }
    
    @IBAction func pressedCloseButton(_ sender: UIButton) {
        animateDismissView()
    }
    
}

extension IssueDetailPopUpViewController: Identifying { }
