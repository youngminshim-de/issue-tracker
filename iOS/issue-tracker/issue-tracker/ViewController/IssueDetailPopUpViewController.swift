import UIKit
import Combine

protocol IssueDetailPopUpViewControllerDelegate: AnyObject {
    func IssueDetailPopUpViewControllerDidFinishEditing()
    func IssueDetailPopUpViewControllerDidFinishDeleting()
}

class IssueDetailPopUpViewController: UIViewController {
    @IBOutlet weak var dimmedView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerBottomConstraint: NSLayoutConstraint!
    @IBOutlet var detailInfoEditButtons: [UIButton]!
    
    @IBOutlet weak var issueLabel: UILabel!
    @IBOutlet weak var issueMilestone: UILabel!
    @IBOutlet weak var issueAssignee: UILabel!
    @IBOutlet weak var issueStateLabel: UILabel!
    
    private var issueDetailPopUpViewModel = IssueDetailPopUpViewModel()
    private var subscriptions = Set<AnyCancellable>()
    
    weak var delegate: IssueDetailPopUpViewControllerDelegate?
    
    let defaultHeight: CGFloat = 355
    let defaultBottomOffset: CGFloat = 10
    let dismissibleHeight: CGFloat = 200
    let maximumContainerHeight: CGFloat = 400
    var currentContainerHeight: CGFloat = 355
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        setupPanGesture()
        configureButtonsBackgroudColor()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animatePresentViewController()
        animateShowDimmedView()
    }
    
    private func bind() {
        self.issueDetailPopUpViewModel.didUpdateIssueDetail()
            .sink { [weak self] issueDetail in
                guard let issueDetail = issueDetail else { return }
                self?.issueLabel.text = issueDetail.label
                self?.issueMilestone.text = issueDetail.milestone
                self?.issueAssignee.text = issueDetail.assignees.first?.username
                self?.issueStateLabel.text = self?.issueDetailPopUpViewModel.issueStateLabel()
            }.store(in: &subscriptions)
        
        self.issueDetailPopUpViewModel.didUpdateResultMessage()
            .sink { [weak self] resultMessage in
                if resultMessage == .additionInfoEdited {
                    self?.issueDetailPopUpViewModel.fetchIssueDetail()
                } else if resultMessage == .stateChanged {
                    self?.issueEditViewControllerDidFinish()
                } else if resultMessage == .delete {
                    self?.animateDismissView()
                    self?.delegate?.IssueDetailPopUpViewControllerDidFinishDeleting()
                }
            }.store(in: &subscriptions)
    }
    
    private func animatePresentViewController() {
        UIView.animate(withDuration: 0.3) {
            self.containerBottomConstraint.constant = self.defaultBottomOffset
            self.view.layoutIfNeeded()
        }
    }

    private func animateShowDimmedView() {
        let dimmedViewMaxAlpha: CGFloat = 0.6
        dimmedView.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = dimmedViewMaxAlpha
        }
    }
    
    private func animateDismissView() {
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
    
    private func animateContainerHeight(_ height: CGFloat) {
        UIView.animate(withDuration: 0.4) {
            self.containerHeightConstraint.constant = height
            self.view.layoutIfNeeded()
        }
        currentContainerHeight = height
    }

    private func setupPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(gesture:)))
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        view.addGestureRecognizer(panGesture)
    }
    
    private func configureButtonsBackgroudColor() {
        self.detailInfoEditButtons.forEach { button in
            button.setBackgroundColor(UIColor(white: 1, alpha: 1), for: .normal)
        }
    }
    
    func setIssueDetail(_ issueDetail: IssueDetail?) {
        self.issueDetailPopUpViewModel.setIssueDetail(issueDetail)
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
    
    @IBAction func pressedEditIssueInfo(_ sender: UIButton) {
        var infoType: IssueAdditionalInfo?
        switch sender {
        case self.detailInfoEditButtons[0]:
            infoType = .label
        case self.detailInfoEditButtons[1]:
            infoType = .milestone
        case self.detailInfoEditButtons[2]:
            infoType = .assignee
        default:
            break
        }
        
        guard let additionalViewController = self.storyboard?.instantiateViewController(identifier: AdditionalInfoViewController.identifier) as? AdditionalInfoViewController,
            let infoType = infoType else { return }
        
        additionalViewController.setAdditionalInfoType(of: infoType)
        additionalViewController.delegate = self
        present(additionalViewController, animated: true, completion: nil)
    }
    
    @IBAction func pressedIssueEditButton(_ sender: UIButton) {
        guard let issueEditViewController = self.storyboard?.instantiateViewController(identifier: IssueEditViewController.identifier) as? IssueEditViewController else { return }
        
        let issueID = self.issueDetailPopUpViewModel.issueID()
        let issueTitle = self.issueDetailPopUpViewModel.issueTitle()
        issueEditViewController.setIssueInfo(issueID: issueID, title: issueTitle)
        issueEditViewController.delegate = self
        
        issueEditViewController.modalPresentationStyle = .overCurrentContext
        self.present(issueEditViewController, animated: false, completion: nil)
    }
    
    @IBAction func pressedChangingIssueStateButton(_ sender: UIButton) {
        self.issueDetailPopUpViewModel.changeIssueState()
    }
    
    @IBAction func pressedIssueDeleteButton(_ sender: UIButton) {
        self.issueDetailPopUpViewModel.deleteIssue()
    }
    
}

extension IssueDetailPopUpViewController: AdditionalInfoViewControllerDelegate {
    
    func AdditionalInfoViewControllerDidFinish(additionalInfo: [AdditionalInfo], infoType: IssueAdditionalInfo) {
        self.issueDetailPopUpViewModel.editIssueInfo(additionalInfo: additionalInfo, infoType: infoType)
    }
    
}

extension IssueDetailPopUpViewController: IssueEditViewControllerDelegate {
    
    func issueEditViewControllerDidFinish() {
        self.delegate?.IssueDetailPopUpViewControllerDidFinishEditing()
        animateDismissView()
    }
    
}

extension IssueDetailPopUpViewController: Identifying { }

// assignee 추가가 status 500으로 되지 않음.
